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
  clang_version=7

  if [[ $(apt-cache search --names-only "^ccls$") ]]; then
    sudo apt install -y ccls
  elif [[ ! -x $(command -v ccls) ]]; then
    sudo apt install -y cmake make gcc zlib1g-dev libncurses-dev
    sudo apt install -y clang-"$clang_version" libclang-"$clang_version"-dev
    pushd /tmp
      rm -rf ccls
      git clone --depth=1 --recursive https://github.com/MaskRay/ccls
      cd ccls
      cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=/usr/lib/llvm-"$clang_version" \
        -DLLVM_INCLUDE_DIR=/usr/lib/llvm-"$clang_version"/include \
        -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-"$clang_version"
      cmake --build Release
      sudo cmake --build Release --target install
    popd
  fi
}

function go_ls() {
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
  pip3 install --user fzf-dirhistory ipython jedi matplotlib numpy pynvim scipy
  pip3 install --user python-language-server[mccabe,pyflakes,pycodestyle,yapf]
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
