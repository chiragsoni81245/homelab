#!/bin/bash

if ! command -v nvim &>/dev/null; then
  sudo apt install -y luarocks

  # Install nvim
  rm -rf ~/.config/nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  sudo mv /opt/nvim-linux-x86_64 /opt/nvim

  # Using my personal nvim configurations
  git clone https://github.com/chiragsoni81245/nvim.git ~/.config/nvim
  rm -rf ~/.config/nvim/.git
fi
