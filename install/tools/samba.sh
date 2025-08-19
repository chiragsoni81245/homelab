#!/bin/bash

if ! command -v smbd &>/dev/null; then
    sudo apt install -y samba
fi

sudo systemctl stop smbd

SAMBA_CONFIGURATIONS=$(yq -o json ".samba" "$HOMELAB_CONFIG")


# Rendering samba configurations from the go template engine
echo $SAMBA_CONFIGURATIONS | tpl -f "~/.local/share/homelab/config/samba/smb.conf" > "~/.local/share/homelab/config/samba/.current/smb.conf"
echo $SAMBA_CONFIGURATIONS | tpl -f "~/.local/share/homelab/config/samba/share.conf" > "~/.local/share/homelab/config/samba/.current/share.conf"

if ! cmp -s "/etc/samba/smb.conf" "~/.local/share/homelab/config/samba/.current/smb.conf"; then
    # Copy Samba configurations
    sudo mv /etc/samba/smb.conf /etc/samba/last_backup_smb.conf
    sudo cp ~/.local/share/homelab/config/samba/.current/smb.conf /etc/samba/smb.conf
fi

if ! cmp -s "/etc/samba/share.conf" "~/.local/share/homelab/config/samba/.current/share.conf"; then
    # Copy Samba Shares configurations
    sudo mv /etc/samba/smb.conf /etc/samba/last_backup_smb_share.conf
    sudo cp ~/.local/share/homelab/config/samba/.current/share.conf /etc/samba/share.conf
fi

sudo systemctl start smbd
sudo systemctl enable smbd
