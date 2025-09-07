#!/bin/bash

sudo apt install -y \
  xclip wget unzip tar inetutils-tools net-tools \
  fzf ripgrep jq rsync \
  wl-clipboard htop \
  man tldr less whois plocate bash-completion

if [ ! -f '/usr/local/bin/yq' ]; then
  sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
  sudo chmod +x /usr/local/bin/yq
fi

# tpl for rendering go templates
if [ ! -f '/usr/local/bin/tpl' ]; then
    sudo curl -fsSL https://github.com/bluebrown/go-template-cli/releases/latest/download/tpl-linux-amd64 -o /usr/local/bin/tpl
    sudo chmod 755 /usr/local/bin/tpl
fi
