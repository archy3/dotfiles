#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # udevadm command from https://unix.stackexchange.com/questions/458961/execute-script-on-external-keyboard-connection#comment883131_458961
  udevadm monitor -k | while IFS= read -r _; do
    setxkbmap -layout us -option '' -option compose:ralt
  done

  # The above loop should never end (if it does, it is an error)
  return 1
}

main "$@"
