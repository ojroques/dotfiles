#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

MINIMAL=(
    "curl"
    "git"
    "htop"
    "make"
    "neovim"
    "tmux"
    "tree"
    "vim"
)
FULL=(
    "arc-theme"
    "firefox"
    "fonts-hack"
    "papirus-icon-theme"
    "redshift-gtk"
    "rofi"
    "software-properties-common"
    "viewnior"
    "vim-gtk3"
    "vlc"
    "zathura"
)
OTHERS=(
    "bat"      # 19.10
    "fd-find"  # 19.04
    "fzf"      # 19.04
    "kitty"    # 19.04
    "ripgrep"  # 19.04
)
PURGE=(
    "atril"
    "atril-common"
    "dictionaries-common"
    "gigolo"
    "mate-calc"
    "mate-calc-common"
    "orage"
    "parole"
    "pidgin"
    "pidgin-data"
    "pidgin-libnotify"
    "pidgin-otr"
    "ristretto"
    "simple-scan"
    "thunderbird"
    "thunderbird-locale-*"
    "xfburn"
)
SUDO_HOME="/home/$SUDO_USER"

echo "INSTALLATION SCRIPT"
echo "------------------------------------------------------------"

echo "Minimal installation includes:"
for pkg in "${MINIMAL[@]}"; do
    echo "* $pkg"
done
echo "* vim-plug"

echo "Full installation includes minimal packages plus:"
for pkg in "${FULL[@]}"; do
    echo "* $pkg"
done
for pkg in "${OTHERS[@]}"; do
    echo "* $pkg"
done
echo "* diff-so-fancy"

echo -e "[WARNING] Full installation also purges:"
for pkg in "${PURGE[@]}"; do
    echo "* $pkg"
done

echo "Which one to choose?"
select installation in "Minimal installation" "Full installation" "Abort"; do
    case "$installation" in
        "Minimal installation")
            echo "Minimal installation selected."
            choice=1
            break
            ;;
        "Full installation")
            echo "Full installation selected."
            choice=2
            break
            ;;
        "Abort")
            echo "Installation aborted."
            choice=0
            break
            ;;
    esac
done

if [ $choice = 0 ]; then
    exit 0
fi

echo -e "\\n[UPDATING SYSTEM]"
apt update
apt upgrade -y

echo -e "\\n[MINIMAL PACKAGES]"
apt install -y "${MINIMAL[@]}"
sudo -u "$SUDO_USER" curl -fLo "$SUDO_HOME"/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ $choice = 2 ]; then
    echo -e "\\n[ADDITIONAL PACKAGES]"
    apt install -y "${FULL[@]}"
    apt install -y "${OTHERS[@]}"
    sudo -u "$SUDO_USER" curl -fLo "$SUDO_HOME"/.local/bin/diff-so-fancy --create-dirs https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
    chmod 775 "$SUDO_HOME"/.local/bin/diff-so-fancy

    echo -e "\\n[PURGING DEFAULT PACKAGES]"
    apt purge -y "${PURGE[@]}"
fi

echo -e "\\n[CLEANING SYSTEM]"
apt -y autoremove --purge

echo "------------------------------------------------------------"
echo "Installation done."
