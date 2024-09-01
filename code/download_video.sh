#!/bin/bash

# Program version
VERSION="0.2.0"

# Display program version
echo "Script version: $VERSION"

# Function to install or upgrade yt-dlp using Python 3
install_ytdlp_python3() {
    echo "Installing or upgrading yt-dlp using Python 3..."
    python3 -m pip install yt-dlp -U
}

# Function to check if a file (video or audio) already exists
check_file_exists() {
    local file_path="downloaded_videos/$1.$2"
    if [ -f "$file_path" ]; then
        echo "File already exists: $file_path"
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Function to get title and extension of a video or audio
get_title_and_ext() {
    local url="$1"
    title=$(yt-dlp --get-title "$url")
    if [[ "$2" == "audio" ]]; then
        ext="m4a"  # Default extension for audio-only downloads
    else
        ext=$(yt-dlp --get-filename --restrict-filenames -o '%(ext)s' "$url")
    fi
}

# Initialization function to set up the environment and ensure yt-dlp is up to date
init() {
    # Create the directory for downloaded videos if it doesn't exist
    mkdir -p downloaded_videos

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
        
        # Check if yt-dlp is installed under Python 3 and update it
        if ! command -v yt-dlp &> /dev/null; then
            install_ytdlp_python3
        else
            echo "Checking for yt-dlp updates..."
            install_ytdlp_python3
        fi
    else
        echo "This script is intended for macOS only."
        exit 1
    fi
}

# Function to download videos or audio asynchronously
download_async() {
    local mode="$2"
    while IFS= read -r url; do
        get_title_and_ext "$url" "$mode"
        if check_file_exists "$title" "$ext"; then
            echo "Skipping download for $title.$ext"
        else
            if [[ "$mode" == "audio" ]]; then
                yt-dlp --extract-audio --audio-format m4a -o "downloaded_videos/%(title)s.%(ext)s" "$url" &
            else
                yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$url" &
            fi
        fi
    done < "$1"
    wait
}

# Main script logic
init  # Run the initialization function

# Check if only one or two arguments are provided
if [ $# -ge 1 ]; then
    # Determine if audio-only mode is enabled
    if [ "$2" == "--audio" ]; then
        mode="audio"
    else
        mode="video"
    fi

    # Check if the first argument is a file or a single URL
    if [ -f "$1" ]; then
        echo "Downloading $mode from URLs listed in file: $1"
        download_async "$1" "$mode"
    else
        echo "Downloading $mode from single URL: $1"
        get_title_and_ext "$1" "$mode"
        if check_file_exists "$title" "$ext"; then
            echo "Skipping download for $title.$ext"
        else
            if [[ "$mode" == "audio" ]]; then
                yt-dlp --extract-audio --audio-format m4a -o "downloaded_videos/%(title)s.%(ext)s" "$1" &
            else
                yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$1" &
            fi
            wait  # Wait for the download to finish
            local file_path="downloaded_videos/$title.$ext"
            open -a vlc "$file_path"  # Open the file in VLC, properly quotedd
        fi
    fi
else
    echo "Usage: $0 input_file.txt [--audio] or $0 url [--audio]"
    exit 1
fi
echo "Download initiated. It may take some time to complete."
