#!/bin/bash

set -e
CONFIG_DIR="$HOME/.config"

echo "DOTFILES CONFIGURATION"
echo "------------------------------------------------------------"

if [[ ! -d "$CONFIG_DIR" ]]; then
    mkdir -vp "$CONFIG_DIR"
fi

echo "[BASH]"
cp -v bash/.bashrc "$HOME"
cp -v bash/.aliases "$HOME"
cp -v bash/.functions "$HOME"

echo "[GIT]"
cp -v git/.gitconfig "$HOME"

echo "[VIM]"
cp -v vim/.vimrc "$HOME"

echo "[TMUX]"
cp -v tmux/.tmux.conf "$HOME"

echo "[NEOVIM]"
cp -vr nvim/ "$CONFIG_DIR"
rm -f "$CONFIG_DIR"/nvim/lsp.sh

echo "[KITTY]"
cp -vr kitty/ "$CONFIG_DIR"

echo "[ROFI]"
cp -vr rofi/ "$CONFIG_DIR"

if [[ -d "$CONFIG_DIR"/autostart ]]; then
    echo "[SETXKBMAP]"
    cp -v xfce/setxkbmap.desktop "$CONFIG_DIR"/autostart
fi

if [[ -d "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml ]]; then
    echo "[THUNAR]"
    cp -v thunar/thunar.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/

    echo "[XFCE]"
    cp -v xfce/keyboards.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/keyboard-layout.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/xfce4-keyboard-shortcuts.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
fi

echo "------------------------------------------------------------"
echo "Configuration done."
echo "Add your email to ~/.gitconfig."
echo "Run vim then execute ':PlugInstall' to install vim plugins."
