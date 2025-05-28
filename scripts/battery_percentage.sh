#!/usr/bin/env bash

PREFIX='/sys/class/power_supply/qcom-battmgr-bat/energy_'
FULL=$(cat "${PREFIX}full")
NOW=$(cat "${PREFIX}now")
EMPTY=$(cat "${PREFIX}empty")

CURRENT_ADJUSTED=$(calc -d "$NOW - $EMPTY")
FULL_ADJUSTED=$(calc -d "$FULL - $EMPTY")

BAT_FORMATTED=$(calc -d "$CURRENT_ADJUSTED / $FULL_ADJUSTED * 100" |\
  awk '{print $1}' |\
  xargs printf "%.1f%%")

printf "$(date +'%H:%M') B(%s)" "$BAT_FORMATTED"

# man 7 swaybar-protocol
#printf '{"version": 1}
#[
#  [
#    {"full_text": "25%%", "min_width": "100%%", "urgent": false},
#    {"full_text": "123"}
#  ]
#]
#'
