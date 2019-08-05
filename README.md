# dotfiles

This repository contains my configuration files for:
- **git**
- **bash**
- **tmux**
- **vim** and **neovim**
- **kitty** (main terminal emulator) and **terminator**
- **rofi**
- **latex**
- **thunar**
- **xfce** (keyboard layouts and shortcuts)

I use [Xubuntu](https://xubuntu.org/) but instructions should work fine on any recent Ubuntu-based distribution.


## Installation
1. Run `install.sh` as root to install applications:
```sh
sudo ./install.sh
```
2. Run `config.sh` to copy configuration files to the right places:
```sh
./config.sh
```
3. (Optional) Run `latex.sh` to install LaTeX:
```sh
latex/latex_setup.sh
```
4. (Optional) Uncomment `alias vim=nvim` in `bash/.aliases` to use neovim instead of vim. Then run `lsp.sh` to install language servers to be used by `LanguageClient-neovim` (a plugin to support the [Language Server Protocol](https://microsoft.github.io/language-server-protocol/)):
```sh
nvim/lsp.sh
```
5. Add email to `~/.gitconfig`. Run `vim` and execute `:PlugInstall` to install all plugins.


## Configuration
- Rearrange home directories
- Turn off unused services at startup
- Configure panel and workspaces
- Change theme and icons
- Install and configure additional applications: [chrome](https://www.google.com/chrome/), [atom](https://atom.io), [spotify](https://www.spotify.com/uk/download/linux/), [bat](https://github.com/sharkdp/bat), [fd](https://github.com/sharkdp/fd)
- Change default applications
- Generate SSH keys: `ssh-keygen -t rsa`
- Set wallpapers


## Vim on Windows
1. Install **Git for Windows** with the *Run git from Windows command prompt* option enabled
2. To install **Vundle** (plugin manager), launch **Git Bash** and run
```sh
git clone https://github.com/VundleVim/Vundle.vim.git /c/Users/<USERNAME>/vimfiles/bundle/Vundle.vim
```
3. Rename `vimrc` into `_vimrc`
5. Copy `_vimrc` into *C:\Users\<USERNAME>\\_vimrc*
4. Add these lines at the top of `_vimrc`:
```sh
source $VIMRUNTIME/mswin.vim
behave mswin
```
6. In `_vimrc`, replace all instances of `Plug` with `Plugin`. Replace `call plug#end()` by `call vundle#end()` and `call plug#begin()` by
```sh
set rtp+=C:\Users\<USERNAME>\vimfiles\bundle\Vundle.vim
call vundle#begin('C:\Users\<USERNAME>\vimfiles\bundle\')
```
8. Launch **vim** and run `:PluginInstall` to complete the installation
