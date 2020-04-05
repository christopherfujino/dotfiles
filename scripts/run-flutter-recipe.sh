#!/bin/bash

set -euo pipefail

cd "$HOME/git/chrome_infra/build/scripts/slave/recipes/flutter"

UNAME=$(uname)

if [ "$UNAME" == 'darwin' ]; then
  OPEN='open'
elif [ "$UNAME" == 'linux' ]; then
  OPEN='xdg-open'
else
  OPEN='echo'
fi

if [ -z "$1" ]; then
  echo Please specify package name
  exit 1
fi

COMMIT_HASH='8fb14f99a8854d4e2b16559c0eb48e7c297065ce'

led get-builder 'luci.flutter.prod:libimobiledevice' |\
  led edit -p "commit_hash=\"$COMMIT_HASH\"" |\
  led edit -p "package_name=\"$1\"" |\
  led edit-recipe-bundle |\
  led launch |\
  tail -n 1 |\
  grep -o 'https.*$' |\
  xargs $OPEN
