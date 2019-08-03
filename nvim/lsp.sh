#!/bin/bash

# Install language servers

NVIM_DIR="$HOME/.config/nvim"
if [[ ! -d "$NVIM_DIR" ]]; then
    echo "$NVIM_DIR does not exist"
    exit 1
fi

sudo apt update -y
cd $NVIM_DIR

echo -e "\nPython language server"
sudo apt install -y python3-pip
pip3 install jedi
pip3 install python-language-server

echo -e "\nC/C++ language server"
if [[ ! -d "./ccls" ]]; then
    sudo apt install -y cmake make gcc
    sudo apt install -y clang-7 libclang-7-dev
    git clone --depth=1 --recursive https://github.com/MaskRay/ccls
    cd ccls
    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=/usr/lib/llvm-7 \
        -DLLVM_INCLUDE_DIR=/usr/lib/llvm-7/include \
        -DLLVM_BUILD_INCLUDE_DIR=/usr/include/llvm-7
    cmake --build Release
    sudo cmake --build Release --target install
    cd $NVIM_DIR
else
    echo "ccls is already installed"
fi

# Useless if vimtex is enabled
# echo -e "\nLaTeX language server"
# if [[ ! -d "./texlab" ]]; then
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash
#     curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
#     sudo apt install -y nodejs
#     PATH="$HOME/.cargo/bin:$PATH"
#     git clone https://github.com/latex-lsp/texlab.git
#     cd texlab
#     cargo run --manifest-path scripts/build/Cargo.toml
#     cargo build --release
#     cd $NVIM_DIR
# else
#     echo "TexLab is already installed"
# fi
