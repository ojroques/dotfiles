#!/bin/bash

set -e
CONFIG_DIR="$HOME"/.config

echo "DOTFILES CONFIGURATION"
echo "------------------------------------------------------------"

mkdir -vp "$HOME"/Documents
mkdir -vp "$HOME"/Downloads
mkdir -vp "$HOME"/.tmp
mkdir -vp "$HOME"/.local/bin
mkdir -vp "$CONFIG_DIR"

echo "[BASH]"
cp -vr bash/.shell "$HOME"
cp -v bash/.bashrc "$HOME"

echo "[GIT]"
cp -v git/.gitconfig "$HOME"

echo "[KITTY]"
cp -vr kitty/ "$CONFIG_DIR"

echo "[NEOVIM]"
mkdir -vp "$CONFIG_DIR"/nvim
cp -v nvim/init.lua "$CONFIG_DIR"/nvim
cp -v nvim/nvim-client.py "$HOME"/.local/bin/nvim-client

echo "[ROFI]"
cp -vr rofi/ "$CONFIG_DIR"

echo "[VIM]"
cp -v vim/.vimrc "$HOME"

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
