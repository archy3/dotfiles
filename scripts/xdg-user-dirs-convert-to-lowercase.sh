#!/bin/sh

set -euf
trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

cat > ~/.config/user-dirs.dirs << 'EOF'
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run
# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
#
XDG_DESKTOP_DIR="$HOME/.desktop"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_TEMPLATES_DIR="$HOME/.templates"
XDG_PUBLICSHARE_DIR="$HOME/.public"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_VIDEOS_DIR="$HOME/videos"
EOF

set -- \
  'Desktop' '.desktop' \
  'Documents' 'documents' \
  'Downloads' 'downloads' \
  'Pictures' 'pictures' \
  'Public' '.public' \
  'Templates' '.templates' \
  'Music' 'music' \
  'Videos' 'videos'

until [ "$#" = '0' ]; do
  old="${HOME}/${1}"
  new="${HOME}/${2}"
  shift; shift

  if [ -e "$new" ]; then
    printf %s\\n "${new} already exists." >&2
    continue
  fi

  if [ -d "$old" ]; then
    mv -- "$old" "$new"
  elif ! [ -e "$old" ]; then
    mkdir -- "$new"
  else
    printf %s\\n "${old} is not a directory." >&2
  fi
done
