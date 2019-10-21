#!/bin/bash

cd "$HOME/git/chrome_infra/build/scripts/slave/recipes/flutter"

UNAME=$(uname)

if [ $UNAME == 'darwin' ]; then
  OPEN='open'
elif [ $UNAME == 'linux' ]; then
  OPEN='xdg-open'
else
  OPEN='echo'
fi

if [ -z $1 ]; then
  echo Please specify package name
  exit 1
fi

led get-builder 'luci.flutter.prod:ios-deploy' |\
  led edit -p 'revision="123abc"' |\
  led edit -p "package_name=\"$1\"" |\
  led edit-recipe-bundle |\
  led launch |\
  tail -n 1 |\
  grep -o 'https.*$' |\
  xargs $OPEN
