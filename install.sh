#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

CLI=(  # 18.04
  "build-essential"
  "curl"
  "git"
  "htop"
  "manpages-posix"
  "python3-pip"
  "shellcheck"
  "software-properties-common"
  "tree"
  "unzip"
  "vim"
)
GUI=(  # 18.04
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
GUI_RECENT=(
  "kitty"  # 19.04
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
  apt update
  apt upgrade -y
}

function install() {
  echo "[INSTALL PACKAGES]"

  apt install -y "${CLI[@]}"
  apt install -y "${CLI_RECENT[@]}"

  if [[ $1 == true ]]; then
    apt install -y "${GUI[@]}"
    apt install -y "${GUI_RECENT[@]}"
  fi

  # delta
  delta_version="0.8.3"
  delta="git-delta_"$delta_version"_amd64.deb"
  curl -fsSL \
    https://github.com/dandavison/delta/releases/download/"$delta_version"/"$delta" \
    -o "$delta"
  dpkg -i "$delta" && rm -f "$delta"

  # gdb-dashboard
  sudo -u "$SUDO_USER" curl -fsSL \
    https://raw.githubusercontent.com/cyrus-and/gdb-dashboard/master/.gdbinit \
    -o /home/"$SUDO_USER"/.gdbinit

  # neovim
  add-apt-repository -y ppa:neovim-ppa/unstable
  apt-get update
  apt-get install -y neovim

  # paq-nvim
  sudo -u "$SUDO_USER" git clone https://github.com/savq/paq-nvim.git \
    /home/"$SUDO_USER"/.local/share/nvim/site/pack/paqs/opt/paq-nvim
}

function purge() {
  if [[ $1 == true ]]; then
    echo "[PURGE PACKAGES]"

    for pkg in "${PURGE[@]}"; do
      apt purge -y "$pkg"
    done
  fi
}

function clean() {
  echo "[CLEAN SYSTEM]"
  apt autoremove -y
}

function main() {
  echo "INSTALLATION SCRIPT"
  echo "------------------------------------------------------------"

  echo "CLI installation includes:"
  for pkg in "${CLI[@]}" "${CLI_RECENT[@]}"; do
    echo "* $pkg"
  done
  echo "* delta"
  echo "* gdb-dashboard"
  echo "* neovim"
  echo "* paq-nvim"

  echo "Full installation includes CLI packages and:"
  for pkg in "${GUI[@]}" "${GUI_RECENT[@]}"; do
    echo "* $pkg"
  done

  echo "[WARNING] Full installation also purges:"
  for pkg in "${PURGE[@]}"; do
    echo "* $pkg"
  done

  echo "Select one:"
  select installation in "CLI installation" "Full installation" "Abort"; do
    case "$installation" in
      "CLI installation")
        echo "CLI installation selected."
        full_installation=false
        break
        ;;
      "Full installation")
        echo "Full installation selected."
        full_installation=true
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
  echo && install $full_installation
  echo && purge $full_installation
  echo && clean

  echo "------------------------------------------------------------"
  echo "Installation done."
}

main
