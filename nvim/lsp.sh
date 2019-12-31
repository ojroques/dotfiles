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
pip3 install --user jedi
pip3 install --user python-language-server

echo -e "\n[C/C++ language server]"
if [[ $(apt-cache search --names-only "^ccls$") ]]; then
    sudo apt install -y ccls
else
    if [[ ! -d "./ccls" ]]; then
        CLANG_VERSION=7
        sudo apt install -y cmake make gcc zlib1g-dev libncurses-dev
        sudo apt install -y clang-"$CLANG_VERSION" libclang-"$CLANG_VERSION"-dev
        git clone --depth=1 --recursive https://github.com/MaskRay/ccls
        cd ccls
        cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
            -DCMAKE_PREFIX_PATH=/usr/lib/llvm-"$CLANG_VERSION" \
            -DLLVM_INCLUDE_DIR=/usr/lib/llvm-"$CLANG_VERSION"/include \
            -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-"$CLANG_VERSION"
        cmake --build Release
        sudo cmake --build Release --target install
        cd $NVIM_DIR
    else
        echo "ccls is already installed"
    fi
fi

echo -e "\n[Go language server]"
sudo apt install -y golang golang-golang-x-tools
