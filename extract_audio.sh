#!/bin/bash

# Check if a video file is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <video_file>"
    exit 1
fi

# Input video file path
input_file="$1"

# Get the filename (without extension) from the input video file
filename=$(basename -s .${input_file##*.} "$input_file")

# Output audio file path
output_file="${filename}_audio.mp3"

# Extract audio from video
ffmpeg -i "$input_file" -vn -acodec mp3 -ab 128k "$output_file"

# Get the size of the output audio file
audio_size=$(stat -f "%z" "$output_file")

# Define the maximum allowed file size (15 MB)
max_file_size=$((15 * 1024 * 1024))

# Check if the audio file size exceeds the maximum allowed size
if ((audio_size > max_file_size)); then
    echo "Warning: Extracted audio file size exceeds 15MB."
    # Delete the output audio file
    rm "$output_file"
    echo "Output audio file deleted."
else
    echo "Audio extraction successful. Output file size is within the limit."
fi
