#!/bin/bash

REMOTE='origin'
OUTPUT=$(git push --porcelain -u "$REMOTE" HEAD)

echo "$OUTPUT"

REGEX='up to date'
if [[ $OUTPUT =~ $REGEX ]]; then
  echo "Your branch is already up to date with $REMOTE. Exiting..."
  exit 1
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

xdg-open "$URL" &>/dev/null &
