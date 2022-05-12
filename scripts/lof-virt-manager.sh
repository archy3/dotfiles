#!/bin/sh

# Launch or focus script just for virt-manager because it likes
# to spawn other windows with the same arg list so the normal
# lof script can focus the wrong window sometimes.

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  virt_manager_wid=$(
    wmctrl -l | awk -v title='Virtual Machine Manager' '$0 ~ title {print $1}'
  )

  # if virt-manager is not running, start it
  # if virt-manager is running, focus it
  if [ -z "$virt_manager_wid" ]; then
    virt-manager -c qemu:///session &
  else
    wmctrl -iR "$virt_manager_wid"
  fi
}

main
