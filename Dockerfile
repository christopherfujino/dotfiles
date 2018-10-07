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

USER root
RUN chown -R chris:chris /home/chris/dotfiles

USER chris
RUN curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN ln -sf /home/chris/dotfiles/.vimrc /home/chris/.vimrc

RUN mkdir -p /home/chris/.config/nvim

RUN ln -sf /home/chris/dotfiles/nvim.init.vim /home/chris/.config/nvim/init.vim

RUN mkdir -p /home/chris/.local/share/nvim/site/autoload

RUN ln -sf /home/chris/.vim/autoload/plug.vim /home/chris/.local/share/nvim/site/autoload/plug.vim

USER root

CMD ["/bin/bash"]
