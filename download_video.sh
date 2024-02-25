#!/bin/bash

# Function to install yt-dlp using Python 3
install_ytdlp_python3() {
    echo "Installing yt-dlp using Python 3..."
    python3 -m pip install yt-dlp
}

# Check if the operating system is macOS
if [[ "$(uname)" == "Darwin" ]]; then
    echo "Detected macOS."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    # Check if Python 3 is installed
    if ! command -v python3 &> /dev/null; then
        echo "Python 3 is not installed. Installing..."
        brew install python@3
    fi
    
    # Check if yt-dlp is installed under Python 3
    if ! command -v yt-dlp &> /dev/null; then
        install_ytdlp_python3
    fi
else
    echo "This script is intended for macOS only."
    exit 1
fi

# Function to download videos asynchronously
download_videos_async() {
    while IFS= read -r url; do
        yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$url" &
    done < "$1"
}

# Check if only one argument provided
if [ $# -eq 1 ]; then
    # Check if it's a file or a single URL
    if [ -f "$1" ]; then
        echo "Downloading videos from URLs listed in file: $1"
        mkdir -p downloaded_videos
        download_videos_async "$1"
    else
        echo "Downloading video from single URL: $1"
        yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$1"
    fi
else
    echo "Usage: $0 input_file.txt or $0 url"
    exit 1
fi

echo "Download initiated. It may take some time to complete."
