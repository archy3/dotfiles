#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  set_keyboard_layout

  # udevadm command from https://unix.stackexchange.com/questions/458961/execute-script-on-external-keyboard-connection#comment883131_458961
  # (we want the line to be word-split, so no `IFS= ` before `read`)
  udevadm monitor -k -s hidraw | while read -r _ _event_type __ ___; do
    case "${_event_type:-}" in
      add|remove) set_keyboard_layout;;
    esac
  done

  # The above loop should never end (if it does, it is an error)
  return 1
}

set_keyboard_layout()
{
  # Replace right super with right hyper,
  # and make right alt the compose key.
  # (from https://wiki.archlinux.org/title/Xmodmap#Turn_Super_R_into_Hyper_R):
  xmodmap \
    -e 'remove  mod4 = Super_R' \
    -e 'keycode  134 = Hyper_R' \
    -e 'add     mod3 = Hyper_R' \
    -e 'remove  mod4 = Hyper_L' \
    -e 'add     mod3 = Hyper_L' \
    -e 'keycode  206 = NoSymbol  Super_R   NoSymbol  Super_R' \
    -e 'keycode  108 = Multi_key Multi_key Multi_key Multi_key'

  # When the above xmodmap command is called repeatedly with
  # no time between calls, sometimes the keymap reverts to the default.
  # This short sleep is an inelegant way to combat that.
  sleep 1
}

main "$@"
