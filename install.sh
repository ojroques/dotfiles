#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

BIN_DIR="/usr/local/bin"
CLI=(  # 18.04
    "curl"
    "git"
    "htop"
    "make"
    "neovim"
    "python3-pip"
    "shellcheck"
    "software-properties-common"
    "tmux"
    "tree"
    "unzip"
    "vim"
)
CLI_RECENT=(
    "bat"      # 19.10
    "fd-find"  # 19.04
    "ripgrep"  # 19.04
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
    local full_installation=$1
    local sudo_home="/home/$SUDO_USER"

    echo "[INSTALL PACKAGES]"

    apt install -y "${CLI[@]}"
    apt install -y "${CLI_RECENT[@]}"
    curl -o "$sudo_home"/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    if [[ $full_installation = true ]]; then
        apt install -y "${GUI[@]}"
        apt install -y "${GUI_RECENT[@]}"
        curl -o "$BIN_DIR"/diff-so-fancy --create-dirs https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
        chmod 775 "$BIN_DIR"/diff-so-fancy
    fi
}

function purge() {
    local full_installation=$1

    if [[ $full_installation = true ]]; then
        echo "[PURGE PACKAGES]"

        for pkg in "${PURGE[@]}"; do
            apt purge -y "$pkg"
        done
    fi
}

function clean() {
    echo "[CLEAN SYSTEM]"
    apt autoremove -y --purge
}

function main() {
    echo "INSTALLATION SCRIPT"
    echo "------------------------------------------------------------"

    echo "Minimal installation includes:"
    for pkg in "${CLI[@]}" "${CLI_RECENT[@]}"; do
        echo "* $pkg"
    done
    echo "* vim-plug"

    echo "Full installation includes minimal packages and:"
    for pkg in "${GUI[@]}" "${GUI_RECENT[@]}"; do
        echo "* $pkg"
    done
    echo "* diff-so-fancy"

    echo "[WARNING] Full installation also purges:"
    for pkg in "${PURGE[@]}"; do
        echo "* $pkg"
    done

    echo "Select one:"
    select installation in "Minimal installation" "Full installation" "Abort"; do
        case "$installation" in
            "Minimal installation")
                echo "Minimal installation selected."
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
