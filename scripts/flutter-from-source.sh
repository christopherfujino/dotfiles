#!/bin/bash

set -eo pipefail

ENTRYPOINT="$HOME/git/flutter/packages/flutter_tools/lib/executable.dart"

if [ ! -f "$ENTRYPOINT" ]; then
  echo "$ENTRYPOINT does not exist as a file!"
  exit 1
fi

dart "$ENTRYPOINT" "$@"
