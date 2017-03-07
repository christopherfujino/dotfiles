#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OS=$(uname)

export VISUAL="nvim"
export EDITOR="nvim"

alias ls='ls --color=auto'
alias ll='ls -Alh --color=auto'
alias lsa='ls -A' # -A means ignore '.' & '..'
alias emacs='emacs -nw' # default to console-based emacs
alias ..='cd ..'
alias g='git'

#if [ $OS = "Linux" ]; then
## This is Linux-specific code
#fi

if [ $HOSTNAME = "ac" ]; then
  # This is specific for my chromebook
  export PATH="${PATH}:$HOME/scripts:$HOME/.node_modules/bin:$HOME/.gem/ruby/2.3.0/bin"
  alias upd='timedatectl | grep Local; yaourt -Syua'
  alias yaourt-stats='yaourt --stats'
  alias dfh='df -h /dev/sda1'
  export STEAM_RUNTIME=0 # for Steam
  #export TERM="xterm-256color"
  export TERM="rxvt-unicode-256color"
  export LIBVA_DRIVER_NAME="i965" # for arch hardware rendering
  export TERMINAL="urxvt"

  #Base16 Shell
  BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-monokai.sh"
  [[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL
fi

if [ $OS = "Darwin" ]; then
  alias dfh='df -h /dev/disk0s2'
fi

PS1='\u@\h \W\$ '

