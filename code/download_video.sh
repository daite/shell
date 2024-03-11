#!/bin/bash

# Function to install yt-dlp using Python 3
install_ytdlp_python3() {
    echo "Installing yt-dlp using Python 3..."
    python3 -m pip install yt-dlp
}

# Function to check if a video file already exists
check_video_exists() {
    local file_path="downloaded_videos/$1.$2"
    if [ -f "$file_path" ]; then
        echo "File already exists: $file_path"
        return 0  # File exists
    else
        return 1  # File does not exist
    fi
}

# Function to get title and extension of a video
get_title_and_ext() {
    local url="$1"
    title=$(yt-dlp --get-title "$url")
    ext=$(yt-dlp --get-filename --restrict-filenames -o '%(ext)s' "$url")
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
        get_title_and_ext "$url"
        if check_video_exists "$title" "$ext"; then
            echo "Skipping download for $title.$ext"
        else
            yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$url" &
        fi
    done < "$1"
    wait
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
        get_title_and_ext "$1"
        if check_video_exists "$title" "$ext"; then
            echo "Skipping download for $title.$ext"
        else
            yt-dlp --write-sub -o "downloaded_videos/%(title)s.%(ext)s" "$1" &
        fi
    fi
else
    echo "Usage: $0 input_file.txt or $0 url"
    exit 1
fi

echo "Download initiated. It may take some time to complete."
