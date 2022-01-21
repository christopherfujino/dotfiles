#!/usr/bin/env bash

MONOREPO="$HOME/git/chris-monorepo"

if [[ ! -d "$MONOREPO" ]]; then
  1>&2 echo "Directory not found: $MONOREPO"
  exit 1
fi

echo "cd \"$MONOREPO\""

cd "$MONOREPO"
