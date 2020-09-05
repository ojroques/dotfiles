# dotfiles

This repository contains my config files for:
- **bash**
- **git**
- [**kitty**](https://github.com/kovidgoyal/kitty)
- **latex**
- **rofi**
- **tmux**
- **vim**, **neovim**, **vimium**
- **windows terminal**
- **thunar** and **xfce**

I use [Xubuntu](https://xubuntu.org/) but installation should work fine on any recent Ubuntu (18.04+) flavor.


## Screenshots
Wallpaper can be found [here](./screenshots/wallpaper.png)
![Kitty and Thunar](./screenshots/shell.png)
![Vim](./screenshots/vim.png)


## Installation
1. Run `install.sh` as root to install the packages:
```sh
sudo ./install.sh
```
2. Run `config.sh` to copy config files to the right places:
```sh
./config.sh
```
3. (Optional) Run `latex.sh` to install LaTeX:
```sh
latex/latex_setup.sh
```
4. (Optional) Run `lsp.sh` to install language servers for `LanguageClient-neovim` (a plugin to use the [Language Server Protocol](https://langserver.org)):
```sh
nvim/lsp.sh
```


## After Installation
- Add email to [git config](git/.gitconfig)
- Run `vim` and execute `:PlugInstall` to install the plugins
- Install fzf: `~/.fzf/install`
- Generate SSH keys: `ssh-keygen -t ed25519 -a 100 -C "email@example.com"`
