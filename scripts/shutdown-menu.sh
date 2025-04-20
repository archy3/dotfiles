#!/bin/sh

# Default dmenu settings for this script
dmenu()
{
  command -- dmenu -fn 'Monospace-13' "$@" #-sf '#000000' -sb '#dd0000'
}

print_options()
{
  set -- cancel poweroff reboot suspend logout

  # Check if booted in UEFI mode:
  if [ -d /sys/firmware/efi ]; then
    set -- "$@" firmware
  fi

  printf '%s\n' "$@"
}

main()
{
  set -euf

  selection="$(print_options | dmenu)"
  case "$selection" in
    firmware) proceed_if_no_other_users_logged_in reboot --firmware-setup -i;;
    poweroff|reboot) proceed_if_no_other_users_logged_in "$selection" -i;;
    suspend) xscreensaver-command -lock; systemctl suspend -i;;
    logout) openbox --exit;;
    *) return 0;;
  esac
}

proceed_if_no_other_users_logged_in() #<systemctrl_args...>
{
  if no_other_users_logged_in; then
    openbox --exit; systemctl "$@"
  else
    confirmation_msg="Other users are logged in. Proceed anyways?"
    are_you_sure="$(printf '%s\n' no yes | dmenu -p "$confirmation_msg")"
    case "$are_you_sure" in
      yes) openbox --exit; systemctl "$@";;
      *) return 0;;
    esac
  fi
}

no_other_users_logged_in()
{
  who -T | awk -v loggin_count=0 \
    '
      {
        if ($3 ~ "^tty[0-9]*$" && $2 ~ "^[?+-]$") {
          loggin_count++
        }
      }
      END {
        exit (loggin_count > 1 ? 1 : 0)
      }
    '
}

main
