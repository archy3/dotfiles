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
    '"Pcmanfm"') xdotool key --clearmodifiers -- "$1";;
  esac
}

main "$@"
