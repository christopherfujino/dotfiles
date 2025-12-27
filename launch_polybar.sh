#!/usr/bin/env bash

set -euo pipefail

POLYBAR_DEBUGGING='' # false
#POLYBAR_DEBUGGING='true'

BAR_NAME='my_great_bar'

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
polybar-msg cmd quit || true

for m in $(xrandr --query | grep ' connected' | awk '{print $1}'); do
  if [[ -n "$POLYBAR_DEBUGGING" ]]; then
    LOG_FILE="/tmp/polybar${m}.log"
    echo "Launching polybar with debug logging at $LOG_FILE"
    MONITOR=$m polybar "$BAR_NAME" 2>&1 | tee -a "$LOG_FILE" & disown
  else
    MONITOR=$m polybar "$BAR_NAME" 2>&1 >/dev/null & disown
  fi
done
