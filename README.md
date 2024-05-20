# dotfiles

This repository contains my config files for:
- **alacritty**
- **git**
- **neovim**
- **tmux**
- **vim**
- **xfce keyboard**
- **zsh**


## Installation
1. For Ubuntu 22.04+, you can use the [Makefile](./Makefile) to install apps:
```bash
sudo make install-base   # install base packages
sudo make install-cli    # install base + CLI packages
sudo make install-gui    # install base + GUI packages
sudo make install-lsp    # install base + LSP servers
sudo make install-latex  # install base + LaTeX
sudo make clean          # clean up packages
```
2. Run [stow](https://www.gnu.org/software/stow/) to install config files:
```bash
stow git nvim tmux vim zsh  # CLI configs
stow alacritty xfce         # GUI configs
```


## After Installation
- Change the default shell: `chsh -s /usr/bin/zsh`
- Create git configs `~/.config/git/personal` and `~/.config/git/work`
- Install [fzf](https://github.com/junegunn/fzf)
- Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
- Generate SSH keys if needed: `ssh-keygen -t ed25519 -C "email@example.com"`
- Run keychain if needed: `eval $(keychain --quiet --eval id_ed25519)`
- Configure XFCE if used


## Docker
A [Dockerfile](./Dockerfile) is provided that sets up an Ubuntu 22.04
environment with all dotfiles installed.

To build the image:
```bash
docker build -t dotfiles:latest .
```

To run it:
```bash
docker run -it dotfiles
```
