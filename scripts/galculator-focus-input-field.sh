#!/bin/sh

main() # [key-to-release...]
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  galculator &

  galculator_pid="$!"
  current_time="$(date +%s)"
  start_time="$current_time"

  # Note that POSIX (2024) arithmetic expansion only requires signed 32-bit
  # arithmetic, so after 2038, subtracting the two times could be problematic.
  while [ $((current_time-start_time)) -lt 2 ]; do
    active_window_id="$(xprop -root _NET_ACTIVE_WINDOW)"
    active_window_id="${active_window_id##*' '}"
    active_window_pid="$(xprop -id "$active_window_id" _NET_WM_PID)"
    active_window_pid="${active_window_pid##*' '}"

    if [ "$galculator_pid" = "$active_window_pid" ]; then
      release_keys "$@"
      xdotool key --clearmodifiers -- ctrl+f Tab Tab Tab Tab
      break
    else
      current_time="$(date +%s)"
    fi
  done
}

release_keys() # [key-to-release...]
{
  if [ "$#" -gt 0 ]; then
    xdotool keyup -- "$@"
  fi
}

main "$@"
