#!/bin/sh

# Sends XF86Back/XF86Forward to certain applications that don't use
# mouse_forward/mouse_back. Useful to map to mouse_forward/mouse_back.

main() #<Left|Right>
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  case "${1:-}" in
    XF86Back|XF86Forward) :;;
    *) return 1;;
  esac

  id="$(xdotool getactivewindow)"
  class="$(xprop -id "$id" WM_CLASS)"

  case "${class##*' '}" in
    '"Pcmanfm"') run_if_on_debian_12_or_less "$@";;
  esac
}

# gtk3 pcmanfm (debian 13 and later) does not need this workaround:
run_if_on_debian_12_or_less()
{
  case "$(awk -F . -- '{print $1}' /etc/debian_version)" in
    [5-9]|1[0-2]) xdotool key --clearmodifiers -- "$1";;
  esac
}

main "$@"
