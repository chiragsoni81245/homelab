#!/bin/bash

sudo apt install fzf tmux -y

if [ ! -d "$HOME/.tmux" ]; then
    git clone --single-branch https://github.com/gpakosz/.tmux.git "$HOME/.tmux"
    ln -s -f "$HOME/.tmux/.tmux.conf"
    cp "$HOME/.tmux/.tmux.conf.local" .
fi
