# dotfiles

This repository contains my config files for:
- **alacritty**
- **git**
- **mpv**
- **neovim**
- **ripgrep**
- **systemd**
- **tmux**
- **vim**
- **xfce**
- **zsh**

## Install
1. On Ubuntu 24.04+, use the [Makefile](./Makefile) to install packages:
```sh
sudo make update        # update packages
sudo make install-base  # install base packages
sudo make install-cli   # install base + CLI packages
sudo make install-gui   # install base + GUI packages
sudo make clean         # clean up packages
```
2. Run [stow](https://www.gnu.org/software/stow/) to symlink config files:
```sh
stow git nvim ripgrep systemd tmux vim zsh  # CLI configs
stow alacritty mpv xfce                     # GUI configs
```
3. Change the default shell: `chsh -s /usr/bin/zsh` and reboot.
4. Install additional apps:
```sh
make difftastic fzf jetbrains-mono tree-sitter uv  # user apps
make install-ls                                    # language servers
```

## Post-install
- Create git configs `~/.config/git/personal` and `~/.config/git/work`
- Install or generate SSH keys
- Enable user systemd units: `systemctl --user enable <unit>`
- Export environment variables in `~/.config/zsh/.env`
- Add additional commands to run in `~/.config/zsh/.run`
