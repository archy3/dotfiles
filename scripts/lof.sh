#!/bin/sh

# From:
# https://www.youtube.com/watch?v=AK2UKUfsV3g
# https://github.com/octetz/linux-desktop/blob/master/s/lof

# lof: launch or focus
# this script checks whether an app is running and
# if running, focuses the window
# if not running, launches the app

# usage: <this_script> program [arg to program]...
# Providing the full path to the program will help protect against collisions.

# Dependencies: wmctrl

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  app_name="$*"

  # find pid for app process
  # -f includes the entire process details, including arguments and flags
  #app_pid="$(pgrep -U "$USER" -f "^${app_name}$" || true)"
  app_pid="$(pgrep -U "$USER" -xf "$app_name" || true)"

  # if app is not running, start it
  # if app is running, focus it
  if [ -z "$app_pid" ]; then
    # launch app
    "$@" &
  else
    # using the pid, find the window id, then focus it
    wid=$(wmctrl -lp | awk -v app_pid="$app_pid" '$0 ~ app_pid {print $1}')
    # -R moves the window to the current desktop AND brings it to focus
    wmctrl -iR "$wid"
  fi
}

main "$@"
