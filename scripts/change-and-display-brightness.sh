#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

 # Arbitrary positive int:
  notification_id=339646120

  brightnessctl set "$1"

  brightness_max="$(brightnessctl max)"
  brightness_current="$(brightnessctl get)"

  notify-send \
    --hint=int:transient:1 \
    --replace-id="$notification_id" \
    --icon=weather-clear \
    --expire-time=2000 \
    -- " $((100 * brightness_current / brightness_max))%"
}

main "$@"
