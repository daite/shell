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
    if [[ $? -ne 0 ]]; then
        echo "Failed to install Homebrew."
        exit 1
    fi
fi

# Array of Homebrew formulae and casks to install
formulae=("zsh-autosuggestions" "zsh-syntax-highlighting" "python@3" "ffmpeg")
casks=("vlc" "google-chrome" "qbittorrent" "visual-studio-code")

# Install Homebrew formulae
for formula in "${formulae[@]}"; then
    if ! brew list --formula | grep -q "$formula"; then
        echo "Installing $formula..."
        brew install "$formula"
        if [[ $? -ne 0 ]]; then
            echo "Failed to install $formula."
        fi
    fi
done

# Install Homebrew casks
for cask in "${casks[@]}"; do
    if ! brew list --cask | grep -q "$cask"; then
        echo "Installing $cask..."
        brew install --cask "$cask"
        if [[ $? -ne 0 ]]; then
            echo "Failed to install $cask."
        fi
    fi
done

# Check if Oh My Zsh is installed, if not, install it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    if [[ $? -ne 0 ]]; then
        echo "Failed to install Oh My Zsh."
        exit 1
    fi
fi

# Manually download and configure Powerlevel10k
if [ ! -d "$HOME/powerlevel10k" ]; then
    echo "Downloading Powerlevel10k..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    if [[ $? -ne 0 ]]; then
        echo "Failed to clone Powerlevel10k."
        exit 1
    fi
fi

# Add Powerlevel10k to the .zshrc file if not already present
if ! grep -q "source ~/powerlevel10k/powerlevel10k.zsh-theme" ~/.zshrc; then
    echo "Adding Powerlevel10k to .zshrc..."
    echo "source ~/powerlevel10k/powerlevel10k.zsh-theme" >> ~/.zshrc
fi

# Check and install yt-dlp using pip3 if not installed
if ! pip3 list | grep -q "yt-dlp"; then
    echo "Installing yt-dlp..."
    python3 -m pip install --break-system-packages yt-dlp
    if [[ $? -ne 0 ]]; then
        echo "Failed to install yt-dlp."
        exit 1
    fi
fi

# Reload .zshrc to start Powerlevel10k configuration
source ~/.zshrc

echo "Setup complete."
