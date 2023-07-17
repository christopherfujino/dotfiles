#
# ~/.bashrc
#

# OS dependent config
OS=$(uname)
if [ "$OS" = Linux ]; then
  alias ls='ls --color=auto'

  shopt -s direxpand

  #export TERM="screen-256color"
elif [ "$OS" = Darwin ]; then
  alias ls='ls -G' # color

  #[ -f /usr/local/bin/brew ] && PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  # we can't use zsh yet, macOS
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

alias ..='cd ..'

alias dudot='du -hd 1'

alias ll='ls -Alh'
alias lsa='ls -A' # -A means ignore '.' & '..'

alias g=git
alias gs='git status'
alias gb='git branch'
alias gupdate='git add . && git commit --amend'
# -x means include processes without an attached tty
alias psx='ps x | less'

function gcheckoutremote {
  # Validate argument
  [ -z "$1" ] && 2>&1 echo 'Usage: gcheckoutremote $REMOTE_NAME' && return
  git fetch "$1"
  # git ls-remote... list all branches on a remote
  # sed ... capture just the branch name
  # fzf ... allow user to select a branch
  # xargs ... checkout selected branch
  git ls-remote --heads "$1" | \
    sed 's/.*refs\/heads\/\([a-zA-Z0-9./_-]*\)/\1/' | \
    fzf --no-multi | \
    xargs git checkout
}

alias grepi='grep -i'

# Text editors
alias emacs='emacs -nw' # default to console-based emacs

PS1='\w\$ '

function add_to_path_if_not_present {
  local path="$1"
  [ ! -d "$path" ] && return
  # The second argument is optional, but will speed up this function
  local paths="${2:-$(echo "$PATH" | tr : '\n')}"
  echo "$paths" | grep --fixed-string --line-regexp "$dir" >/dev/null
  # Add $dir to $PATH if it does not yet appear
  [ "$?" -ne 0 ] && PATH="$dir:$PATH"
}

function monorepo {
  local path="$1"
  MONOREPO="$HOME/git/chris-monorepo"

  if [[ ! -d "$MONOREPO" ]]; then
    1>&2 echo "Directory not found: $MONOREPO"
    exit 1
  fi

  if [ -n "$path" ]; then
    echo "cd $MONOREPO/$path"
    cd "$MONOREPO/$path"
  else
    echo "cd $MONOREPO"
    cd "$MONOREPO"
  fi
}

if type nvim >/dev/null 2>&1; then
  export VISUAL=nvim
elif type vim >/dev/null 2>&1; then
  export VISUAL=vim
elif type vi >/dev/null 2>&1; then
  export VISUAL=vi
else
  echo "You don't have a vi-compliant editor!"
  exit 1
fi

export EDITOR=$VISUAL

# initialize BASE16 w/output in subshell
# shellcheck source=/dev/null
[ -f "$HOME/.config/base16-shell/profile_helper.sh" ] && source "$HOME/.config/base16-shell/profile_helper.sh"

[ -d "$HOME/notes" ] && export NOTES="$HOME/notes"
if [ -d "$HOME/git" ]; then
  export GIT="$HOME/git"
  [ -d "$GIT/dotfiles" ] && export DOTFILES="$GIT/dotfiles"
  if [ -d "$GIT/flutter" ]; then
    export FLUTTER="$GIT/flutter"
    export DART_SDK="$FLUTTER/bin/cache/dart-sdk"
  fi
fi

# golang dev

[ -d "$HOME/go" ] && export GOPATH="$HOME/go"

# add dirs to path, if they exist
dirs=(
  "$HOME/scripts"
  "$HOME/go/bin"
  "$HOME/.node_modules/bin"
  "$HOME/.nvm"
  "$HOME/.pub-cache/bin"
  "$HOME/git/depot_tools"
  "$HOME/git/chris-monorepo/bin"
  # local home bin takes precedence over monorepo bin
  "$HOME/bin"
  # this should probably only be on the PATH if we're running with dev-chroot
  #"$HOME/git/chris-monorepo/bin"
  "$HOME/.cargo/bin"
  "$HOME/Library/Python/2.7/bin"
  "$HOME/.local/bin" # pip3
  "$HOME/flutter_goma"
  #"$HOME/.rvm/bin"
  "$HOME/.deno/bin"
  # mac ports
  '/opt/local/bin'
  '/opt/local/sbin'
)

paths=$(echo "$PATH" | tr : '\n')
for dir in "${dirs[@]}"; do
  add_to_path_if_not_present "$dir" "$paths"
done

# source config files, if they exist
files=(
  /usr/local/opt/nvm/nvm.sh
  "$HOME/.fzf.bash"
  /usr/local/etc/bash_completion
  "$HOME/.rvm/scripts/rvm"
  "$HOME/.flutter-completion"
  "$HOME/.cargo/env"
)

for i in "${files[@]}"; do
  # shellcheck source=/dev/null
  [ -f "$i" ] && source "$i"
done

# if ruby dev env set...
if type gem >/dev/null 2>&1; then
  if type rbenv >/dev/null 2>&1; then
    eval "$(rbenv init -)"
    add_to_path_if_not_present "$HOME/.rbenv/bin"
  fi

  add_to_path_if_not_present "$(ruby -e 'print Gem.user_dir')/bin"

  alias rrg='rake routes | grep -i'
fi

if type lesspipe.sh >/dev/null 2>&1; then
  export LESS=-r
  export LESSOPEN="|lesspipe.sh %s"
fi

# fzf
if type fzf >/dev/null 2>&1; then
  alias checkout="git branch --list --sort=-committerdate | sed 's/^\*/ /' | fzf | xargs git checkout"
  alias branchd="git branch --list --sort=-committerdate | sed -E 's/^[ *]+//' | fzf --multi | xargs git branch -d --force"
  alias darttest="find test/ -name '*_test.dart' | fzf | xargs dart test"
else
  echo "Warning! fzf not installed, and it's awesome!"
fi

# opam configuration
test -r /usr/local/google/home/fujino/.opam/opam-init/init.sh && . /usr/local/google/home/fujino/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# source local-machine specific config if it exists
# shellcheck source=/dev/null
[ -f "$HOME/.bashrc.local" ] && source "$HOME/.bashrc.local"

function count_duplicate_path_entries {
  COUNT=$(echo "$PATH" | tr : '\n' | sort | uniq -d | wc -l)
  if [ "$COUNT" -gt 0 ]; then
    echo 'Warning! You have duplicate entries in your PATH:'
    echo "$PATH" | tr : '\n' | sort | uniq -d
  fi
}

function detect_autogenerated_lines {
  CURRENT_SCRIPT_NAME="${BASH_SOURCE[0]}"
  LAST_LINE=$(tail -n 1 "$CURRENT_SCRIPT_NAME")
  if [ "$LAST_LINE" != '# Anything after here was auto-generated' ]; then
    echo "Warning! The following has been appended to the end of ${CURRENT_SCRIPT_NAME}:"
    echo
    tput setaf 1
    perl -e 'print reverse <>' <"$CURRENT_SCRIPT_NAME" | sed -n '1,/Anything after here was auto-generated/p' | perl -e 'print reverse <>'

    tput sgr0
  fi
}

export PATH

count_duplicate_path_entries
detect_autogenerated_lines

# Anything after here was auto-generated
