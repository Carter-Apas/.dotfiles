#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "❌ This script must be run as root. Try again with: sudo $0"
  exit 1
fi

sudo apt install -y cmake
sudo apt install -y make
sudo apt install -y stow
sudo apt install -y unzip
sudo apt install -y ripgrep
git clone https://github.com/neovim/neovim.git
sudo make -C ./neovim install
https://github.com/Carter-Apas/.dotfiles.git
cd .dotfiles
stow .

