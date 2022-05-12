#!/bin/sh
# Compatible with ranger 1.6.0 through 1.7.*
#
# This script searches image files in a directory, opens them all with sxiv and
# sets the first argument to the first image displayed by sxiv.
#
# This is supposed to be used in rifle.conf as a workaround for the fact that
# sxiv takes no file name arguments for the first image, just the number.  Copy
# this file somewhere into your $PATH and add this at the top of rifle.conf:
#
#   mime ^image, has sxiv, X, flag f = path/to/this/script -- "$@"
#
# Implementation notes: this script is quite slow because of POSIX limitations
# and portability concerns. First calling the shell function 'abspath' is
# quicker than calling 'realpath' because it would fork a whole process, which
# is slow. Second, we need to append a file list to sxiv, which can only be done
# properly in two ways: arrays (which are not POSIX) or \0 sperated
# strings. Unfortunately, assigning \0 to a variable is not POSIX either (will
# not work in dash and others), so we cannot store the result of listfiles to a
# variable.

# NOTES:
# This is like rifle_sxiv.sh but changes first to the directory of the 1st
# argument so it can use short relative pathnames instead of long absolute
# pathnames as long absolute pathnames can make "$@" larger than what the
# OS allows when in a directory of many files.
# When more than 1 argument is given, this just launches sixv with those
# arguments.

if [ $# -eq 0 ]; then
    echo "Usage: ${0##*/} PICTURES"
    exit
fi

[ "$1" = '--' ] && shift

if [ "$#" != "1" ] || [ -d "$1" ]; then
    sxiv -ab -- "$@" &
    exit
fi

selected_img="$1"
case "$selected_img" in
  /*) dir="${selected_img%/*}";;
  *)  dir="$PWD";;
esac
selected_img="${selected_img##*/}"

cd -- "$dir" || exit 1

listfiles () {
    find -L . -maxdepth 1 -type f -iregex \
      '.*\(jpe?g\|bmp\|png\|gif\|tga\)$' -print0 | sort -z
}

count="$(listfiles | grep -m 1 -ZznF "./${selected_img}" | cut -d: -f1)"

if [ -n "$count" ]; then
    listfiles | xargs -0 sxiv -ab -n "$count" -- &
else
    cd - || exit 1
    sxiv -ab -- "$@" & # fallback
fi
