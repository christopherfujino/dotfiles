#!/bin/bash

cd "$HOME/git/chrome_infra/build/scripts/slave/recipes/flutter"

if [ -z $1 ]; then
  echo Please specify package name
  exit 1
fi

led get-builder 'luci.flutter.prod:Mac' |\
  led edit -p 'revision="123abc"' |\
  led edit -p "package_name=\"$1\"" |\
  led edit-recipe-bundle |\
  led launch |\
  tail -n 1 |\
  grep -o 'https.*$' |\
  xargs open
