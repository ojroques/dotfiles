# dotfiles

This repository contains my configuration files for:
- **git**
- **bash**
- **tmux**
- **vim**, **neovim**, **vimium**
- [**kitty**](https://github.com/kovidgoyal/kitty)
- **rofi**
- **latex**
- **thunar**
- **xfce** (keyboard layouts and shortcuts)
- **windows terminal**

I use [Xubuntu](https://xubuntu.org/) but installation should work fine on any recent (18.04+) Ubuntu-based distribution.


## Screenshots
Wallpaper can be found [here](./screenshots/wallpaper.png)
![Kitty and Thunar](./screenshots/shell.png)
![Vim](./screenshots/vim.png)


## Installation
1. Run `install.sh` as root to install applications:
```sh
sudo ./install.sh
```
2. Run `config.sh` to copy configuration files to the right places:
```sh
./config.sh
```
3. Run `vim` and execute `:PlugInstall` to install the plugins.
4. (Optional) Run `latex.sh` to install LaTeX:
```sh
latex/latex_setup.sh
```
5. (Optional) Run `lsp.sh` to install language servers for `LanguageClient-neovim` (a plugin to use the [Language Server Protocol](https://langserver.org)):
```sh
nvim/lsp.sh
```
6. (Optional) [Configure rclone](https://rclone.org/docs/):
```sh
rclone config
```


## After Installation
- Rearrange home directories
- Configure panel and workspaces
- Change theme and icons
- Install and configure additional applications: [bat](https://github.com/sharkdp/bat), [fd](https://github.com/sharkdp/fd), [fzf](https://github.com/junegunn/fzf), [kitty](https://github.com/kovidgoyal/kitty), [ripgrep](https://github.com/BurntSushi/ripgrep), [spotify](https://www.spotify.com/uk/download/linux/)
- Change default applications
- Generate SSH keys: `ssh-keygen -t ed25519 -a 100 -C "email@example.com"`
- Set wallpapers
