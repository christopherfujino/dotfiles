#!/bin/bash

PLATFORM=$(uname)
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  SHOULD_OPEN_CHROME='TRUE'
fi

if [ "$PLATFORM" == 'Darwin' ]; then
  OPEN='open'
elif [ "$PLATFORM" == 'Linux' ]; then
  OPEN='xdg-open'
else
  echo "Oops! You're on $PLATFORM. I don't know what that is..."
  exit 1
fi

REMOTE="$1"

if [[ -z "$REMOTE" ]]; then
  # Set exit so that user can abort with SIGINT to fzf
  set -eo pipefail
  # Parses output that looks like:
  #
  # a-siva  git@github.com:a-siva/flutter.git
  # a-siva  git@github.com:a-siva/flutter.git
  # eliasyishak     git@github.com:eliasyishak/flutter.git
  # eliasyishak     git@github.com:eliasyishak/flutter.git
  # itsjustkevin    git@github.com:itsjustkevin/flutter.git
  # itsjustkevin    git@github.com:itsjustkevin/flutter.git
  # origin  git@github.com:christopherfujino/flutter.git
  # origin  git@github.com:christopherfujino/flutter.git
  # upstream        git@github.com:flutter/flutter.git
  # upstream        git@github.com:flutter/flutter.git
  REMOTE=$( \
    git remote -v | \
    sed -n 's/^\([a-zA-Z_-]\+\)\t\+\([^ ]\+\).*$/\1\t\2/p' | \
    uniq | \
    tac | \
    fzf | \
    sed -n 's/^\([a-zA-Z_-]\+\).*/\1/p' \
  )
  set +eo pipefail
fi

# clone STDOUT as 3 as a write FD
exec 3>&1

# For every branch that is up to date or successfully pushed, add upstream
# (tracking) reference, used by argument-less git-pull(1) and other commands.
#
# `tee` to 3 (stdout) but also capture in the $OUTPUT var.
#
# Logs from the remote go to STDERR, so redirect it
OUTPUT=$(git push --porcelain --set-upstream "$REMOTE" HEAD 2>&1 | tee >(cat >&3))

# close 3
exec 3>&-

if [[ "$CURRENT_BRANCH" == 'master' || "$CURRENT_BRANCH" == 'main' ]]; then
  # No need to open a PR
  exit 0
fi

# With output like:
#
# Enumerating objects: 7, done.
# Counting objects: 100% (7/7), done.
# Delta compression using up to 72 threads
# Compressing objects: 100% (4/4), done.
# Writing objects: 100% (4/4), 371 bytes | 371.00 KiB/s, done.
# Total 4 (delta 3), reused 0 (delta 0), pack-reused 0 (from 0)
# remote: Resolving deltas: 100% (3/3), completed with 3 local objects.
# remote:
# remote: Create a pull request for 'foo-bar' on GitHub by visiting:
# remote:      https://github.com/christopherfujino/dotfiles/pull/new/foo-bar
# remote:
# To github.com:christopherfujino/dotfiles
# *       HEAD:refs/heads/foo-bar [new branch]
# branch 'foo-bar' set up to track 'origin/foo-bar'.
LINK=$( \
  echo "$OUTPUT" | \
  sed -n '/Create a pull request for/{n;p;}' | \
  sed -n 's/remote:[ ]\+\(.*\)$/\1/p' \
)

if [[ -z "$LINK" ]]; then
  echo 'Failed to parse the output from git push!' >&2
  exit 1
fi

if [[ "$SHOULD_OPEN_CHROME" != 'TRUE' ]]; then
  printf "To open a PR:\n$LINK"
  exit 0
fi

echo "Opening $LINK with $OPEN..."
$OPEN "$LINK" &>/dev/null &
