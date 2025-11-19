# Return early on non-interactive sessions, lest scp not work.
[[ $- == *i* ]] || return

function __chris_colorscheme() {
  if [ "${TERM%%-*}" = 'linux' ]; then
    set_color() { printf "\e]P%x%s" $1 $2; }
    set_fg() { true; }
    set_bg() { true; }
  else
    set_color() {
      local COLOR=$(echo $2 | sed 's/^\(.\{2\}\)\(.\{2\}\)\(.\{2\}\)$/\1\/\2\/\3/g')
      printf '\033]4;%d;rgb:%s\033\\' $1 $COLOR;
    }
    set_fg() {
      printf '\033]10;rgb:%s\033\\' $(echo $1 | sed 's/^\(.\{2\}\)\(.\{2\}\)\(.\{2\}\)$/\1\/\2\/\3/g');
    }
    set_bg() {
      printf '\033]11;rgb:%s\033\\' $(echo $1 | sed 's/^\(.\{2\}\)\(.\{2\}\)\(.\{2\}\)$/\1\/\2\/\3/g');
    }
  fi

  local ansi00="2d2d2d" # Base 00 - Black
  local ansi01="f2777a" # Base 08 - Red
  local ansi02="99cc99" # Base 0B - Green
  local ansi03="ffcc66" # Base 0A - Yellow
  local ansi04="6699cc" # Base 0D - Blue
  local ansi05="cc99cc" # Base 0E - Magenta
  local ansi06="66cccc" # Base 0C - Cyan
  local ansi07="d3d0c8" # Base 05 - White
  local ansi08="747369" # Base 03 - Bright Black
  local ansi09=$ansi01 # Base 08 - Bright Red
  local ansi10=$ansi02 # Base 0B - Bright Green
  local ansi11=$ansi03 # Base 0A - Bright Yellow
  local ansi12=$ansi04 # Base 0D - Bright Blue
  local ansi13=$ansi05 # Base 0E - Bright Magenta
  local ansi14=$ansi06 # Base 0C - Bright Cyan
  local ansi15="f2f0ec" # Base 07 - Bright White
  local foreground=$ansi07
  local background=$ansi00

  set_color 0 $ansi00;
  set_color 1 $ansi01;
  set_color 2 $ansi02;
  set_color 3 $ansi03;
  set_color 4 $ansi04;
  set_color 5 $ansi05;
  set_color 6 $ansi06;
  set_color 7 $ansi07;
  set_color 8 $ansi08;
  set_color 9 $ansi09;
  set_color 10 $ansi10;
  set_color 11 $ansi11;
  set_color 12 $ansi12;
  set_color 13 $ansi13;
  set_color 14 $ansi14;
  set_color 15 $ansi15;

  # FG 10 color07 (base05)
  set_fg $foreground;

  # BG 11 color00
  set_bg $background;

  unset set_color
  unset set_var
}

__chris_colorscheme

alias reset='command reset && __chris_colorscheme'

# OS dependent config
OS=$(uname)
if [ "$OS" = Linux ]; then
  alias ls='ls --color=auto'

  shopt -s direxpand
elif [ "$OS" = Darwin ]; then
  alias ls='ls -G' # color

  #[ -f /usr/local/bin/brew ] && PATH="/usr/local/bin:/usr/local/sbin:$PATH"
  # we can't use zsh yet, macOS
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

alias ..='cd ..'

alias dudot='du -hd 1'

alias ll='ls -Alh --color=auto'

alias g=git
# -x means include processes without an attached tty
alias psx='ps x | less'

# install paccache via `pacman -S pacman-contrib`
alias pacupdateclean='\
  sudo pacman -Syu && \
  paccache --remove --uninstalled --keep 3 && \
  paccache --remove --keep 3'

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
  echo "$paths" | grep --fixed-string --line-regexp "$1" >/dev/null
  # Add $dir to $PATH if it does not yet appear
  if [ "$?" -ne 0 ]; then
    PATH="$1:$PATH"
  fi
}

if type nvim >/dev/null 2>&1; then
  export VISUAL=nvim
elif type vim >/dev/null 2>&1; then
  export VISUAL=vim
elif type vi >/dev/null 2>&1; then
  export VISUAL=vi
else
  echo "You don't have a vi-compliant editor!" >&2
fi

export EDITOR=$VISUAL

# golang dev

[ -d "$HOME/go" ] && export GOPATH="$HOME/go"

# add dirs to path, if they exist
dirs=(
  "$HOME/scripts"
  "$HOME/go/bin"
  "$HOME/.node_modules/bin"
  "$HOME/node_modules/bin"
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
  "$HOME/.fzf.bash"
  /usr/local/etc/bash_completion
  "$HOME/.rvm/scripts/rvm"
  "$HOME/.flutter-completion"
  "$HOME/.cargo/env"
  "$HOME/.local/share/gem/ruby/3.3.0/bin"
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
fi

# fzf
if type fzf >/dev/null 2>&1; then
  alias checkout="git branch --list --sort=-committerdate | sed 's/^\*/ /' | fzf | xargs git checkout"
  alias branchd="git branch --list --sort=-committerdate | sed -E 's/^[ *]+//' | fzf --multi | xargs git branch -d --force"
else
  echo "Warning! fzf not installed, and it's awesome!" 1>&2
fi

# opam configuration
test -r "$HOME/.opam/opam-init/init.sh" && . "$HOME/.opam/opam-init/init.sh" > /dev/null 2> /dev/null || true

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

# https://www.architectryan.com/2012/10/02/add-to-the-path-on-mac-os-x-mountain-lion/#.Uydjga1dXDg
if [[ $(uname) == 'Darwin' && -f /etc/paths ]]; then
  PATHS_LENGTH=$(wc -l /etc/paths | awk '{print $1}')
  if [[ "$PATHS_LENGTH" -gt 0 ]]; then
    echo "Warning, you have a populated /etc/paths file that will prepend to your \$PATH var" >&2
  fi
fi

export PATH

count_duplicate_path_entries
detect_autogenerated_lines

# Anything after here was auto-generated
