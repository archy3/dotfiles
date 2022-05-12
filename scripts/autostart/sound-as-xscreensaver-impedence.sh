#!/bin/sh

main()
{
  set -eu
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  defaulttime=235

  case "${1:-}" in
    (*[!0-9]*|'') time="$defaulttime";; ## $1 is not a positive integer
    (*)           time="$1";;           ## $1 is a positive integer
  esac

  ## If sound is playing, impede screensaver and test again in $time + 5
  ## seconds, else test again in 5 seconds. The sound is tested twice with
  ## a 15 second pause between the two tests so short sounds like
  ## notification beeps don't impede the screensavor.

  while sleep 5; do
    if sound_is_playing && sleep 15 && sound_is_playing; then
      xscreensaver-command -deactivate
      printf %s\\n "Sound is playing."
      sleep "$time"
    else
      printf %s\\n "Sound is not playing."
    fi
  done
}

sound_is_playing()
{
  awk -v exit_status="1" \
    '
      {
        if ($2 == "RUNNING") {
          exit_status="0"
          exit
        }
      }
      END {
        exit exit_status
      }
    ' /proc/asound/card*/pcm*/sub*/status
}

main "$@"
