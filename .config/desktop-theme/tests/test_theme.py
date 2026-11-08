"""Check palette propagation and switching without changing the real desktop.

Run with: python3 -m unittest discover -s ~/.config/desktop-theme/tests
"""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


THEME_DIR = Path(__file__).resolve().parents[1]
SWITCHER = THEME_DIR.parents[1] / ".local/bin/theme"


class ThemeTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="desktop-theme-test-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.config = self.root / "config"
        self.theme = self.config / "desktop-theme"
        shutil.copytree(THEME_DIR, self.theme, ignore=shutil.ignore_patterns("current", "tests"))
        self.current = self.theme / "current"
        mockbin = self.root / "bin"
        mockbin.mkdir()
        self.state = self.root / "mode"
        self.state.write_text("light")
        self.calls = self.root / "calls"
        mocks = {
            "uname": 'echo "$TEST_PLATFORM"',
            "gsettings": '''
if [[ "$1" == get ]]; then
    printf "'prefer-%s'\\n" "$(cat "$TEST_STATE")"
else
    printf '%s' "${4#prefer-}" > "$TEST_STATE"
fi''',
            "osascript": '''
case "$*" in
    *'set dark mode to true'*) printf dark > "$TEST_STATE" ;;
    *'set dark mode to false'*) printf light > "$TEST_STATE" ;;
    *) if [[ "$(cat "$TEST_STATE")" == dark ]]; then echo true; else echo false; fi ;;
esac''',
            "pgrep": "exit 0",
            "dunstctl": 'echo "dunstctl $*" >> "$TEST_CALLS"',
            "hyprctl": 'echo "hyprctl $*" >> "$TEST_CALLS"',
            "pkill": 'echo "pkill $*" >> "$TEST_CALLS"',
        }
        for name, body in mocks.items():
            path = mockbin / name
            path.write_text("#!/usr/bin/env bash\n" + body + "\n")
            path.chmod(0o755)
        self.env = dict(
            os.environ,
            HOME=str(self.root),
            XDG_CONFIG_HOME=str(self.config),
            PATH=f"{mockbin}:/usr/bin:/bin",
            TEST_PLATFORM="Linux",
            TEST_STATE=str(self.state),
            TEST_CALLS=str(self.calls),
            HYPRLAND_INSTANCE_SIGNATURE="test-session",
        )

    def run_theme(self, action, *, check=True):
        return subprocess.run(
            ["bash", str(SWITCHER), action], env=self.env,
            capture_output=True, text=True, check=check,
        )

    def output(self, name):
        return (self.current / name).read_text()

    def test_both_palettes_generate_all_app_formats(self):
        for mode, bg, accent in [("light", "#f8f9fa", "f2ae49"), ("dark", "#1f2430", "ffcc66")]:
            with self.subTest(mode=mode):
                self.state.write_text(mode)
                self.run_theme("render")
                self.assertIn(bg, self.output("waybar.css"))
                self.assertIn(bg, self.output("rofi.rasi"))
                self.assertIn(bg, self.output("dunst.conf"))
                self.assertIn(f"rgba({accent}ee)", self.output("hyprland.lua"))
                for path in self.current.iterdir():
                    self.assertNotIn("{{", path.read_text())
        self.assertFalse(self.calls.exists(), "render must not reload apps")

    def test_one_accent_edit_propagates_to_all_apps_and_aliases(self):
        path = self.theme / "palettes/dark.sh"
        path.write_text(path.read_text().replace("#ffcc66", "#abcdef"))
        self.state.write_text("dark")
        self.run_theme("render")
        for name in ["waybar.css", "rofi.rasi", "dunst.conf", "hyprland.lua"]:
            self.assertIn("abcdef", self.output(name))
            self.assertNotIn("ffcc66", self.output(name))
        self.assertIn("@define-color theme_yellow #abcdef;", self.output("waybar.css"))

    def test_status_does_not_generate_or_reload(self):
        self.assertEqual(self.run_theme("status").stdout.strip(), "light")
        self.assertFalse(self.current.exists())
        self.assertFalse(self.calls.exists())

    def test_switching_and_apply_follow_system_preference(self):
        for action, mode in [("dark", "dark"), ("toggle", "light"), ("apply", "light")]:
            self.assertEqual(self.run_theme(action).stdout.strip(), mode)
            self.assertEqual(self.state.read_text(), mode)
        calls = self.calls.read_text()
        self.assertEqual(calls.count("dunstctl reload"), 3)
        self.assertEqual(calls.count("hyprctl reload"), 3)
        self.assertEqual(calls.count("pkill -USR2"), 3)

    def test_macos_switches_appearance_without_linux_reloads(self):
        self.env["TEST_PLATFORM"] = "Darwin"
        for action, mode in [("dark", "dark"), ("toggle", "light"), ("apply", "light")]:
            self.assertEqual(self.run_theme(action).stdout.strip(), mode)
            self.assertEqual(self.state.read_text(), mode)
        self.assertFalse(self.calls.exists())

    def test_failed_render_preserves_previous_outputs(self):
        self.run_theme("render")
        before = {p.name: p.read_bytes() for p in self.current.iterdir()}
        (self.theme / "templates/broken.conf").write_text("{{unknown_colour}}")
        self.assertNotEqual(self.run_theme("render", check=False).returncode, 0)
        self.assertEqual(before, {p.name: p.read_bytes() for p in self.current.iterdir()})


if __name__ == "__main__":
    unittest.main()
