#!/bin/sh
main()
{
  # From https://stackoverflow.com/a/2173421
  trap 'trap - TERM; kill -s TERM -- -"$$"' INT TERM QUIT EXIT

  spice-vdagent &

  output=$(xrandr | awk '/connected/ && ! /disconnected/ {print $1}')

  # From https://superuser.com/a/1565544
  # Running the below code in the background and waiting
  # allows this script to still respond to signals.
  xev -root -event randr | while read -r key value _; do
    if [ "${key:-} ${value:-}" = "subtype XRROutputChangeNotifyEvent" ]; then
      xrandr --output "$output" --auto
    fi
  done &
  wait "$!"
}

main "$@"
