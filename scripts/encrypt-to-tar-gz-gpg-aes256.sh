#!/bin/sh

usage()
{
  [ "${1:-}" = "error" ] && cat << EOF
An error occured.
EOF

  [ "${1:-}" != "error" ] && cat << EOF
Archives a file or directory into a gpg AES256 encrypted tar.gz file.
Can also decrypt and extract such encrypted tar.gz archives.
This script currently only accepts a single file (or directory) as input.
EOF

  printf %s\\n ''

  cat << EOF
Usage:
${0##*/} -e <file_to_encrypt> [output_file]
    The <file_to_encrypt> may be a directory as well.
    [output_file] will be file_to_encrypt.tar.gz.gpg if omitted.

${0##*/} -d <tar.gz_archive_to_decrypt> [output_directory]
    [output_directory] will be the current working directory if omitted.
EOF
}

main()
{
  set -euf

  # See https://github.com/keybase/keybase-issues/issues/2798 for why this
  # is needed:
  GPG_TTY="$(tty)"
  export GPG_TTY

  if [ "$#" != 2 ] && [ "$#" != 3 ]; then
    usage
    return 1
  fi

  mode="$1"
  input="${2%/}"
  output="${3:-}"

  case "$mode" in
    '-e') encrypt "$input" "${output:-"${input}.tar.gz.gpg"}";;
    '-d') decrypt "$input" "${output:-"."}";;
    *) usage "error"; return 1;;
  esac
}

encrypt() # <input> <output>
{
  { [ -f "$1" ] || [ -d "$1" ]; } || return 1
  [ -e "$2" ] && return 1

  tar -cvzf - "$1" | gpg -c --cipher-algo AES256 --no-symkey-cache > "$2"
}

decrypt() # <input> <output>
{
  [ -e "$1" ] || return 1
  [ -e "$2" ] || mkdir -p -- "$2"
  [ -d "$2" ] || return 1

  gpg -d "$1" | tar -xvzf - -C "$2"
}

check_files() # <input> <output>
{
  if ! { [ -f "$1" ] || [ -d "$1" ]; }; then
    printf %s\\n \
      "The input file does not exist or is not a regular file or directory"
    return 1
  fi

  if [ -e "$2" ]; then
    printf %s\\n "The output file already exist"
    return 1
  fi
}

main "$@"
