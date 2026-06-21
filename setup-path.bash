#!/usr/bin/env bash

# Must define this, even if we already have the env var set...
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

if [[ -n "$SETUP_PATH_BASH_EXECUTED" ]]; then
  return
fi

export SETUP_PATH_BASH_EXECUTED=1

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
