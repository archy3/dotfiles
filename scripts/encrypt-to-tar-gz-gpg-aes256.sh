#!/bin/sh

# The description is printed if no error message is supplied.
usage() # [error message]
{
  if [ "$#" != 0 ]; then
    printf 'ERROR: %s\n' "$1" >&2
  else
    cat << 'EOF'
Archives a file or directory into a gpg AES256 encrypted tar.gz file.
Can also decrypt and extract such encrypted tar.gz archives.
This script currently only accepts a single file (or directory) as input.
EOF
  fi

  printf \\n

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

  if [ "$#" = 0 ] || [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ]; then
    usage
    return 0
  elif [ "$1" != '-e' ] && [ "$1" != '-d' ]; then
    usage "Bad option: ${1}"
    return 1
  elif [ "$#" = 1 ]; then
    usage 'Missing input operand.'
    return 1
  elif [ "$#" -gt 3 ]; then
    usage 'Too many arguments.'
    return 1
  fi

  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  mode="$1"
  input="${2%/}"
  output="${3:-}"

  case "$mode" in
    '-e') encrypt "$input" "${output:-"${input}.tar.gz.gpg"}";;
    '-d') decrypt "$input" "${output:-"."}";;
    *) usage "Bad option: ${mode}"; return 1;;
  esac
}

encrypt() # <input> <output>
{
  if ! { [ -f "$1" ] || [ -d "$1" ]; }; then
    printf '%s %s\n' \
      "ERROR: The input file ${1} does not exist" \
      'or is not a regular file or directory.' >&2
    return 1
  fi

  if [ -e "$2" ]; then
    printf %s\\n "ERROR: The output file ${2} already exist." >&2
    return 1
  fi

  # `--pinentry-mode loopback` asks for the password on the terminal.
  tar -cvzf - "$1" |
    gpg -c --cipher-algo AES256 --no-symkey-cache --pinentry-mode loopback \
    > "$2"
}

decrypt() # <input> <output>
{
  if ! [ -e "$1" ]; then
    printf %s\\n "ERROR: The input file ${1} does not exist." >&2
    return 1
  fi

  if ! [ -e "$2" ]; then
     mkdir -p -- "$2"
  fi

  if ! [ -d "$2" ]; then
    printf '%s %s\n' \
      "ERROR: The output destination ${2} already exists" \
      'but is not a directory.' >&2
    return 1
  fi

  # `--pinentry-mode loopback` asks for the password on the terminal.
  # `--keep-old-files` is to avoid accidentally overwriting existing files.
  gpg --pinentry-mode loopback -d "$1" | tar --keep-old-files -xvzf - -C "$2"
}

main "$@"
