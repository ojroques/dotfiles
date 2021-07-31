FROM ubuntu:20.04

ARG DEBIAN_FRONTEND="noninteractive"

RUN true \
  && apt-get update \
  && apt-get -y install git sudo

WORKDIR /root

RUN true \
  && mkdir Documents Downloads .tmp \
  && rm -f ~/.bashrc

RUN true \
  && cd Documents \
  && git clone https://github.com/ojroques/dotfiles.git \
  && cd dotfiles \
  && git config user.email "olivier@oroques.dev"

RUN true \
  && cd Documents/dotfiles \
  && git pull \
  && echo "1" | ./install.sh \
  && ./lsp.sh

RUN true \
  && cd Documents/dotfiles \
  && git pull \
  && stow bash git nvim vim
