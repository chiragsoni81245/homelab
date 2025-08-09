#!/bin/bash

if ! command -v smbd &>/dev/null; then
    sudo apt install -y samba

    sudo systemctl stop smbd

    if [ ! -d '/etc/samba/shares' ]; then
        # Copy Samba configurations
        sudo mv /etc/samba/smb.conf /etc/samba/default_smb.conf
        sudo mv ~/.local/share/homelab/config/sambsa/* /etc/samba/
    fi

    sudo systemctl start smbd
    sudo systemctl enable smbd
fi

