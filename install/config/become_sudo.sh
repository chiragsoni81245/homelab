#!/bin/bash

USER_NAME=${1:-$USER}

if [ ! -f "/etc/sudoers.d/$USER_NAME" ]; then
    echo "Adding $USER_NAME to passwordless sudo..."

    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER_NAME >/dev/null

    sudo chmod 440 /etc/sudoers.d/$USER_NAME

    echo "Done, $USER_NAME is now a passwordless sudo user."
else
    echo "$USER_NAME is already a passwordless sudo user."
fi