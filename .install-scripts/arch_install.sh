#Install drivers yourself, sync git and git stow dotfiles
# sudo pacman -S nvidia 
# sudo pacman -S cuda
# sudo install iwd

# Setup terminal
sudo pacman -S wezterm unzip fzf

# setup nvim
sudo pacman -S ripgrep
sudo pacman -S --noconfirm nerd-fonts
sudo pacman -S xclip

# setup fish
sudo pacman -S fish
chsh -s /bin/fish

# setup background
sudo pacman -S nitrogen
nitrogen ~/backgrounds/
sudo pacman -S picom
picom -b

# audio
sudo pacman -S vlc

# apps
sudo pacman -S firefox

# default
xdg-settings set default-web-browser google-chrome.desktop
