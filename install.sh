#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

SUSER=${SUDO_USER:-root}
SHOME=$(getent passwd "$SUSER" | cut -d: -f6)

CLI=(
  "build-essential"
  "curl"
  "fd-find"
  "git"
  "htop"
  "manpages-posix"
  "python3-pip"
  "shellcheck"
  "software-properties-common"
  "stow"
  "tree"
  "unzip"
  "vim"
)
GUI=(
  "arc-theme"
  "firefox"
  "fonts-hack"
  "papirus-icon-theme"
  "redshift-gtk"
  "rofi"
  "viewnior"
  "vim-gtk3"
  "vlc"
  "zathura"
)
PURGE=(
  "atril atril-common"
  "dictionaries-common"
  "gigolo"
  "mate-calc mate-calc-common"
  "orage"
  "parole"
  "pidgin pidgin-data pidgin-libnotify pidgin-otr"
  "ristretto"
  "simple-scan"
  "thunderbird thunderbird-locale-*"
  "xfburn"
)

function update() {
  echo "[UPDATE SYSTEM]"
  apt-get update
  apt-get upgrade -y
}

function install() {
  echo "[INSTALL PACKAGES]"

  apt-get install -y "${CLI[@]}"

  # bat
  bat_version="0.18.3"
  bat="bat_${bat_version}_amd64.deb"
  curl -fsSL \
    https://github.com/sharkdp/bat/releases/download/v"$bat_version"/"$bat" \
    -o "$bat"
  dpkg -i "$bat" && rm -f "$bat"

  # delta
  delta_version="0.8.3"
  delta="git-delta_${delta_version}_amd64.deb"
  curl -fsSL \
    https://github.com/dandavison/delta/releases/download/"$delta_version"/"$delta" \
    -o "$delta"
  dpkg -i "$delta" && rm -f "$delta"

  # gdb-dashboard
  sudo -u "$SUSER" curl -fsSL \
    https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
    -o "$SHOME"/.gdbinit

  # neovim
  add-apt-repository -y ppa:neovim-ppa/unstable
  apt-get update
  apt-get install -y neovim

  # ripgrep
  ripgrep_version="13.0.0"
  ripgrep="ripgrep_${ripgrep_version}_amd64.deb"
  curl -fsSL \
    https://github.com/BurntSushi/ripgrep/releases/download/"$ripgrep_version"/"$ripgrep" \
    -o "$ripgrep"
  dpkg -i "$ripgrep" && rm -f "$ripgrep"

  if [[ $1 == true ]]; then
    apt-get install -y "${GUI[@]}"
    curl -fsSL https://sw.kovidgoyal.net/kitty/installer.sh | sh
  fi
}

function purge() {
  if [[ $1 == true ]]; then
    echo "[PURGE PACKAGES]"

    for pkg in "${PURGE[@]}"; do
      apt-get purge -y "$pkg"
    done
  fi
}

function clean() {
  echo "[CLEAN SYSTEM]"
  apt-get autoremove -y
}

function main() {
  echo "INSTALLATION SCRIPT"
  echo "------------------------------------------------------------"

  echo "CLI installation includes:"
  for pkg in "${CLI[@]}"; do
    echo "* $pkg"
  done
  echo "* bat"
  echo "* delta"
  echo "* gdb-dashboard"
  echo "* neovim"
  echo "* ripgrep"

  echo "GUI installation includes CLI packages and:"
  for pkg in "${GUI[@]}"; do
    echo "* $pkg"
  done
  echo "* kitty"

  echo "[WARNING] GUI installation also purges:"
  for pkg in "${PURGE[@]}"; do
    echo "* $pkg"
  done

  echo "Select one:"
  select installation in "CLI installation" "GUI installation" "Abort"; do
    case "$installation" in
      "CLI installation")
        echo "CLI installation selected."
        gui_installation=false
        break
        ;;
      "GUI installation")
        echo "GUI installation selected."
        gui_installation=true
        break
        ;;
      "Abort")
        echo "Installation aborted."
        exit 0
        break
        ;;
    esac
  done

  echo && update
  echo && install $gui_installation
  echo && purge $gui_installation
  echo && clean

  echo "------------------------------------------------------------"
  echo "Installation done."
}

main
