# dotfiles

This repository contains my config files for:
- **aider**
- **alacritty**
- **git**
- **mpv**
- **neovim**
- **ripgrep**
- **tmux**
- **vim**
- **xfce keyboard**
- **zsh**

## Install
1. In Ubuntu 24.04+, use the [Makefile](./Makefile) to install packages:
```bash
sudo make install-base  # install base packages
sudo make install-cli   # install base + CLI packages
sudo make install-gui   # install base + GUI packages
sudo make clean         # clean up packages
```
2. Install additional apps:
```bash
make install-ls                               # language servers
make aider fzf jetbrains-mono tree-sitter uv  # user apps
```
3. Run [stow](https://www.gnu.org/software/stow/) to symlink config files:
```bash
stow aider git nvim ripgrep tmux vim zsh  # CLI configs
stow alacritty mpv xfce                   # GUI configs
```

## Post-install
- Change the default shell: `chsh -s /usr/bin/zsh` and reboot
- Create git configs `~/.config/git/personal` and `~/.config/git/work`
- Generate SSH keys if needed: `ssh-keygen -t ed25519 -C "email@example.com"`
- Run keychain if needed: `eval $(keychain --quiet --eval id_ed25519)`
- Configure XFCE if used
- Export environment variables in `~/.config/zsh/.env`
- Add additional commands to run in `~/.config/zsh/.run`
