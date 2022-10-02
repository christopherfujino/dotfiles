# Christopher Fujino's Dotfiles

[![Build Status](https://api.cirrus-ci.com/github/christopherfujino/dotfiles.svg)](https://cirrus-ci.com/github/christopherfujino/dotfiles)

## Setup

### MacOS

* Install [Homebrew](http://brew.sh)
  * first install cask: `$ brew tap caskroom/cask`
    * google-chrome
    * steam
  * cmake
  * node
  * tmux
  * links
  * htop
  * ncdu
  * midnight-commander
  * youtube-dl
* From source build:
  * Alacritty
  * neovim
* SSH Keys
  * generate ssh keys: `$ ssh-keygen`
  * upload to [Github](https://github.com)
* Setup dotfiles
  * git clone my dotfiles: `$ git clone git@github.com:christopherfujino/dotfiles.git`
* Symlink user directories
* Spotify

### Linux

If you want to use a newer version of a package than what is the default on
Ubuntu/Debian, use `update-alternatives`. For example, on Ubuntu 20.04 LTS,
`clangd` resolves to version 10.0, whereas to configure the location of
your compilation database in a `.clangd` config file requires at least version
12.

```shell
sudo apt-get remove clangd
sudo apt-get install clangd-12
# Here 100 is a priority
sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
```

## Golang Setup

* Install go language
* Install [golint](https://github.com/golang/lint)
