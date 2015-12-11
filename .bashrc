#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export VISUAL="vim"

alias ls='ls --color=auto'
alias ll='ls -alh --color=auto'
alias upd='yaourt -Syua'
PS1='[\u@\h \W]\$ '

# calculator function

function calc {
  echo "${1}" | bc -l;
}

export PATH="${PATH}:$HOME/scripts:$HOME/.node_modules/bin:$HOME/.gem/ruby/2.2.0/bin"
export TERM="xterm-256color"
export TERMINAL="mate-terminal"
export EDITOR="vim"
