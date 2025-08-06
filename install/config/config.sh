#!/bin/bash

# Copy over Homelab configs
cp -R ~/.local/share/homelab/config/* ~/.config/

# Use default bashrc from Homelab
cp ~/.local/share/homelab/default/bashrc ~/.bashrc

# Ensure application directory exists for update-desktop-database
mkdir -p ~/.local/share/applications

# Setup GPG configuration with multiple keyservers for better reliability
sudo mkdir -p /etc/gnupg
sudo cp ~/.local/share/homelab/default/gpg/dirmngr.conf /etc/gnupg/
sudo chmod 644 /etc/gnupg/dirmngr.conf
sudo gpgconf --kill dirmngr || true
sudo gpgconf --launch dirmngr || true

# disable effect of laptop lid switch on power
sudo sed -i 's|^#(HandleLidSwitch|HandleLidSwitchExternalPower|HandleLidSwitchDocked)=\w+|\1=ignore|' "/etc/systemd/logind.conf"

# Set common git aliases
git config --global init.defaultBranch main

# Set identification from install inputs
if [[ -n "${HOMELAB_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$HOMELAB_USER_NAME"
fi

if [[ -n "${HOMELAB_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$HOMELAB_USER_EMAIL"
fi
