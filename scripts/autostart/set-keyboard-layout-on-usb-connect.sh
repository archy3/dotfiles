#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  set_keyboard_layout

  if [ "${1:-}" = '--set-layout-now-and-exit' ]; then
    return 0
  fi

  # udevadm command from https://unix.stackexchange.com/questions/458961/execute-script-on-external-keyboard-connection#comment883131_458961
  # (we want the line to be word-split, so no `IFS= ` before `read`)
  udevadm monitor -k -s hidraw | while read -r _ _event_type __ ___; do
    case "${_event_type:-}" in
      add) set_keyboard_layout;;
    esac
  done

  # The above loop should never end (if it does, it is an error)
  return 1
}

set_keyboard_layout()
{
  # Make right alt the compose key.
  setxkbmap -layout us -option '' -option compose:ralt

  # Replace right super with right hyper by using an XKB symbols file.
  xkb_symbols_file=~/.config/xkb/symbols/hyper
  if [ -f "$xkb_symbols_file" ]; then
    # sed command from: https://askubuntu.com/a/794087
    apply_to_these_lines='^[[:space:]]*xkb_symbols[[:space:]]*{'
    find='"[[:space:]]*};$'
    replace='+hyper(rwin)&'
    setxkbmap -print |
      sed "/${apply_to_these_lines}/s/${find}/${replace}/" |
      xkbcomp -I"${xkb_symbols_file%/*/*}" - "${DISPLAY}"
  else
    printf '%s not found\n' "$xkb_symbols_file" >&2
  fi
}

main "$@"
