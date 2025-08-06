#!/bin/bash

ansi_art='
  /\  /\___  _ __ ___   ___| | __ _| |__  
 / /_/ / _ \| '_ ` _ \ / _ \ |/ _` | '_ \ 
/ __  / (_) | | | | | |  __/ | (_| | |_) |
\/ /_/ \___/|_| |_| |_|\___|_|\__,_|_.__/ '
clear
echo -e "\n$ansi_art\n"

sudo apt update
sudo apt upgrade -y
sudo apt install git curl pipx -y

# Use custom repo if specified, otherwise default to chiragsoni81245/homelab
HOMELAB_REPO="${HOMELAB_REPO:-chiragsoni81245/homelab}"

echo -e "\nCloning configuration from: https://github.com/${HOMELAB_REPO}.git"
rm -rf ~/.local/share/homelab/
git clone "https://github.com/${HOMELAB_REPO}.git" ~/.local/share/homelab >/dev/null

# Use custom branch if instructed
if [[ -n "$HOMELAB_REF" ]]; then
  echo -e "\eUsing branch: $HOMELAB_REF"
  cd ~/.local/share/homelab
  git fetch origin "${HOMELAB_REF}" && git checkout "${HOMELAB_REF}"
  cd -
fi

echo -e "\nInstallation starting..."
source ~/.local/share/homelab/install.sh
