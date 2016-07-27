# To-do: add bash code to read from a config.json

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export VISUAL="vim"
export EDITOR="vim"

alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'
alias upd='timedatectl | grep Local; yaourt -Syua'
alias emacs='emacs -nw'
alias ..='cd ..'
alias g='git'

# To-do: this is Linux-specific code
export STEAM_RUNTIME=0
export TERM="rxvt-unicode-256color"
export LIBVA_DRIVER_NAME="i965" # for arch hardware rendering
#export TERM="xterm-256color"
export TERMINAL="urxvt"

PS1='\u@\h \W\$ '

# calculator function
function calc {
  echo "${1}" | bc -l;
}

export PATH="${PATH}:$HOME/scripts:$HOME/.node_modules/bin:$HOME/.gem/ruby/2.3.0/bin"

#Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/scripts/base16-monokai.sh"
[[ -s $BASE16_SHELL  ]] && source $BASE16_SHELL

