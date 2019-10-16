#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

MINIMAL=(
    "git"
    "vim"
    "tmux"
    "tree"
    "openssh-server"
    "make"
    "curl"
)
FULL=(
    "software-properties-common"
    "vim-gtk3"
    "vlc"
    "rofi"
    "zathura"
    "viewnior"
    "redshift-gtk"
    "fonts-hack"
    "arc-theme"
)
# Available from 19.04
OTHERS=(
    "kitty"
    "ripgrep"
    "fd-find"
)
PPA=(
    "neovim"
    "paper-icon-theme"
)
PURGED=(
    "ristretto"
    "simple-scan"
    "thunderbird thunderbird-locale-en thunderbird-locale-en-gb thunderbird-locale-en-us"
    "pidgin pidgin-data pidgin-libnotify pidgin-otr"
    "parole"
    "xfburn"
    "atril atril-common"
    "mate-calc mate-calc-common mate-desktop-common"
    "dictionaries-common"
    "orage"
    "gigolo"
)
SUDO_HOME="/home/$SUDO_USER"

echo "INSTALLATION SCRIPT"
echo "------------------------------------------------------------"
echo "Minimal installation includes:"
for pkg in ${MINIMAL[@]}; do
    echo "* $pkg"
done
echo "* vim-plug"
echo "Full installation includes minimal packages plus:"
for pkg in ${FULL[@]}; do
    echo "* $pkg"
done
for pkg in ${OTHERS[@]}; do
    echo "* $pkg"
done
for pkg in ${PPA[@]}; do
    echo "* $pkg"
done
echo "* diff-so-fancy"
echo -e "[WARNING] Full installation also purges some default applications present on Xubuntu.\n"

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

echo -e "\n[UPDATING SYSTEM]"
apt update
apt upgrade -y

echo -e "\n[MINIMAL PACKAGES]"
apt install -y ${MINIMAL[@]}
sudo -u $SUDO_USER curl -fLo $SUDO_HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if [ $choice = 2 ]; then
    echo -e "\n[ADDITIONAL PACKAGES]"
    apt install -y ${FULL[@]}
    apt install -y ${OTHERS[@]}
    add-apt-repository -y ppa:neovim-ppa/stable
    add-apt-repository -y ppa:snwh/ppa
    apt update
    apt install -y ${PPA[@]}
    sudo -u $SUDO_USER curl -fLo $SUDO_HOME/.local/bin/diff-so-fancy --create-dirs https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
    chmod 775 $SUDO_HOME/.local/bin/diff-so-fancy

    echo -e "\n[PURGING DEFAULT PACKAGES]"
    apt purge -y ${PURGED[@]}
fi

echo -e "\n[CLEANING SYSTEM]"
apt-get clean -y
apt-get auto-clean -y
apt autoremove -y
echo "------------------------------------------------------------"
echo "Installation done."
