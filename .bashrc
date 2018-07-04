#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# OS dependent config
OS=$(uname)
if [ "$OS" = Linux ]; then
  alias ls='ls --color=auto'

  export TERM="xterm-256color"
elif [ "$OS" = Darwin ]; then
  alias ls='ls -G' # color

  #[ -f /usr/local/bin/brew ] && PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

alias ..='cd ..'

alias ll='ls -Alh'
alias lsa='ls -A' # -A means ignore '.' & '..'

alias g=git
alias gs='git status'
alias gb='git branch'

alias grepi='grep -i'

alias dudot='du -chd 1 .'

# Text editors
alias emacs='emacs -nw' # default to console-based emacs

if type nvim >/dev/null 2>&1; then
  export VISUAL=nvim
elif type vim >/dev/null 2>&1; then
  export VISUAL=vim
else
  export VISUAL=vi
fi

export EDITOR=$VISUAL

PS1='\u@\h \W\$ '

# initialize BASE16 w/output in subshell
# shellcheck source=/dev/null
[ -f "$HOME/.config/base16-shell/profile_helper.sh" ] && eval "$("$HOME/.config/base16-shell/profile_helper.sh")"

[ -d "$HOME/notes" ] && export NOTES="$HOME/notes"

# add dirs to path, if they exist
dirs=(
  "$HOME/scripts"
  "$HOME/bin"
  "$HOME/go/bin"
  "$HOME/.node_modules/bin"
  "$HOME/.nvm"
  "$HOME/anaconda3/bin"
  #"$HOME/.rvm/bin"
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
  # shellcheck source=/dev/null
  [ -f "$i" ] && . "$i"
done

# if ruby dev env set...
if type gem >/dev/null 2>&1; then
  if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
    PATH="$HOME/.rbenv/bin:$PATH"
  fi

  PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"

  alias rrg='rake routes | grep -i'
fi

if type lesspipe.sh >/dev/null 2>&1; then
  export LESS=-r
  export LESSOPEN="|lesspipe.sh %s"
fi

# source local-machine specific config if it exists
# shellcheck source=/dev/null
[ -f "$HOME/.bashrc.local" ] && . "$HOME/.bashrc.local"

function count_duplicate_path_entries {
  COUNT=$(echo "$PATH" | tr : '\n' | sort | uniq -d | wc -l)
  if [ "$COUNT" -gt 0 ]; then
    echo 'Warning! You have duplicate entries in your PATH:'
    echo "$PATH" | tr : '\n' | sort | uniq -d
  fi
}

export PATH

count_duplicate_path_entries
