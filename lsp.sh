#!/bin/bash

set -e

function update() {
  echo "[Update]"
  sudo apt-get update
  sudo apt-get upgrade -y
}

function bash_ls() {
  echo "[Bash language server]"
  sudo apt-get install -y nodejs npm
  sudo npm install -g bash-language-server
}

function c_ls() {
  echo "[C/C++ language server]"
  sudo apt-get install -y ccls
}

function go_ls() {
  echo "[Go language server]"
  sudo add-apt-repository -y ppa:longsleep/golang-backports
  sudo apt-get update
  sudo apt-get install -y golang-go
  go install golang.org/x/tools/gopls@latest
}

function json_ls() {
  echo "[JSON language server]"
  sudo apt-get install -y nodejs npm
  sudo npm install -g vscode-langservers-extracted
}

function python_ls() {
  echo "[Python language server]"
  pip3 install --user jedi matplotlib neovim-remote numpy pynvim scipy
  pip3 install --user python-lsp-server[pyflakes,pycodestyle,yapf]
}

function clean() {
  echo "[Clean]"
  sudo apt-get autoremove -y
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
