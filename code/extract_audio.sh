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

# Let's break down the `${input_file##*.}` expression step by step:

# 1. `${...}`: This is a syntax used for parameter expansion in Bash. It allows you to manipulate the value of a variable.
# 2. `${input_file}`: Here, `input_file` is the variable whose value we are expanding.
# 3. `##*.`: This is a pattern matching operator that removes the longest match of the specified pattern from the beginning of the string.
#    - `##`: Indicates that the match should be the longest possible prefix.
#    - `*.`: Matches any characters (`*`) followed by a dot (`.`).
# 4. When `${input_file##*.}` is evaluated:
#    - It removes the longest match of any characters followed by a dot from the beginning of the value stored in the `input_file` variable.
#    - This effectively removes the file extension from the file name stored in `input_file`.

# So, if `input_file` contains a value like `"example_video.mp4"`, then `${input_file##*.}` will evaluate to `"mp4"`, effectively extracting the file extension.

# Now, let's understand `".${input_file##*.}"`:

# - `"."`: This is a literal dot character. It is used to concatenate the dot back to the file extension extracted by `${input_file##*.}`.
# - `${input_file##*.}`: This part evaluates to the file extension, as explained above.

# Putting it all together, `".${input_file##*.}"` effectively represents the file extension with a dot prepended to it. 
# For example, if `input_file` is `"example_video.mp4"`, `".${input_file##*.}"` will evaluate to `".mp4"`. 
# This concatenated string is then used as the suffix to be removed by the `basename -s` command.
