#!/usr/bin/env bash

set -euo pipefail

if [ -z "$1" ]; then
  echo 'Please provide remote name as first argument'
  exit 1
fi

git push "$1" HEAD:refs/for/master
