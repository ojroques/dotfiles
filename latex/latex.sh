#!/bin/bash

set -e

echo "[Update]"
sudo apt-get update

echo -e "\n[neovim-remote]"
pip3 install --user neovim-remote

echo -e "\n[latexmk]"
sudo apt-get install -y latexmk

echo -e "\n[xdotool]"
sudo apt-get install -y xdotool

echo -e "\n[texlive-full]"
sudo apt-get install -y texlive-full
