#!/bin/bash

set -eo pipefail

if [ -z "$1" ]; then
  echo 'Usage!'
  exit 1
fi

INPUT="$1"

set -u

if ! type mdvl.py >/dev/null 2>&1; then
  echo 'This script requires mdvl.py to render markdown.'
  echo 'You can get it from https://github.com/axiros/mdvl. Then add it to your'
  echo '$PATH.'
  exit 1
fi

clear
cat $INPUT | mdvl.py | less -R
