#!/bin/bash

set -e
echo "[Update]"
sudo apt update
echo -e "\\n[texlive-full]"
sudo apt install -y texlive-full
echo -e "\\n[latexmk]"
sudo apt install -y latexmk
echo -e "\\n[xdotool]"
sudo apt install -y xdotool
echo -e "\\n[neovim-remote]"
pip3 install --user neovim-remote
