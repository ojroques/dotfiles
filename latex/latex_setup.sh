#!/bin/bash

sudo apt update
echo "Installing texlive-full..."
sudo apt install -y texlive-full
echo "Installing latexmk..."
sudo apt install -y latexmk
echo "Installing xdotool..."
sudo apt install -y xdotool
echo "Done."
