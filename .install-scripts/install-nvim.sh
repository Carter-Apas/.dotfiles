#!/bin/bash

# --- 1. Define Package Lists ---

# Packages essential for the system setup (nvim, build tools, etc.)
# Note: 'npm' is included here for the system installation.
CORE_SYSTEM_PACKAGES="neovim git cmake curl unzip make stow ripgrep npm ruff nerd-fonts"
ADDITIONAL="wl-clipboard"

# Additional npm packages to install after system setup
# These are the packages you specifically wanted to list and install via npm.
NPM_PACKAGES=(
  "prettier"
  "fixjson"
)

LUA_PACKAGES="--server=https://luarocks.org/dev luaformatter"

# --- 2. Initial Checks ---

# Check to see if running as root
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root. Try again with: sudo $0"
    exit 1
fi

echo "--- Installing CORE SYSTEM Dependencies ---"

# Detect OS using /etc/os-release (common standard)
if grep -q "ID=arch" /etc/os-release 2>/dev/null; then
    echo "⚙️ Detected Arch Linux. Installing dependencies with pacman..."
    
    # Packages for Neovim (installed directly) and other tools
    # We include all CORE_SYSTEM_PACKAGES here.
    # Added wl-clipboard and nerd-fonts as they were in your original Arch list.
    pacman -Syu --noconfirm $CORE_SYSTEM_PACKAGES $ADDITIONAL

elif grep -qE "ID=(debian|ubuntu|pop)" /etc/os-release 2>/dev/null; then
    echo "⚙️ Detected Debian/Ubuntu-like system. Installing dependencies with apt..."
    
    # Packages for Neovim (installed directly) and other tools
    apt update
    apt install -y $CORE_SYSTEM_PACKAGES

else
    echo "⚠️ Unsupported distribution detected. You may need to manually install the following core packages:"
    echo "    - $CORE_SYSTEM_PACKAGES"
    echo "    Continuing script, but dependencies may be missing."
fi

---
## Installing Additional NPM Packages

# Check if npm is installed before proceeding
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed or not in PATH. Cannot install additional npm packages."
    # We can still proceed with the rest of the script if desired
else
    echo "--- Installing Additional NPM Packages Globally ---"
    # Convert array to space-separated string for npm install
    NPM_PACKAGE_STRING="${NPM_PACKAGES[*]}"

    # Install the packages globally (-g)
    # The '|| true' ensures the script doesn't exit on a single package install failure
    npm install -g $NPM_PACKAGE_STRING
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully installed additional npm packages."
    else
        echo "⚠️ There were issues installing some additional npm packages."
    fi
fi

---
## Launching Neovim

# This assumes USER_HOME is defined elsewhere or you're running this from a known location.
# For simplicity, we'll try to use the current user's home directory if USER_HOME is not set.
USER_HOME=${USER_HOME:-$HOME}

# Change back to home directory 
cd "$USER_HOME" || { echo "❌ Failed to change to home directory: $USER_HOME"; exit 1; }

# Launch Neovim
echo "--- Launching Neovim ---"
nvim

echo "✅ Script finished."
