#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # The input file can be retrieved from
  # https://gitlab.gnome.org/GNOME/gtk/-/blob/3.24.48/gtk/theme/Adwaita/gtk-contained-dark.css
  #
  # The translation table consists of two (space-separated) columns,
  # the first of which can be be generated with
  # ```
  #   < gtk-contained-dark.css awk \
  #     -v RS="#" -v FS="[^0-9a-fA-F]" -v hex="[0-9a-fA-F]" -- \
  #     '$1 ~ "^" hex hex hex hex hex hex "$" {printf "#%s\n", $1;}' |
  #     sort -u
  # ```
  dir_of_this_theme=~/.themes/Mist-Alt/gtk-3.0
  input="${1:-"${dir_of_this_theme}/dev/gtk-contained-dark.css"}"
  translation_table="${2:-"${dir_of_this_theme}/dev/color-translation-table"}"
  output="${3:-"${dir_of_this_theme}/gtk.css"}"
  named_white_replacement="${4:-"#cccccc"}"
  visited_link_color="${5:-"#ff8000"}"

  for file in "$translation_table" "$input" "$output"; do
    if ! [ -f "$file" ]; then
      printf '%s %s\n' \
        "File $file either does not exist" \
        'or is not a regular (non-directory) file' >&2
      return 1
    fi
  done

  #shellcheck disable=SC2016
  awk_script='
    BEGIN {
      hex = "[0-9a-fA-F]"
      color_regex_pattern = "#" hex hex hex hex hex hex
      print "!/" color_regex_pattern "/ {print; next;}"

      print "{"
      print "  for (i=1; i <= NF; i++) {"
    }

    NF != 2 {
      next
    }

    tolower($1) == tolower($2) {
      next
    }

    ($1 !~ "^" color_regex_pattern "$") || ($2 !~ "^" color_regex_pattern "$") {
      next
    }

    {
      print "    if ($i ~ /" $1 "/) {"
      print "      sub(/" $1 "/, \"" $2 "\", $i); continue;"
      print "    }"
    }

    END {
      print "  }"
      print "  print;"
      print "}"
    }
  '

  export LC_ALL=C
  awk -- "$awk_script" "$translation_table" | awk -f - -- "$input" |
    replace_named_white "$named_white_replacement" |
    remove_assets |
    compactify --true |
    set_visited_link_color "$visited_link_color" |
    add_widget_overrides |
    add_application_overrides \
    > "$output"
}

replace_named_white()
{
  sed "s/color: white/color: ${1}/g"
}

# Without this, all the assets (such as checkboxes) will appear solid red.
remove_assets()
{
  printf '%s\n\n' '@import url("resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css");'

  grep -v assets
}

compactify() # <--true|--false>
{
  if [ "${1:-}" = '--false' ]; then
    cat
  else
    # From https://gitlab.gnome.org/GNOME/gtk/blob/gtk-3-24/gtk/theme/Adwaita/_common.scss#L14
    sed \
      -e 's/: 46px;/: 40px;/g' \
      -e 's/: 32px;/: 28px;/g' \
      -e 's/: 10px;/: 7px;/g' \
      -e 's/: 6px;/: 5px;/g' \
      -e 's/: 5px;/: 2px;/g' \
      -e 's/: 4px;/: 2px;/g' \
      -e 's/: 6px 10px;/: 4px 10px;/g' \
      -e 's/: 4px 9px;/: 2px 6px;/g'
  fi
}

set_visited_link_color() # visited_link_color
{
  cat
  printf '\n\n/* Set visited link color: */\nlink:visited {color: %s;}\n' "$1"
}

add_widget_overrides()
{
  cat
  printf '\n%s\n' '/* Widget overrides: */'
  printf "@import url('widgets/%s');\n" \
    general-and-misc.css \
    scale-progressbar-levelbar.css \
    check-radio-switch.css \
    scrollbar.css \
    notebook.css
}

add_application_overrides()
{
  cat
  printf '\n%s\n' '/* Application overrides: */'
  printf "@import url('applications/%s');\n" \
    lxpanel.css \
    xfce4-panel.css \
    pcmanfm.css \
    firefox.css
}

main "$@"
