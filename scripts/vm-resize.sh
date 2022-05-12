#!/bin/sh
main()
{
  spice-vdagent &

  output=$(xrandr | awk '/connected/ && ! /disconnected/ {print $1}')

  wallpaper="${HOME}/downloads/deadly-wallpaper.jpg"
  readjust "$output" "$wallpaper"

  while sleep 1; do
    resolution_list="$(xrandr)"
    if [ "${resolution_list%'*+'*}" = "${resolution_list}" ]; then
      readjust "$output" "$wallpaper"
    fi
  done
}

# Just running this without checking first if the resolution list
# changed seems to actually be more efficient.
readjust() ## <output> <wallpaper>
{
  xrandr --output "$1" --auto
  xwallpaper --zoom "$2"
}

main "$@"
