#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

OS=$(uname)
#PATH=$PATH

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
  export TERM="rxvt-unicode-256color"
  export LIBVA_DRIVER_NAME="i965" # for arch hardware rendering
  export TERMINAL="urxvt"
  alias dfh='df -h /dev/sda1'
fi

if [ $OS = "Linux" ]; then
  alias ls='ls --color=auto'
  alias ll='ls -Alh --color=auto'
  alias lsa='ls -A' # -A means ignore '.' & '..'

  export TERM="xterm-256color"
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
  # if `$HOME/scripts` exists, add it to path
  PATH="$HOME/scripts:$PATH"
fi

if [ -d "$HOME/.node_modules/bin" ]; then
  # if `.node_modules` exists, add it to path
  PATH="$HOME/.node_modules/bin:$PATH"
fi

if type ruby 2>/dev/null; then
  # if `ruby` is installed, add Gem dir to $PATH
  PATH="$HOME/.rbenv/bin:$(ruby -e 'print Gem.user_dir')/bin:$PATH"
fi

# initialize rbenv
eval "$(rbenv init -)"

PS1='\u@\h \W\$ '
