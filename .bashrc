#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OS=$(uname)

export VISUAL="nvim"
export EDITOR="nvim"

alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'
alias lsa='ls -a'
alias emacs='emacs -nw' # default to console-based emacs
alias ..='cd ..'
alias g='git'

# This is Linux-specific code
if [ $OS = "Linux" ]; then
  alias upd='timedatectl | grep Local; yaourt -Syua'
  export STEAM_RUNTIME=0 # for Steam
  #export TERM="xterm-256color"
  export TERM="rxvt-unicode-256color"
  export LIBVA_DRIVER_NAME="i965" # for arch hardware rendering
  export TERMINAL="urxvt"
fi

PS1='\u@\h \W\$ '

export PATH="${PATH}:$HOME/scripts:$HOME/.node_modules/bin:$HOME/.gem/ruby/2.3.0/bin"

#Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-monokai.sh"
[[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL
