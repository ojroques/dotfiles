#!/bin/bash

sudo apt update

# Node.js
echo "Installing Node.js..."
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install -y nodejs

# Yarn
echo "Installing Yarn..."
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

# pip for Python 3
echo "Installing pip for Python 3..."
sudo apt install -y python3-pip

# Jedi, an autocompletion library for Python
echo "Installing Jedi..."
pip3 install jedi

echo "Done."
