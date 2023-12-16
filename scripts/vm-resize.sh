#!/bin/sh
main()
{
  # From https://stackoverflow.com/a/2173421
  trap 'trap - TERM; kill -s TERM -- -"$$"' INT TERM QUIT EXIT

  spice-vdagent &

  output=$(xrandr | awk '/connected/ && ! /disconnected/ {print $1}')

  # From https://superuser.com/a/1565544
  # Running the below code in the background and waiting
  # allows this script to still response to signals.
  xev -root -event randr |
    grep --line-buffered 'subtype XRROutputChangeNotifyEvent' |
      while read -r pointlessvar; do
        xrandr --output "$output" --auto
      done &
  wait "$!"
}

main "$@"
