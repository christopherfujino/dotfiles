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

if [[ "$CURRENT_BRANCH" == 'master' ]] || [[ "$CURRENT_BRANCH" == 'main' ]]; then
  echo "Error! You are on $CURRENT_BRANCH!"
  # No need to open a PR
  exit 1
fi

REMOTE="$1"
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

REGEX='To github\.com:(.*)\.git'
if [[ ! $OUTPUT =~ $REGEX ]]; then
  echo "Error! Pattern \"$REGEX\" not found in output."
  exit 1
fi

REPO="https://github.com/${BASH_REMATCH[1]}"

REGEX="[Bb]ranch '(.*)' set up to track .*"
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
