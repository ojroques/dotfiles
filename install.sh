#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
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
    "kitty"
    "vim-gtk3"
    "ripgrep"
    "vlc"
    "rofi"
    "zathura"
    "viewnior"
    "redshift-gtk"
    "fonts-hack"
    "arc-theme"
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

echo "INSTALLATION SCRIPT"

echo -e "\nMinimal installation includes:"
for pkg in ${MINIMAL[@]}; do
    echo "* $pkg"
done
echo "* vim-plug"
echo "Complete installation consists of minimal packages plus:"
for pkg in ${FULL[@]}; do
    echo "* $pkg"
done
for pkg in ${PPA[@]}; do
    echo "* $pkg"
done
echo "* diff-so-fancy"
echo -e "WARNING: Complete installation also purges some default applications present on Xubuntu.\n"
echo "Which one to choose?"

select installation in "Minimal installation" "Complete installation" "Abort"; do
    case "$installation" in
        "Minimal installation")
            echo -e "Minimal installation selected.\n"
            choice=1
            break
            ;;
        "Complete installation")
            echo -e "Complete installation selected.\n"
            choice=2
            break
            ;;
        "Abort")
            echo -e "\nAborting installation."
            choice=0
            break
            ;;
    esac
done

if [ $choice = 0 ]; then
    exit 0
fi

SUDO_HOME="/home/$SUDO_USER"  # User home

echo "Updating system..."
apt update -y
apt upgrade -y

# Minimal packages
apt install -y git
apt install -y vim
apt install -y tmux
apt install -y tree
apt install -y openssh-server
apt install -y make
apt install -y curl
sudo -u $SUDO_USER curl -fLo $SUDO_HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Additional packages
if [ $choice = 2 ]; then
    apt install -y kitty
    apt install -y vim-gtk3
    add-apt-repository -y -u ppa:neovim-ppa/stable
    apt install -y neovim
    apt install -y ripgrep
    apt install -y vlc
    apt install -y rofi
    apt install -y zathura
    apt install -y viewnior
    apt install -y redshift-gtk
    sudo -u $SUDO_USER curl -fLo $SUDO_HOME/.local/bin/diff-so-fancy --create-dirs https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
    chmod 775 $SUDO_HOME/.local/bin/diff-so-fancy
    apt install -y fonts-hack
    apt install -y arc-theme
    apt install -y software-properties-common
    add-apt-repository -y -u ppa:snwh/ppa
    apt install -y paper-icon-theme

    apt purge -y ristretto
    apt purge -y simple-scan
    apt purge -y thunderbird thunderbird-locale-en thunderbird-locale-en-gb thunderbird-locale-en-us
    apt purge -y pidgin pidgin-data pidgin-libnotify pidgin-otr
    apt purge -y parole
    apt purge -y xfburn
    apt purge -y atril atril-common
    apt purge -y mate-calc mate-calc-common mate-desktop-common
    apt purge -y dictionaries-common
    apt purge -y orage
    apt purge -y gigolo
fi

echo -e "\nCleaning system..."
apt-get clean -y
apt-get auto-clean -y
apt autoremove -y

echo "Installation done."
