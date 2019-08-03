#!/bin/bash

CONFIG_DIR="$HOME/.config"

echo "DOTFILES INSTALLATION"

if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "Creating $CONFIG_DIR..."
    mkdir "$CONFIG_DIR"
fi

echo "Copying bash configs..."
cp -v bash/.profile $HOME
cp -v bash/.bashrc $HOME
cp -v bash/.aliases $HOME
cp -v bash/.functions $HOME

echo "Copying git config..."
cp -v git/.gitconfig $HOME

echo "Copying tmux config..."
cp -v tmux/.tmux.conf $HOME

echo "Copying kitty config..."
cp -v -r kitty/ $CONFIG_DIR

echo "Copying rofi config..."
cp -v -r rofi/ $CONFIG_DIR

echo "Copying vim config..."
cp -v vim/.vimrc $HOME

echo "Copying neovim config..."
cp -v -r nvim/ $CONFIG_DIR
rm -f $CONFIG_DIR/nvim/lsp.sh

if [[ -d "$CONFIG_DIR/xfce4/xfconf/xfce-perchannel-xml" ]]; then
    echo "Copying thunar config..."
    cp -v thunar/thunar.xml $CONFIG_DIR/xfce4/xfconf/xfce-perchannel-xml/
    echo "Copying xfce keyboard configs..."
    cp -v xfce/keyboards.xml $CONFIG_DIR/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/keyboard-layout.xml $CONFIG_DIR/xfce4/xfconf/xfce-perchannel-xml/
    cp -v xfce/xfce4-keyboard-shortcuts.xml $CONFIG_DIR/xfce4/xfconf/xfce-perchannel-xml/
fi

echo "Configuration done."
echo "Run vim then execute ':PlugInstall' to finish vim configuration."
