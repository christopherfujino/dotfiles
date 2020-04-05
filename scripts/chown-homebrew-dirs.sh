#!/bin/bash

if [ "$(uname)" != 'Darwin' ]; then
  echo "This script only supports Homebrew on mac."
  exit 1
fi

echo "sudo chown -R \$(whoami) /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc"

# see SC2162 for -r
read -pr 'Hit enter to proceed...'

sudo chown -R "$(whoami)" /usr/local/bin /usr/local/etc /usr/local/sbin /usr/local/share /usr/local/share/doc
