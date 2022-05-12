#!/bin/sh

# Prints the contents of a file or standard input in the specified color.

main() # [format...] <foreground color code> <background color code> [FILE...]
{
  set -euf

  # Restore terminal to default settings if user cancels program.
  trap "tput sgr0" INT TERM
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  case "${1:-}" in
    '-h'|'--help') usage; return 0;;
  esac

  format=""

  while [ "$#" != 0 ]; do
    case "$1" in
      bold|b) format="${format}1;";;
      faint|f) format="${format}2;";;
      italic|i) format="${format}3;";;
      underline|u) format="${format}4;";;
      blink|B) format="${format}5;";;
      reverse|r) format="${format}7;";;
      conceal|c) format="${format}8;";;
      strike|s) format="${format}9;";;
      *) break;;
    esac
    shift
  done

  if [ -z "${1:-}" ] || [ -z "${2:-}" ]; then
    printf %s\\n "Must specify two color codes." >&2
    return 1
  fi

  case "${1}${2}" in
    [0-7][0-7]) fg="3${1}"; bg="4${2}"; shift; shift;;
    *) printf %s\\n "Invalid color choice." >&2; return 1;;
  esac

  # Check if files in "$@" exist. Returns success also when "$#" is zero.
  for file in "$@"; do
    if ! [ -f "$file" ]; then
      printf %s\\n "${1} is not a regular file or does not exist." >&2
      return 1
    fi
  done

  # Turn on colored text
  printf "\\033[${format}${fg};${bg}m"

  # Print file contents or stdin:
  cat -- "$@"

  # Turn off colored text and clear the current line from the cursor to the end.
  printf '\033[0m\033[K'
}

usage()
{
  cat << EOF
Usage: ${0} [format...] <foreground color code> <background color code> [FILE...]

Prints the contents of a file or standard input
in the specified color.

  Options:
  -h, --help               display this help and exit

  Format options:
  b|bold
  f|faint
  i|italic
  u|underline
  B|blink
  r|reverse
  c|conceal
  s|srike

  Color codes:
  0: black
  1: red
  2: green
  3: yellow
  4: blue
  5: magenta
  6: cyan
  7: white

  Example:
  "${0} bold u 1 4 foo.txt" will print the contents of
  foo.txt with bold underlined red text on a blue background.

  As the two colors codes are mandatory, the '--' option is
  not supported as it will never be ambiguous whether an
  argument is an option or a file.
EOF
}

main "$@"
