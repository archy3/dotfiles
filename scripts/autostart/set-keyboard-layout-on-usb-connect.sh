#!/bin/sh

main() # [--additional-initial-runs=<number>] [--set-layout-now-and-exit] [--notify]
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  additional_runs=0
  set_layout_now_and_exit=false
  notify=false

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --set-layout-now-and-exit) set_layout_now_and_exit=true;;
      --additional-initial-runs=*) additional_runs="${1#*=}";;
      --notify) notify=true;;
      *) printf '%s\n' "main(): Invalid argument: ${1}" >&2
    esac
    shift
  done

  set_keyboard_layout --additional-runs="$additional_runs" --notify="$notify"

  if [ "$set_layout_now_and_exit" = true ]; then
    return 0
  fi

  # udevadm command from https://unix.stackexchange.com/questions/458961/execute-script-on-external-keyboard-connection#comment883131_458961
  # (we want the line to be word-split, so no `IFS= ` before `read`)
  udevadm monitor -k -s hidraw | while read -r _ _event_type __ ___; do
    case "${_event_type:-}" in
      add) set_keyboard_layout --notify="$notify";;
    esac
  done

  # The above loop should never end (if it does, it is an error)
  return 1
}

set_keyboard_layout() # [--additional-runs=<number>] [--notify=<true|false>]
(
  additional_runs=0
  notify=false

  while [ "$#" -gt 0 ]; do
    case "$1" in
      --additional-runs=*) additional_runs="${1#*=}";;
      --notify=*) notify="${1#*=}";;
      *) printf '%s\n' "set_keyboard_layout(): Invalid argument: ${1}" >&2
    esac
    shift
  done

  # When X11 has just started (and especially when X11 has just started
  # immediately after a system boot), sometimes the new keyboard settings get
  # (partially or completely) ignored. To combat this, we have an option to
  # repeatedly apply the new settings a given number of times (the more times
  # applied, the more likely the settings will actually take effect).
  # `--additional-runs=4` yields reliable results on my system. The root cause
  # behind the settings not (always) working initially is probably a timing
  # issue/race condition.
  run_additional_runs "$additional_runs"

  # Make right alt the compose key.
  setxkbmap -layout us -option '' -option compose:ralt

  # Make right win the right hyper key.
  make_right_super_send_right_hyper

  if [ "$notify" = true ]; then
    send_notification
  fi
)

make_right_super_send_right_hyper()
(
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
)

run_additional_runs() # <number-of-additional-runs>
(
  additional_runs="$1"
  while [ "$additional_runs" -gt 0 ]; do
    set_keyboard_layout
    additional_runs=$((additional_runs-1))
  done

)

send_notification()
{
  if command -v notify-send > /dev/null; then
    notify-send --icon=input-keyboard -- 'Keyboard layout set'
  fi
  printf 'Keyboard layout set\n'
}

main "$@"
