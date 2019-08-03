#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

echo "INSTALLATION SCRIPT"

echo "Updating system..."
apt update -y
apt upgrade -y

echo -e "\nMinimal installation includes:"
echo "* git"
echo "* vim"
echo "* tmux"
echo "* tree"
echo "* openssh-server"
echo "* make"
echo "* curl"
echo "* vim-plug"
echo "Complete installation consists of minimal packages plus:"
echo "* kitty"
echo "* neovim"
echo "* ripgrep"
echo "* rofi"
echo "* vlc"
echo "* zathura"
echo "* viewnior"
echo "* redshift"
echo "* diff-so-fancy"
echo "* fonts-hack"
echo "* arc-theme"
echo "* paper-icons-theme"
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
    apt install -y vim-gtk3 neovim
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
