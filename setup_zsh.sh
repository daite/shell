#!/bin/bash

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

# Reload .zshrc to start Powerlevel10k configuration
source ~/.zshrc

echo "Setup complete."
