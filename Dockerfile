FROM ubuntu:18.04

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y \
  cmake \
  git \
  curl \
  software-properties-common \
  tmux \
  python-dev \
  python-pip \
  python3-pip \
  python3-dev \
  sudo \
  nodejs \
  npm \
  vim \
  silversearcher-ag \
  && apt-add-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install -y neovim

RUN useradd -ms /bin/bash chris

USER chris
WORKDIR /home/chris

RUN mkdir dotfiles

COPY . /home/chris/dotfiles

RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN mkdir -p /home/chris/.config/nvim

RUN ln -sf /home/chris/dotfiles/.vimrc /home/chris/.vimrc

USER root

CMD ["/bin/bash"]
