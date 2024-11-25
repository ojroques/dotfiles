# dotfiles

This repository contains my config files for:
- **alacritty**
- **git**
- **neovim**
- **ripgrep**
- **tmux**
- **vim**
- **xfce keyboard**
- **zsh**

## Installation
1. For Ubuntu 24.04+, you can use the [Makefile](./Makefile) to install apps:
```bash
sudo make install-base  # install base packages
sudo make install-cli   # install base + CLI packages
sudo make install-gui   # install base + GUI packages
sudo make install-lsp   # install base + LSP servers
sudo make clean         # clean up packages
```
2. Run [stow](https://www.gnu.org/software/stow/) to install config files:
```bash
stow git nvim ripgrep tmux vim zsh  # CLI configs
stow alacritty xfce                 # GUI configs
```

## After Installation
- Change the default shell: `chsh -s /usr/bin/zsh` and reboot
- Create git configs `~/.config/git/personal` and `~/.config/git/work`
- Install [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)
- Generate SSH keys if needed: `ssh-keygen -t ed25519 -C "email@example.com"`
- Run keychain if needed: `eval $(keychain --quiet --eval id_ed25519)`
- Configure XFCE if used
