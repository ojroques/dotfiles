#!/bin/bash

set -e

function update() {
  echo "[Update]"
  sudo apt update
  sudo apt upgrade -y
}

function bash_ls() {
  echo "[Bash language server]"
  sudo apt install -y nodejs npm
  sudo npm install -g bash-language-server
}

function c_ls() {
  echo "[C/C++ language server]"
  sudo apt install -y ccls
}

function go_ls() {
  echo "[Go language server]"
  sudo add-apt-repository -y ppa:longsleep/golang-backports
  sudo apt update
  sudo apt install -y golang-go
  GO111MODULE=on go get golang.org/x/tools/gopls@latest
}

function json_ls() {
  echo "[JSON language server]"
  sudo apt install -y nodejs npm
  sudo npm install -g vscode-json-languageserver
}

function python_ls() {
  echo "[Python language server]"
  pip3 install --user ipython jedi matplotlib numpy pynvim scipy
  pip3 install --user python-lsp-server[mccabe,pyflakes,pycodestyle,yapf]
}

function clean() {
  echo "[Clean]"
  sudo apt autoremove -y
}

function main() {
  update && echo
  bash_ls && echo
  c_ls && echo
  go_ls && echo
  json_ls && echo
  python_ls && echo
  clean
}

main
