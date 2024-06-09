#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  if [ "$(xset q | awk '/Num Lock:/ {print $8}')" = "off" ]; then
    xdotool key --clearmodifiers -- Num_Lock
  fi
}

main "$@"
