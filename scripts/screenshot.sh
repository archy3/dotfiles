#!/bin/sh

# TODO:
# Process fulscreen images on multimonitor setups to split the image
# into one separate image per monitor.
# Give nsxiv a crop command (longterm).

# Takes a screenshot with maim and then opens the screenshot with nsxiv.
# The first and only argument should be <f|s|S|F|c|C>.

# Argument meanings:
# f: fullscreen
# s: select with decorations
# S: select without decorations

# F: fullscreen and captures cursor
# c: select with decorations and captures cursor
# C: select without decorations and captures cursor

# The cursor capturing options have a delay to allow enough time to
# position the cursor to the desired location.

date="$(date +%Y-%m-%d-%T)" || return "$?"
screenshot="${HOME}/pictures/screenshots/${date}.png"
delay="5.0"

case "$1" in
  f) maim --hidecursor --window=root -- "$screenshot";;
  s) maim --hidecursor --select --color=1,0,0,0.6 -- "$screenshot";;
  S) maim --hidecursor --nodecorations --select --color=1,0,0,0.6 -- "$screenshot";;
  F) maim --delay="$delay" --window=root -- "$screenshot";;
  c) maim --delay="$delay" --select --color=1,0.5,0,0.6 -- "$screenshot";;
  C) maim --delay="$delay" --nodecorations --select --color=1,0.5,0,0.6 -- "$screenshot";;
esac || return "$?"

if test -f "$screenshot"; then
  nsxiv -b -- "$screenshot"
fi
