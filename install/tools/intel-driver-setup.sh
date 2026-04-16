#!/bin/bash
# Intel QSV setup for Jellyfin on Ubuntu 24.04

echo "Installing Intel VA-API drivers..."
sudo apt update
sudo apt install -y vainfo libva2 libva-drm2 intel-media-va-driver-non-free

echo "Adding user to GPU groups..."
sudo usermod -aG render,video $USER

echo "Verifying VA-API driver..."
sudo LIBVA_DRIVER_NAME=iHD vainfo --display drm --device /dev/dri/renderD128

echo "Done! Remember to:"
echo "  1. Add LIBVA_DRIVER_NAME=iHD env var to Jellyfin container"
echo "  2. Map /dev/dri:/dev/dri in container devices"
echo "  3. Add render group to container group_add"
echo "  4. Enable QSV in Jellyfin Dashboard -> Playback -> Transcoding"
