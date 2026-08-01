#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  dir_of_this_theme=~/.themes/Mist-Alt
  input="${dir_of_this_theme}/build-scripts/gtk-contained-dark.css"
  output="${dir_of_this_theme}/gtk-3.0/gtk.css"
  color_translation_script="${dir_of_this_theme}/build-scripts/translate-gtk-contained-colors.sh"

  for file in "$input" "$output" "$color_translation_script"; do
    if ! [ -f "$file" ]; then
      printf '%s %s\n' \
        "File $file either does not exist" \
        'or is not a regular (non-directory) file' >&2
      return 1
    fi
  done

  if ! [ -x "$color_translation_script" ]; then
    printf '%s\n' "File $color_translation_script is not executable." >&2
    return 1
  fi

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
  visited_link_color=$(print_random_color)

  "$color_translation_script" \
    "$input" "$tempfile" "$output" \
    "$named_white_replacement" "$visited_link_color"

  rm -f -- "$tempfile"
}

print_random_color()
{
  printf '#'
  < /dev/urandom LC_ALL=C tr -dc -- '0-9a-f' | head -c 6
}

main "$@"
