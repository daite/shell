# YouTube Video Downloader

This script is designed to download YouTube videos using the yt-dlp library. It is specifically tailored for macOS.

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

### Downloading Videos

You can download videos either from a list of URLs provided in a text file or directly from a single URL.

**From a text file:**

```bash
./youtube_downloader.sh input_file.txt
./youtube_downloader.sh url
