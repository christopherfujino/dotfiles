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

# For every branch that is up to date or successfully pushed, add upstream
# (tracking) reference, used by argument-less git-pull(1) and other commands.
OUTPUT=$(git push --porcelain --set-upstream "$REMOTE" HEAD)

# e.g.
#
# To github.com:christopherfujino/dotfiles.git
# *       HEAD:refs/heads/feature-branch  [new branch]
# Branch 'feature-branch' set up to track remote branch 'feature-branch' from 'origin'.
# Done

echo "$OUTPUT"

#REGEX='up to date'
#if [[ $OUTPUT =~ $REGEX ]]; then
#  echo "Your branch is already up to date with $REMOTE. Exiting..."
#  exit 1
#fi

if [[ $CURRENT_BRANCH == 'master' ]]; then
  # No need to open a PR
  exit 0
fi

REGEX='To github\.com:(.*)\.git'
if [[ ! $OUTPUT =~ $REGEX ]]; then
  echo "Error! Pattern \"$REGEX\" not found in output."
  exit 1
fi

REPO="github.com/${BASH_REMATCH[1]}"

REGEX="[Bb]ranch '(.*)' set up to track (remote branch )?"
if [[ ! $OUTPUT =~ $REGEX ]]; then
  echo "Error! Pattern \"$REGEX\" not found in output."
  exit 1
fi

BRANCH=${BASH_REMATCH[1]}

# TODO "$REPO/compare/$UPSTREAM_BRANCH...$USERNAME:$LOCAL_BRANCH?expand=1"
URL="$REPO/compare/$BRANCH?expand=1"


if [ "$SHOULD_OPEN_CHROME" != 'TRUE' ]; then
  echo "To open a PR:\n"
  echo $URL
  exit 0
fi

echo "Opening $URL with $OPEN..."
$OPEN "$URL" &>/dev/null &
