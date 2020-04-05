#!/bin/bash

set -eo pipefail

rm "$HOME/git/flutter/bin/cache/flutter_tools.s*" || true

if [[ -z "$1" ]]; then
  flutter run
else
  flutter "$@"
fi
