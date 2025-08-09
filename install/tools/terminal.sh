#!/bin/bash

sudo apt install -y \
  wget unzip tar inetutils-tools net-tools \
  fzf ripgrep jq \
  wl-clipboard htop \
  man tldr less whois plocate bash-completion

if [ ! -f '/usr/local/bin/yq' ]; then
  sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
fi
