#!/usr/bin/env bash

i=0

function color_print() {
  printf "%d \e[%dm%s \e[39mdefault\n" $i $1 "$2"
  i=$(($i + 1))
}

color_print 30 black
color_print 31 red
color_print 32 green
color_print 33 yellow
color_print 34 blue
color_print 35 magenta
color_print 36 cyan
color_print 37 'light gray'
color_print 90 'dark gray'
color_print 91 'light red'
color_print 92 'light green'
color_print 93 'light yellow'
color_print 94 'light blue'
color_print 95 'light magenta'
color_print 96 'light cyan'
color_print 97 white
