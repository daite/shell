# Summary of Scripts

- [Video Downloader](#video-downloader): Download videos using the yt-dlp library on macOS.
- [Zsh Setup Script](#zsh-setup-script): Automate the setup of Zsh shell with useful plugins and Powerlevel10k theme on macOS.
- [Audio Extractor](#audio-extractor): extract audio from a video file and checks if the size of the audio file exceeds 15MB.

# Video Downloader

This script is designed to download videos using the yt-dlp library. It is specifically tailored for macOS.

## Prerequisites

- macOS operating system
- Python 3
- Homebrew (optional, for installing Python 3)

## Installation

1. **Install Homebrew (if not already installed):**
    ```bash
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```

2. **Install Python 3:**
    ```bash
    brew install python@3
    ```

3. **Install yt-dlp using Python 3:**
    ```bash
    python3 -m pip install yt-dlp
    ```

## Usage

### Downloading Videos or Audio

You can download videos or extract audio either from a list of URLs provided in a text file or directly from a single URL.


# Zsh Setup Script

The `setup_zsh.sh` script automates the setup of Zsh shell with useful plugins and Powerlevel10k theme on macOS.

### Prerequisites

- macOS operating system
- [Homebrew](https://brew.sh/) package manager (automatically installed if not present)
- Bash shell

### Usage

1. Download the script to your macOS system.
2. Make the script executable:
    ```bash
    chmod +x setup_zsh.sh
    ```
3. Run the script:
    ```bash
    ./setup_zsh.sh
    ```

### What it does

- Checks if Homebrew is installed, if not, installs it.
- Installs zsh-autosuggestions and zsh-syntax-highlighting plugins using Homebrew.
- Installs Oh My Zsh shell framework if not already installed.
- Downloads Powerlevel10k theme and adds it to the .zshrc file.
- Reloads .zshrc to start Powerlevel10k configuration.

### Notes

- Make sure to review the script before running it to ensure it meets your requirements.
- After running the script, you may need to restart your terminal or run `source ~/.zshrc` for the changes to take effect.
- Powerlevel10k configuration can be further customized by following the prompts during the first launch.

# Audio Extractor

This shell script extracts audio from a video file and checks if the size of the extracted audio file exceeds 15MB. If the size exceeds the limit, it displays a warning message and deletes the output audio file.

## Prerequisites

- Bash shell
- ffmpeg (to install: `brew install ffmpeg`)

## Usage

1. Clone the repository or download the shell script.
2. Make the script executable:
   ```bash
   chmod +x audio_extractor.sh
   ```
3. Run the script with a video file as a command-line argument
   ```bash
   ./audio_extractor.sh <video_file>
   ```
