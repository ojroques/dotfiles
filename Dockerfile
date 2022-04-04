FROM ubuntu:22.04

ARG DEBIAN_FRONTEND="noninteractive"

WORKDIR /root

RUN true \
  && apt-get update \
  && apt-get -y install git make

RUN true \
  && mkdir Documents Downloads .tmp \
  && rm -f ~/.bashrc

RUN true \
  && cd Documents \
  && git clone https://github.com/ojroques/dotfiles.git \
  && cd dotfiles \
  && make install-cli \
  && make clean \
  && stow bash git nvim vim
