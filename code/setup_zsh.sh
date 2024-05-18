#!/bin/bash

# Check if the script is running on macOS
if [[ $(uname) != "Darwin" ]]; then
    echo "This script is intended for macOS only."
    exit 1
fi

# Check if Homebrew is installed, if not, install it
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Check if zsh-autosuggestions and zsh-syntax-highlighting are installed
if ! brew list --formula | grep -q "zsh-autosuggestions"; then
    echo "Installing zsh-autosuggestions..."
    brew install zsh-autosuggestions
fi

if ! brew list --formula | grep -q "zsh-syntax-highlighting"; then
    echo "Installing zsh-syntax-highlighting..."
    brew install zsh-syntax-highlighting
fi

# Check if Oh My Zsh is installed, if not, install it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Manually download and configure Powerlevel10k
echo "Downloading Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Add Powerlevel10k to the .zshrc file
echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc

# Check and install VLC if not installed
if ! brew list --cask | grep -q "vlc"; then
    echo "Installing VLC..."
    brew install --cask vlc
fi

# Check and install Google Chrome if not installed
if ! brew list --cask | grep -q "google-chrome"; then
    echo "Installing Google Chrome..."
    brew install --cask google-chrome
fi

# Check and install qBittorrent if not installed
if ! brew list --cask | grep -q "qbittorrent"; then
    echo "Installing qBittorrent..."
    brew install --cask qbittorrent
fi

# Check and install the latest version of Python 3 if not installed
if ! brew list --formula | grep -q "python@3"; then
    echo "Installing the latest version of Python 3..."
    brew install python@3
fi

# Check and install ffmpeg if not installed
if ! brew list --formula | grep -q "ffmpeg"; then
    echo "Installing ffmpeg..."
    brew install ffmpeg
fi

# Check and install yt-dlp using pip3 if not installed
# error: externally-managed-environment; 
if ! pip3 list | grep -q "yt-dlp"; then
    echo "Installing yt-dlp..."
    python3 -m pip config set global.break-system-packages true
    python3 -m pip install yt-dlp
fi

# Check and install Visual Studio Code if not installed
if ! brew list --cask | grep -q "visual-studio-code"; then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
fi

# Reload .zshrc to start Powerlevel10k configuration
source ~/.zshrc

echo "Setup complete."
