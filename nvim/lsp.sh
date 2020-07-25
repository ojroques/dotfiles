#!/bin/bash

set -e
NVIM_DIR="$HOME/.config/nvim"

if [[ ! -d "$NVIM_DIR" ]]; then
    echo "$NVIM_DIR does not exist"
    exit 1
fi

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
    local clang_version=7

    echo "[C/C++ language server]"

    if [[ $(apt-cache search --names-only "^ccls$") ]]; then
        sudo apt install -y ccls
    else
        cd "$NVIM_DIR"

        if [[ ! -d "./ccls" ]]; then
            sudo apt install -y cmake make gcc zlib1g-dev libncurses-dev
            sudo apt install -y clang-"$clang_version" libclang-"$clang_version"-dev
            git clone --depth=1 --recursive https://github.com/MaskRay/ccls
            cd ccls
            cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
                -DCMAKE_PREFIX_PATH=/usr/lib/llvm-"$clang_version" \
                -DLLVM_INCLUDE_DIR=/usr/lib/llvm-"$clang_version"/include \
                -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-"$clang_version"
            cmake --build Release
            sudo cmake --build Release --target install
            cd "$NVIM_DIR"
        fi
    fi
}

function json_ls() {
    echo "[JSON language server]"
    sudo apt install -y nodejs npm
    sudo npm install -g vscode-json-languageserver
}

function go_ls() {
    echo "[Go language server]"
    sudo apt install -y golang golang-golang-x-tools
}

function python_ls() {
    echo "[Python language server]"
    pip3 install --user jedi
    pip3 install --user python-language-server[pyflakes,yapf]
    pip3 install --user numpy scipy matplotlib ipython
}

function clean() {
    echo "[Clean]"
    sudo apt autoremove -y --purge
}

function main() {
    update && echo
    bash_ls && echo
    c_ls && echo
    json_ls && echo
    go_ls && echo
    python_ls && echo
    clean
}

main
