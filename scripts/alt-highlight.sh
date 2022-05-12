#!/bin/sh

# Takes files or stdin and prints the contents
# while highlighting every other line.

main()
{
  set -euf

  # Restore terminal to default settings if user cancels program.
  trap "tput sgr0" INT TERM
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  ## Safeguard against inheriting bad variables
  unset -v color_a color_b color_opt no_alt_after_blank_line

  ## Parse arguments
  until [ "$#" = "0" ]; do case "$1" in
    '--') shift; break;;
    '-n'|'--no-alt-on-blank') no_alt_after_blank_line=1; shift;;
    '-c'|'--color') color_opt="${2:-}"; shift; [ -n "${1:-}" ] && shift;;
    '-h'|'--help') usage; return 0;;
    *) break;;
  esac; done

  # Set the global variables "$color_a" and "$color_b"
  set_colors "${color_opt-"0,7,7,0"}"

  # Check if files in "$@" exist. Returns success also when "$#" is zero.
  for file in "$@"; do
    if ! [ -f "$file" ]; then
      printf %s\\n "${1} is not a regular file or does not exist." >&2
      return 1
    fi
  done

  alt_highlight "$@"
}

alt_highlight() # [FILE...]
{
  awk \
    -v color_odd="$color_a" \
    -v color_even="$color_b" \
    -v no_alt_after_blank_line="${no_alt_after_blank_line:-0}" \
    '
      BEGIN {
        parity = 1
        line_fmt[1] = color_odd "%s" "\033[K" "\033[0m" "\n"
        line_fmt[0] = color_even "%s" "\033[K" "\033[0m" "\n"
      }

      {
        # dos2unix:
        gsub("\r", "")

        printf line_fmt[parity], $0

        if ((! no_alt_after_blank_line) || (NF != 0)) {
          parity = ! parity
        }
      }

      END {
        printf "\033[0m\033[K"
      }
    ' \
    "$@"
}

### Set the global variables "$color_a" and "$color_b"
set_colors() # <fg_a[fmt_opt_a...],bg_a[,fg_b[fmt_opt_b...],bg_b]>
{
  ### Returns formatting options as "$retval"
  parse_special_formatting_options() # <special_format_options>
  {
    retval=""

    if [ -z "$1" ]; then
      return 0
    fi

    set -- "-${1}"

    while getopts :bfiuBrcs opt; do
      case "$opt" in
        b) retval="${retval}1;";;
        f) retval="${retval}2;";;
        i) retval="${retval}3;";;
        u) retval="${retval}4;";;
        B) retval="${retval}5;";;
        r) retval="${retval}7;";;
        c) retval="${retval}8;";;
        s) retval="${retval}9;";;
        :|?) printf %s\\n "Invalid formatting option." >&2; return 1;;
      esac
    done
  }

  IFS=','
  # shellcheck disable=SC2086
  set -- ${1:-}
  unset -v IFS

  if [ "$#" = "2" ]; then
    set -- "$1" "$2" 7 0
  elif [ "$#" != "4" ]; then
    printf %s\\n "Invalid color choice." >&2
    return 1
  fi

  fg_a="${1#?}"; fg_a="${1%"${fg_a}"}"
  fmt_opt_a="${1#"${fg_a}"}"
  bg_a="$2"

  fg_b="${3#?}"; fg_b="${3%"${fg_b}"}"
  fmt_opt_b="${3#"${fg_b}"}"
  bg_b="$4"

  for color in "$fg_a" "$bg_a" "$fg_b" "$bg_b"; do
    case "$color" in
      [0-7]) continue;;
      *) printf %s\\n "Invalid color choice." >&2; return 1;;
    esac
  done

  parse_special_formatting_options "$fmt_opt_a"; format_a="$retval"
  parse_special_formatting_options "$fmt_opt_b"; format_b="$retval"

  color_a="\\033[${format_a}3${fg_a};4${bg_a}m"
  color_b="\\033[${format_b}3${fg_b};4${bg_b}m"
}

usage()
{
  cat << EOF
Usage: ${0} [OPTION]... [FILE]...

Prints the contents of a file or standard input
while highlighting every other line.

  Options:
  --                     do not interpret any subsequent arguments as options
  -c, --color <n[x...],m[,u[y...],v]>  set colors, see examples section
  -n, --no-alt-on-blank  useful when both background colors are the same
  -h, --help             display this help and exit

  Format codes:
  b: bold
  f: faint
  i: italic
  u: underline
  B: blink
  r: reverse
  c: conceal
  s: srike

  Color codes:
  0: black
  1: red
  2: green
  3: yellow
  4: blue
  5: magenta
  6: cyan
  7: white

  Appending format codes to the foreground color will apply that format.

  Examples:
  "${0} --color 1bu,4,6,0 foo.txt" will print odd lines of
  foo.txt with bright red underlined text on a blue background and even
  lines with cyan text on a black background.
EOF
}

main "$@"
