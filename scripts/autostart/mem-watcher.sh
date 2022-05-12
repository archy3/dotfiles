#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  total_mem=$(free | awk '/Mem:/ {print $2}')
  low_mem=$((total_mem*15/100))
  very_low_mem=$((total_mem*10/100))
  critically_low_mem=$((total_mem*5/100))

  nl="
  "
  nl="${nl%%' '*}"; nl="${nl%%'	'*}"

  low_mem_msg="Low on RAM:${nl}Kill applications to free up RAM"
  very_low_mem_msg="Very low on RAM:${nl}Kill applications quickly to free up RAM"
  critically_low_mem_msg="CRITICALLY LOW ON RAM!!!${nl}KILL APPLICATIONS IMMEDIATELY!"

  while sleep 5; do
    available_mem=$(free | awk '/Mem:/ {print $7}')

    if [ "$available_mem" -lt "$critically_low_mem" ]; then
      warn_low_mem "$critically_low_mem_msg"
    elif [ "$available_mem" -lt "$very_low_mem" ]; then
      warn_low_mem "$very_low_mem_msg"
    elif [ "$available_mem" -lt "$low_mem" ]; then
      warn_low_mem "$low_mem_msg"
    fi
  done
}

warn_low_mem() ## warning_message
{
  if command -v notify-send > /dev/null; then
    notify-send \
      --hint=int:transient:1 \
      --expire-time=10000 \
      --urgency=critical \
      -- "$1"
  fi
  printf %s\\n "$1"
  sleep 10
}

main "$@"
