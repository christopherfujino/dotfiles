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

alias dotfiles='cd $DOTFILES'

alias dudot='du -hd 1'

alias ll='ls -Alh'
alias lsa='ls -A' # -A means ignore '.' & '..'

alias g=git
alias checkout='git checkout $(git branch | fzf)'
alias gs='git status'
alias gb='git branch'
alias gupdate='git add . && git commit --amend'

alias grepi='grep -i'

# Aliases to clean up docker containers/images
# You can also do: `docker image prune`
# shellcheck disable=2142
alias dockerimageclean="docker rmi \$(docker images | awk '\$1 == \"<none>\" && \$2 == \"<none>\" {print \$3}')"
# You can also do: `docker container prune`
# shellcheck disable=2142
alias dockercontainerclean="docker rm \$(docker ps -a | awk '\$1 != \"CONTAINER\" {print \$1}')"

# Text editors
alias emacs='emacs -nw' # default to console-based emacs

if type nvim >/dev/null 2>&1; then
  export VISUAL=nvim
elif type vim >/dev/null 2>&1; then
  export VISUAL=vim
elif type vi >/dev/null 2>&1; then
  export VISUAL=vi
else
  echo "Uh oh, you're in trouble..."
  exit 1
fi

export EDITOR=$VISUAL

PS1='\w\$ '

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
  #"$HOME/anaconda3/bin"
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

function detect_autogenerated_lines {
  CURRENT_SCRIPT_NAME="${BASH_SOURCE[0]}"
  LAST_LINE=$(tail -n 1 "$CURRENT_SCRIPT_NAME")
  if [ "$LAST_LINE" != '# Anything after here was auto-generated' ]; then
    echo "Warning! The following has been appended to the end of ${CURRENT_SCRIPT_NAME}:"
    echo
    # TODO: Figure out how to print only after pattern in SED
    tput setaf 1
    perl -e 'print reverse <>' <"$CURRENT_SCRIPT_NAME" | sed -n '1,/Anything after here was auto-generated/p' | perl -e 'print reverse <>'

    tput sgr0
  fi
}

export PATH

count_duplicate_path_entries
detect_autogenerated_lines

PROMPT_COMMAND='[ $? -eq 0 ] || printf "(╯°□°）╯︵ ┻━┻\n"'

# Anything after here was auto-generated
