#!/usr/bin/env bash

set -euo pipefail

BIN="$(which "$@")"
"$EDITOR" "$BIN"
