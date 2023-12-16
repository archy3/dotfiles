#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  if last_shutdown_was_clean; then
    printf %s\\n "Last shutdown appears clean."
  else
    msg="Last shutdown appears dirty"
    printf %s\\n "${msg}."
    notify-send --expire-time=10000 --urgency=critical -- "${msg}"
  fi
}

# See https://ww.reddit.com/r/ChrisTitusTech/comments/abtp56/easiest_way_to_check_last_shutdown_was_clean/ed38elw/
last_shutdown_was_clean()
{
  last -x |
    grep -e 'system boot' -e 'system down' |
    head -2 |
    grep -q 'system down'
}

main "$@"
