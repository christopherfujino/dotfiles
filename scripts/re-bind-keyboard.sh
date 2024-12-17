#!/usr/bin/env bash

# https://faq.i3wm.org/question/1496/change-caps-lock-to-esc-in-i3.1.html
setxkbmap -layout us -option caps:escape

if lsusb | grep 'Kinesis Corporation Kinesis Freestyle2 MAC' > /dev/null; then
  # altwin:swap_lalt_lwin Left Alt is swapped with Left Win
  setxkbmap -option altwin:swap_lalt_lwin

  # https://unix.stackexchange.com/questions/106468/remapping-power-key-to-delete
  # This must be after any setxkbmap commands(?!)
  xmodmap -e "keycode 124 = NoSymbol"
fi
