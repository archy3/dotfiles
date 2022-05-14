#!/bin/sh

# Sends alt+left_arrow/alt+right_arrow to certain applications that don't use
# mouse_forward/mouse_back. Useful to map to mouse_forward/mouse_back.

main() #<Left|Right>
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  case "${1:-}" in
    Left|Right) :;;
    *) return 1;;
  esac

  id="$(xdotool getactivewindow)"
  class="$(xprop -id "$id" WM_CLASS)"

  case "${class##*' '}" in
    '"Pcmanfm"'|'"Virt-manager"') xdotool key --clearmodifiers -- "alt+${1}";;
  esac
}

main "$@"
