#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# OS dependent config
OS=$(uname)
if [ $OS = Linux ]; then
  alias ls='ls --color=auto'

  export TERM="xterm-256color"
elif [ $OS = Darwin ]; then
  alias ls='ls -G' # color

  # TODO: find a way to detect homebrew without checking `type`
  PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

alias ..='cd ..'

alias ll='ls -Alh'
alias lsa='ls -A' # -A means ignore '.' & '..'

alias g='git'
alias gs='git status'
alias gb='git branch'

alias grepi='grep -i'

# Text editors
alias emacs='emacs -nw' # default to console-based emacs

if type nvim >/dev/null 2>&1; then
  export VISUAL='nvim'
elif type vim >/dev/null 2>&1; then
  export VISUAL='vim'
else
  export VISUAL='vi'
fi

export EDITOR="$VISUAL"

PS1='\u@\h \W\$ '

if [ -d "$HOME/.config/base16-shell" ]; then # Base16 Shell
  BASE16_SHELL=$HOME/.config/base16-shell/
  [ -f $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
fi

[ -d "$HOME/notes" ] && export NOTES="$HOME/notes"

# add dirs to path, if they exist
dirs=(
  "$HOME/scripts"
  "$HOME/.node_modules/bin"
  "$HOME/.nvm"
  "$HOME/.rvm/bin"
)
for i in "${dirs[@]}"; do
  [ -d "$i" ] && PATH="$i:$PATH"
done

# source config files, if they exist
files=(
  /usr/local/opt/nvm/nvm.sh
  "$HOME/.fzf.bash"
  /usr/local/etc/bash_completion
  "$HOME/.rvm/scripts/rvm"
)

for i in "${files[@]}"; do
  [ -f "$i" ] && source "$i"
done

# if ruby dev env set...
if type gem >/dev/null 2>&1; then

  if type rbenv >/dev/null 2>&1; then
    # initialize rbenv
    eval "$(rbenv init -)"
  fi

  # if `gem` is installed, add Gem dir to $PATH
  PATH="$HOME/.rbenv/bin:$(ruby -e 'print Gem.user_dir')/bin:$PATH"

  alias rrg='rake routes | grep -i'
fi

# source local-machine specific config if it exists
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

export PATH
