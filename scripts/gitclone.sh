#!/usr/bin/env bash
set -euo pipefail

echo "git clone git@github.com:$@"
git clone "git@github.com:$@"
