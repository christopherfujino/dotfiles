#!/usr/bin/env bash

set -euo pipefail

TEST_NAME="$(find . -name '*_test.dart' | fzf -m)"

COMMAND="dart test $TEST_NAME"

$COMMAND
