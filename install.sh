#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

export PATH="$HOME/.local/bin:$PATH"
export HOMELAB_CONFIG=~/.local/share/homelab/config.yaml
HOMELAB_INSTALL=~/.local/share/homelab/install

# Give people a chance to retry running the installation
catch_errors() {
  echo -e "\n\e[31mHomelab installation failed!\e[0m"
  echo "You can retry by running: bash ~/.local/share/homelab/install.sh"
}

trap catch_errors ERR

show_logo() {
  clear
  tte -i ~/.local/share/homelab/logo.txt --frame-rate ${2:-120} ${1:-expand}
  echo
}

show_subtext() {
  echo "$1" | tte --frame-rate ${3:-640} ${2:-wipe}
  echo
}

# Install prerequisites
source $HOMELAB_INSTALL/preflight/presentation.sh

# Configuration
show_logo beams 240
show_subtext "Let's install Homelab! [1/4]"
source $HOMELAB_INSTALL/config/config.sh
source $HOMELAB_INSTALL/config/timezones.sh

# Development
show_logo decrypt 920
show_subtext "Installing terminal tools [2/4]"
source $HOMELAB_INSTALL/tools/terminal.sh
source $HOMELAB_INSTALL/tools/nvim.sh
source $HOMELAB_INSTALL/tools/tmux.sh
source $HOMELAB_INSTALL/tools/yt-dlp.sh
source $HOMELAB_INSTALL/tools/docker.sh
source $HOMELAB_INSTALL/tools/samba.sh

# Applications
show_logo beams 240
show_subtext "Installing applications via docker [3/4]"
source $HOMELAB_INSTALL/applications/manage.sh

# Updates
show_logo highlight
show_subtext "Updating system packages [4/4]"
sudo apt update
sudo apt upgrade -y

# Reboot
show_logo laseretch 920
show_subtext "You're done! So we'll be rebooting now..."
sleep 2
reboot
