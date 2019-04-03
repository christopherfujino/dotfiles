#!/bin/bash

PLATFORM=$(uname)
CURRENT_BRANCH=$(git symbolic-ref --short HEAD)

if [ "$PLATFORM" == 'Darwin' ]; then
  OPEN='open'
elif [ "$PLATFORM" == 'Linux' ]; then
  OPEN='xdg-open'
else
  echo "Oops! You're on $PLATFORM. I don't know what that is..."
  exit 1
fi

REMOTE='origin'
OUTPUT=$(git push --porcelain -u "$REMOTE" HEAD)

echo "$OUTPUT"

REGEX='up to date'
if [[ $OUTPUT =~ $REGEX ]]; then
  echo "Your branch is already up to date with $REMOTE. Exiting..."
  exit 1
fi

if [[ $CURRENT_BRANCH == 'master' ]]; then
  # No need to open a PR
  exit 0
fi

REGEX='To github\.com:(.*)\.git'
if [[ ! $OUTPUT =~ $REGEX ]]; then
  echo "Error! Pattern \"$REGEX\" not found in output."
  exit 1
fi

REPO="https://github.com/${BASH_REMATCH[1]}"

REGEX="Branch '(.*)' set up to track remote branch .* from .*\."
if [[ ! $OUTPUT =~ $REGEX ]]; then
  echo "Error! Pattern \"$REGEX\" not found in output."
  exit 1
fi

BRANCH=${BASH_REMATCH[1]}
URL="$REPO/compare/$BRANCH?expand=1"

echo "Opening $URL..."

$OPEN "$URL" &>/dev/null &
