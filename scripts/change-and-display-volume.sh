#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

 # Arbitrary positive int:
  notification_id=620371800

  amixer -q -D pulse sset Master "$1"

  current_vol=$(
    amixer -D pulse get Master |
      awk '$1 == "Front" && $2 == "Right:" {print $5}'
  )
  current_vol="${current_vol%']'}"
  current_vol="${current_vol#'['}"

  notify-send \
    --hint=int:transient:1 \
    --replace-id="$notification_id" \
    --icon=audio-volume-high \
    --expire-time=2000 \
    -- " ${current_vol}"
}

main "$@"
