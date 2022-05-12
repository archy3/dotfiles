#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT
  sleep_interval=$((60*30))
  message="       Get up and move!"

  while sleep "$sleep_interval"; do
    if ! xscreensaver_active; then
      send_notification "$message"
    fi
  done
}

send_notification()
{
  notify-send \
    --hint=int:transient:1 \
    --icon=system-log-out \
    --expire-time=120000 \
    -- "$1"
}

xscreensaver_active()
{
  command -v xscreensaver-command > /dev/null || return 1

  ## xscreensaver-command can sometimes return 255 with error
  ## "no saver status on root window."
  screen_saver_state="$(xscreensaver-command -time || true)"

  [ "${screen_saver_state#*' locked '}" != "$screen_saver_state" ] ||
    [ "${screen_saver_state#*' blanked '}" != "$screen_saver_state" ]
}

main "$@"
