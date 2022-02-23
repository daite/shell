#!/bin/bash

if [ -n "$1"]
then
  echo "You need to specify URL [ex: $(basename $0) URL]"
else
  download_subtitle="youtube-dl $1 --all-subs --skip-download"
  download_video="youtube-dl $1 -v"
  $download_subtitle
  $download_video
fi

