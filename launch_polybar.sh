#!/usr/bin/env bash

set -euo pipefail

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit || true

for m in $(xrandr --query | grep ' connected' | awk '{print $1}'); do
  MONITOR=$m polybar my_great_bar & disown
  #polybar my_great_bar 2>&1 | tee -a /tmp/polybar.log & disown
done

echo 'polybar launched...'
