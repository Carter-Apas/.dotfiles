#!/bin/bash

# --- 1. Initial Checks ---

# Check to see if running as root
if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run as root. Try again with: sudo $0"
  exit 1
fi

# Check if current directory is the user's home
if [[ "$PWD" != "$HOME" ]]; then
  echo "❌ This script must be run from your home directory: $HOME"
  echo "    Current directory: $PWD"
  exit 1
fi

# --- 2. OS-Specific Dependency Installation ---

echo "--- Installing System Dependencies (Including Neovim) ---"

# Detect OS using /etc/os-release (common standard)
if grep -q "ID=arch" /etc/os-release 2>/dev/null; then
  echo "⚙️  Detected Arch Linux. Installing dependencies and Neovim with pacman..."
  
  # Packages for Neovim (installed directly) and other tools
  # Note: 'fnm' is often available in the Arch community repo or AUR.
  pacman -Syu --noconfirm neovim git cmake curl unzip make stow ripgrep fnm

elif grep -qE "ID=(debian|ubuntu|pop)" /etc/os-release 2>/dev/null; then
  echo "⚙️  Detected Debian/Ubuntu-like system. Installing dependencies and Neovim with apt..."
  
  # Packages for Neovim (installed directly) and other tools
  apt update
  apt install -y neovim git cmake curl unzip make stow ripgrep fnm

else
  echo "⚠️  Unsupported distribution detected. You may need to manually install the following packages:"
  echo "   - neovim, git, cmake, curl, unzip, make, stow, ripgrep, fnm"
  echo "   Continuing script, but dependencies may be missing."
fi

# --- 3. Stow Dotfiles ---

echo "--- Applying Dotfiles with Stow ---"

# Assuming the .dotfiles repository is cloned into ~/.dotfiles
# If your dotfiles are elsewhere, adjust the path.
if [ -d "$HOME/.dotfiles" ]; then
    echo "➡️ Running stow from $HOME/.dotfiles..."
    # Change into the dotfiles directory before stowing
    cd "$HOME/.dotfiles" && stow .
else
    echo "❌ Dotfiles directory not found at $HOME/.dotfiles. Skipping stow."
fi

# --- 4. Launch Neovim ---

echo "--- Launching Neovim ---"

# Change back to home directory (if we changed to .dotfiles)
cd "$HOME"

# Launch Neovim
nvim

echo "✅ Script finished."
