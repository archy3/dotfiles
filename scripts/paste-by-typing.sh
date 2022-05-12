#!/bin/sh

# Emulates typing the contents of the clipboard. Useful for "pasting" into a VM.
# Depends on xclip and xdotool (and notify-send for notification)

set -euf
trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

selection="$(xclip -o -selection clipboard && printf %s X)"
selection="${selection%X}"

# Countdown:
for i in 5 4 3 2 1; do
  notify-send \
    --hint=int:transient:1 \
    --icon=edit-paste \
    --expire-time=1000 \
    -- "            ${i}" &
    sleep 1
done

xdotool type --clearmodifiers -- "$selection"
