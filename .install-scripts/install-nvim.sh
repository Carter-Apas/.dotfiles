#!/bin/bash

# Check to see if running as root
if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run as root. Try again with: sudo $0"
  exit 1
fi

# Check if current directory is the user's home
if [[ "$PWD" != "$HOME" ]]; then
  echo "❌ This script must be run from your home directory: $HOME"
  echo "   Current directory: $PWD"
  exit 1
fi

## For various LSP ##
# sudo apt install python3 
# sudo apt install luarocks
# sudo apt install npm

sudo apt install -y cmake
sudo apt install -y make
sudo apt install -y stow
sudo apt install -y unzip
sudo apt install -y ripgrep
git clone https://github.com/neovim/neovim.git
sudo make -C ./neovim install
cd ~/.dotfiles && stow .
nvim

