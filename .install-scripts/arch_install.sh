#!/bin/bash

# Define an array of all packages to be installed
# This list is consolidated from your original script.
PACKAGES=(
    # Drivers/System
    # nvidia
    # cuda
    # intel-ucode
    # networkmanager

    # Terminal Tools
    wezterm
    unzip
    fzf
    curl
    dnsutils
    base-devel
    htop
    git

    # Auth
    openssh
    less
    keychain

    # Dev
    postgresql 
    azure-cli
    # openjdk-src #??

    # Shell
    fish
    uv

    # Window Manager/Compositor
    hyprland
    hyprpaper
    rofi
    waybar
    hyprlock
    hypridle
    xdg-desktop-portal # For screen sharing
    # Waybar dependencies
    nm-connection-manager
    dunst

    # Sound
    alsa-utils
    pipewire
    pipewire-alsa
    pipewire-pulse

    # Applications
    vlc
    firefox
    discord
)

AUR_PACKAGES=(
    # Dev
    bruno-bin
    tfenv
    pokeget

    # Games
    bolt-launcher
    
    # Window Manager
    hyprshot
  )

NPM_PACKGES=(
    @google/gemini-cli
  )

# --- Installation Steps ---

echo "Starting package synchronization and installation..."
# Sync the database once before installation for efficiency
sudo pacman -Sy

# Use a loop to iterate over the array and install all packages
# The '--needed' flag skips packages that are already installed.
echo "Installing ${#PACKAGES[@]} packages..."
sudo pacman -S --needed "${PACKAGES[@]}"

echo "Installing Yay..."
sudo pacman -S --needed git base-devel && cd ~ && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si # Care for the CD command here

# --- Post-Installation Setup ---

## 1. Setup fish shell
echo "Setting default shell to fish..."
TARGET_USER=${SUDO_USER:-$USER}

# Only proceed if we aren't targeting the 'root' account
if [ "$TARGET_USER" != "root" ] && command -v fish &> /dev/null; then
    echo "⚙️ Changing default shell for user '$TARGET_USER' to Fish..."
    
    # Run chsh with the -s (shell path) and the specific username
    chsh -s /usr/bin/fish "$TARGET_USER"
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully changed shell for $TARGET_USER to /usr/bin/fish."
        echo "   (User '$TARGET_USER' must log out and back in for the change to take effect.)"
    else
        echo "❌ Failed to change shell for $TARGET_USER. Check if fish is installed at /usr/bin/fish."
    fi
else
    if [ "$TARGET_USER" == "root" ]; then
        echo "⚠️ Skipping shell change: TARGET_USER is 'root'. Not changing root's shell."
    else
        echo "⚠️ Skipping shell change: 'fish' command not found. Ensure it was installed."
    fi
fi

## 2. Setup fnm
curl -fsSL https://fnm.vercel.app/install | bash

echo "Installing Node 22"
fnm install 22
fnm use 22
fnm default 22


echo "Installation and setup complete! 🎉"
