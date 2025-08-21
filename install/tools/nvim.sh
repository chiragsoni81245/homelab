#!/bin/bash

if ! command -v nvim &>/dev/null; then
  sudo apt install -y ripgrep luarocks

  # Install nvim
  rm -rf ~/.config/nvim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  sudo rm nvim-linux-x86_64.tar.gz 
  sudo mv /opt/nvim-linux-x86_64 /opt/nvim

  # Using my personal nvim configurations
  git clone https://github.com/chiragsoni81245/nvim.git ~/.config/nvim

  # Install Packer and packages with it
  if [ ! -f "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  fi
  /opt/nvim/bin/nvim --headless -c 'so ~/.config/nvim/lua/jarvis/packer.lua' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
fi
