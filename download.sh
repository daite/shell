#!/bin/bash

if [ $# -ne 1 ]
then
  echo "You need to specify URL [ex: $(basename $0) URL]"
else
  download_subtitle="yt-dlp $1 --all-subs --skip-download"
  download_video="yt-dlp $1 -v"
  $download_subtitle
  $download_video
fi

