#!/bin/bash

# Install language servers

NVIM_DIR="$HOME/.config/nvim"
if [[ ! -d "$NVIM_DIR" ]]; then
    echo "$NVIM_DIR does not exist"
    exit 1
fi

echo "[Update]"
sudo apt update -y
cd $NVIM_DIR

echo -e "\n[Python language server]"
sudo apt install -y python3-pip
pip3 install jedi
pip3 install python-language-server

echo -e "\n[C/C++ language server]"
if [[ ! -d "./ccls" ]]; then
    sudo apt install -y cmake make gcc
    sudo apt install -y clang-8 libclang-8-dev
    git clone --depth=1 --recursive https://github.com/MaskRay/ccls
    cd ccls
    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=/usr/lib/llvm-8 \
        -DLLVM_INCLUDE_DIR=/usr/lib/llvm-8/include \
        -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-8
    cmake --build Release
    sudo cmake --build Release --target install
    cd $NVIM_DIR
else
    echo "ccls is already installed"
fi

echo -e "\n[Go language server]"
sudo apt install -y golang golang-golang-x-tools
