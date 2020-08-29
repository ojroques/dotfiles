#!/bin/bash

set -e
CONFIG_DIR="$HOME"/.config

echo "DOTFILES CONFIGURATION"
echo "------------------------------------------------------------"

if [[ ! -d "$CONFIG_DIR" ]]; then
    mkdir -vp "$CONFIG_DIR"
fi

if [[ ! -d "$HOME"/.tmp ]]; then
    mkdir -vp "$HOME"/.tmp
fi

echo "[BASH]"
cp -v bash/.mybashrc "$HOME"
cp -v bash/.aliases "$HOME"
cp -v bash/.functions "$HOME"
line="source ~/.mybashrc"
grep -qxF "$line" $HOME/.bashrc || echo -e "\n$line" >> $HOME/.bashrc

echo "[GIT]"
cp -v git/.gitconfig "$HOME"

echo "[KITTY]"
cp -vr kitty/ "$CONFIG_DIR"

echo "[NEOVIM]"
cp -vr nvim/ "$CONFIG_DIR"
rm -f "$CONFIG_DIR"/nvim/lsp.sh

echo "[ROFI]"
cp -vr rofi/ "$CONFIG_DIR"

echo "[TMUX]"
cp -v tmux/.tmux.conf "$HOME"

echo "[VIM]"
cp -v vim/.vimrc "$HOME"
cp -v vim/.minimal.vimrc "$HOME"

if [[ -d "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml ]]; then
    echo "[THUNAR]"
    cp -v xfce/thunar.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/

    echo "[XFCE]"
    cp -v xfce/keyboards.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/keyboard-layout.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/xfce4-keyboard-shortcuts.xml "$CONFIG_DIR"/xfce4/xfconf/xfce-perchannel-xml/
fi

echo "------------------------------------------------------------"
echo "Configuration done."
echo "Add your email to ~/.gitconfig."
echo "Run vim then execute ':PlugInstall' to install vim plugins."
