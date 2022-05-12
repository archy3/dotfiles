#!/bin/sh

# Centers new windows around the mouse cursor.
# Tested on JWM with a single monitor.

# Dependencies beyond POSIX:
# xdotool
# xprop
# xdpyinfo (if monitor resolution is not set manually)
# a compatible X11 window manager

# Usage:
# Set the global variables and have the script run in the background.
# The script does not take any arguments.


# GLOBAL VARIABLES:

# Set monitor resolution:
res_w="$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $3}')"
res_h="$(xdpyinfo | awk -F'[ x]+' '/dimensions:/{print $4}')"

# Window decoration sizes.
# You can get this by running 'xprop _NET_FRAME_EXTENTS' and then
# selecting a decorated window. The output is:
# '_NET_FRAME_EXTENTS(CARDINAL) = <left>, <right>, <top>, <bottom>'
win_dec_left=4
win_dec_right=4
win_dec_top=27
win_dec_bottom=4

# Panel height. Height should be '0' if the panel is not used.
panel_at_top_height=24
panel_at_bottom_height=0


main()
{
  window_list_old="$(xprop -root _NET_CLIENT_LIST)"

  xprop -root -spy _NET_CLIENT_LIST | while IFS= read -r window_list; do
    window_most_recent="0x${window_list##*'0x'}"

    # Check if the old window list contains the most recent window:
    case "$window_list_old" in
      *"${window_most_recent}"*) :;; # Not a new window. Do nothing.
      *) center_around_cursor "$window_most_recent";; # New window. Center it.
    esac

    window_list_old="$window_list"
  done
}

center_around_cursor() # <window_id>
{
  win_id="$1"

  # Word splitting is intentional here:
  # shellcheck disable=SC2046
  set -- $(xdotool getmouselocation --shell getwindowgeometry --shell "$win_id")

  mouse_x="${1#*=}"
  mouse_y="${2#*=}"
  win_w="${8#*=}"
  win_h="${9#*=}"

  # Make window width and height include decorations:
  win_w="$((win_w + win_dec_left + win_dec_right))"
  win_h="$((win_h + win_dec_top + win_dec_bottom))"

  win_x="$((mouse_x - win_w/2))"
  win_y="$((mouse_y - win_h/2))"

  if [ "$win_x" -lt "0" ]; then
    win_x=0
  elif [ "$((win_x + win_w))" -gt "$res_w" ]; then
    win_x="$((res_w - win_w))"
  fi

  if [ "$win_y" -lt "$panel_at_top_height" ]; then
    win_y="$panel_at_top_height"
  elif [ "$((win_y + win_h))" -gt "$((res_h - panel_at_bottom_height))" ]; then
    win_y="$((res_h - panel_at_bottom_height - win_h))"
  fi

  xdotool windowmove -- "$win_id" "$win_x" "$win_y"
}

main
