FROM ubuntu:24.04

ARG DEBIAN_FRONTEND="noninteractive"

WORKDIR /root

RUN true \
  && apt-get update \
  && apt-get -y install git make

RUN true \
  && mkdir -p Documents Downloads Work .tmp \
  && cd Documents \
  && git clone https://github.com/ojroques/dotfiles.git \
  && cd dotfiles \
  && make install-cli \
  && make clean \
  && stow git nvim ripgrep tmux vim zsh
