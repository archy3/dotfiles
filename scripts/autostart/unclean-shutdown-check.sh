#!/bin/sh

# See https://ww.reddit.com/r/ChrisTitusTech/comments/abtp56/easiest_way_to_check_last_shutdown_was_clean/ed38elw/
main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # If this value is 2, then that means there was
  # no (proper) shutdown between the last two bootups:
  number_of_bootups_in_last_two_shutdown_or_bootup_events=$(
    last -x |
      awk '($1=="reboot" && $2=="system" && $3=="boot") || ($1=="shutdown" && $2=="system" && $3=="down")' |
      head -2 |
      { grep -c -e '^reboot[[:blank:]][[:blank:]]*system boot' || true; }
  )

  case "$number_of_bootups_in_last_two_shutdown_or_bootup_events" in
    2) notify "Last shutdown appears dirty";;
    *) printf %s\\n "Last shutdown appears clean.";;
  esac
}

notify()
{
  printf %s\\n "${1}."
  notify-send --expire-time=10000 --urgency=critical -- "${1}"
}

main "$@"
