FROM ubuntu:18.04

RUN useradd -m -G wheel chris

RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  git && \
  neovim && \
  tmux && \
  python-pip && \
  python3-pip

CMD ["/bin/bash"]
