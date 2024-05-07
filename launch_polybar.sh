#!/usr/bin/env bash

set -euo pipefail

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit || true

polybar my_great_bar 2>&1 | tee -a /tmp/polybar.log & disown

echo 'polybar launched...'
