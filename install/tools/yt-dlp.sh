#!/bin/bash

if [ ! -f '/bin/yt-dlp' ]; then
    sudo wget -O /bin/yt-dlp https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
    sudo chmod +x /bin/yt-dlp
fi
