#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  input=~/.themes/Mist-Alt/gtk-3.0/dev/gtk-contained-dark.css
  output=~/.themes/Mist-Alt/gtk-3.0/gtk.css

  #shellcheck disable=SC2046
  # Array of original colors:
  set -- $(
    < "$input" awk -v RS="#" -v FS="[^0-9a-fA-F]" -v hex="[0-9a-fA-F]" -- \
      '$1 ~ "^" hex hex hex hex hex hex "$" {printf "#%s\n", $1;}' |
      sort -u
  )

  tempfile="$(mktemp)"
  for color in "$@"; do
    printf '%s' "${color} "; print_random_color; printf '\n'
  done > "$tempfile"

  named_white_replacement=$(print_random_color)

  ~/.themes/Mist-Alt/gtk-3.0/dev/translate-gtk-contained-colors.sh \
    "$input" "$tempfile" "$output" "$named_white_replacement"

  rm -f -- "$tempfile"
}

print_random_color()
{
  printf '#'
  < /dev/urandom LC_ALL=C tr -dc -- '0-9a-f' | head -c 6
}

main "$@"
