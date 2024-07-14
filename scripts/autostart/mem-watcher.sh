#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # Random positive int (no leading zeros)
  notification_id=$(
    < /dev/urandom tr -dc 123456789 | head -c 1
    < /dev/urandom tr -dc 0123456789 | head -c 8
  )

  mem_avail_percent_warning_threshold="${1:-15}"

  while true; do
    # shellcheck disable=SC2046
    set -- $(get_mem_info)
    mem_avail_percent="$1"
    mem_avail="${2}${3}"

    if [ "$mem_avail_percent" -le "$mem_avail_percent_warning_threshold" ]; then
      warn_low_mem "Low on RAM (${mem_avail} free)" "$notification_id"
    fi

    sleep 5
  done
}

warn_low_mem() # <warning message> <notification id>
{
  if command -v notify-send > /dev/null; then
    notify-send \
      --hint=int:transient:1 \
      --replace-id="$2" \
      --expire-time=10000 \
      --urgency=critical \
      -- "$1"
  fi

  printf %s\\n "$1"
}

# Output is "<mem available percent> <mem available> <mem available units>"
get_mem_info()
{
  awk \
  '
    function print_kb_int_in_human_readable_form(kb) {
      if (kb < 1000) {
        value = kb
        suffix = "KB"
      }
      else if (kb < 1024 * 1000) {
        value = kb / 1024
        suffix = "MB"
      }
      else {
        value = kb / 1024 / 1024
        suffix = "GB"
      }

      printf "%0.1f %s\n", value, suffix
    }

    {
      gsub(":", "", $1)
      meminfo[$1] = $2
    }

    END {
      mem_avail_percent = 100 * meminfo["MemAvailable"] / meminfo["MemTotal"]

      printf "%s ", int(mem_avail_percent)
      print_kb_int_in_human_readable_form(meminfo["MemAvailable"])
    }
  ' /proc/meminfo
}

main "$@"
