#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OS=$(uname)
PATH=$PATH

export VISUAL="nvim"
export EDITOR="nvim"
export NOTES="~/notes"

#alias ls='ls --color=auto' #this is os-dependent
alias emacs='emacs -nw' # default to console-based emacs
alias ..='cd ..'
alias g='git'

if [ $HOSTNAME = "ac" ]; then
  # This is specific for my chromebook
  export PATH="${PATH}:$HOME/scripts:$HOME/.node_modules/bin:$HOME/.gem/ruby/2.3.0/bin"
  alias upd='timedatectl | grep Local; yaourt -Syua'
  alias yaourt-stats='yaourt --stats'
  export STEAM_RUNTIME=0 # for Steam
  #export TERM="xterm-256color"
  export TERM="rxvt-unicode-256color"
  export LIBVA_DRIVER_NAME="i965" # for arch hardware rendering
  export TERMINAL="urxvt"
  alias dfh='df -h /dev/sda1'
elif [ $HOSTNAME = "x270" ]; then
  export TERM="xterm-256color"
fi

if [ $OS = "Linux" ]; then
  alias ls='ls --color=auto'
  alias ll='ls -Alh --color=auto'
  alias lsa='ls -A' # -A means ignore '.' & '..'

  #Base16 Shell
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
elif [ $OS = "Darwin" ]; then
  alias ls='ls -G'
  alias ll='ls -AlhG'
  alias lsa='ls -A' # -A means ignore '.' & '..'
  alias dfh='df -h /dev/disk0s2'
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

if [ -d "$HOME/scripts" ]; then
  PATH="$HOME/scripts:$PATH"
fi

if [ -d "$HOME/.node_modules/bin" ]; then
  PATH="$HOME/.node_modules/bin:$PATH"
fi

if type ruby 2>/dev/null; then
  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

PS1='\u@\h \W\$ '

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -d "$HOME/.rvm/bin" ]; then
  PATH="$HOME/.rvm/bin:$PATH"
fi

export PATH
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
