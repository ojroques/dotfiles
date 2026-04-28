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
1. On Ubuntu 24.04+, use the [Makefile](./Makefile) to install apps:
```sh
sudo make system-cli-apps  # install system CLI apps
sudo make system-gui-apps  # install system GUI apps
```
2. Run [stow](https://www.gnu.org/software/stow/) to symlink config files:
```sh
stow git nvim ripgrep systemd tmux vim zsh  # CLI configs
stow alacritty mpv xfce                     # GUI configs
```
3. Change the default shell: `chsh -s /usr/bin/zsh` and reboot.
4. Install additional apps:
```sh
make user-cli-apps     # install user CLI apps
make user-gui-apps     # install user GUI apps
make language-servers  # install language servers
```

## Post-install
- Create git configs `~/.config/git/personal` and `~/.config/git/work`
- Install or generate SSH keys
- Enable user systemd units: `systemctl --user enable <unit>`
- Export environment variables in `~/.config/zsh/.env`
- Run additional commands in `~/.config/zsh/.run`
