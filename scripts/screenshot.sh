#!/bin/sh

# TODO:
# Process fullscreen images on multimonitor setups to split the image
# into one separate image per monitor.

# Takes a screenshot with maim and then opens the screenshot with nsxiv.
# The arguments should be [-clipboardonly] <f|s|S|F|c|C>.

# Argument meanings:
# -clipboardonly: Save the image to the clipboard instead of permanently saving
#                 to the disk (though a temp file will briefly be created).
#                 nsxiv will not be invoked.
#
# f: fullscreen
# s: select with decorations
# S: select without decorations

# F: fullscreen and captures cursor
# c: select with decorations and captures cursor
# C: select without decorations and captures cursor

# The cursor capturing options have a delay to allow enough time to
# position the cursor to the desired location.

# Global variables:
Screenshot=''
Clipboardonly=false

main()
{
  set -euf
  trap '[ "$?" != 0 ] && print_error_message; cleanup' EXIT

  format=png
  date="$(date +%Y-%m-%d-%T)"
  Screenshot="${HOME}/pictures/screenshots/${date}.${format}"
  delay='5.0'
  color_no_cursor='1,0,0,0.6'
  color_cursor='1,0.5,0,0.6'

  case "$1" in
    -clipboardonly) Clipboardonly=true; shift;;
  esac

  screenshot_type="$1"

  if [ "$Clipboardonly" = true ]; then
    Screenshot="$(mktemp)"
    color_no_cursor='0,1,0,0.6'
    color_cursor='1,1,0,0.6'
  fi

  case "$screenshot_type" in
    f) maim --format="$format" --hidecursor --window=root -- "$Screenshot";;
    s) maim --format="$format" --hidecursor --select --color="$color_no_cursor" -- "$Screenshot";;
    S) maim --format="$format" --hidecursor --nodecorations --select --color="$color_no_cursor" -- "$Screenshot";;
    F) maim --format="$format" --delay="$delay" --window=root -- "$Screenshot";;
    c) maim --format="$format" --delay="$delay" --select --color="$color_cursor" -- "$Screenshot";;
    C) maim --format="$format" --delay="$delay" --nodecorations --select --color="$color_cursor" -- "$Screenshot";;
  esac

  if [ -f "$Screenshot" ] && [ -s "$Screenshot" ]; then
    if [ "$Clipboardonly" = true ]; then
      xclip -selection clipboard -t image/png < "$Screenshot"

      case "$screenshot_type" in
        c|C|f|F) notify-send --icon=camera-photo -- 'Screenshot taken!';;
      esac
    else
      nsxiv -b -- "$Screenshot" &
    fi
  fi
}

cleanup()
{
  if [ "$Clipboardonly" = true ] && [ -f "$Screenshot" ]; then
    rm -- "$Screenshot"
  fi
}

print_error_message()
{
  printf \\n%s\\n "${0}: An error occurred." >&2
}

main "$@"
