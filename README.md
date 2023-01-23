# dotfiles

This repository contains my config files for:
- **git**
- **neovim**
- **tmux**
- **vim**
- **windows terminal**
- **zsh**


## Installation
1. Use the [Makefile](./Makefile) to install apps (must be root):
```bash
sudo make install-base   # install base packages
sudo make install-cli    # install base + CLI packages
sudo make install-lsp    # install base + LSP servers
sudo make install-latex  # install base + LaTeX
sudo make clean          # clean up packages
```
2. Run [stow](https://www.gnu.org/software/stow/) to install config files:
```bash
stow git nvim tmux vim zsh
```


## After Installation
- Change the default shell: `chsh -s /usr/bin/zsh`
- Create git configs `~/.config/git/personal` and `~/.config/git/work` with your
  names and emails
- Run `nvim`, wait for [paq](https://github.com/savq/paq-nvim) to install itself
  then execute `:PaqInstall` to install plugins
- Generate SSH keys if needed: `ssh-keygen -t ed25519 -C "email@example.com"`


## Docker
A [Dockerfile](./Dockerfile) is provided that sets up an Ubuntu 22.04
environment with all dotfiles installed.

Build it with:
```bash
docker build -t dotfiles:latest .
```

And run it like so:
```bash
docker run -it dotfiles
```
