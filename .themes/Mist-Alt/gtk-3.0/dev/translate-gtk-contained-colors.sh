#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # The input file can be retrieved from
  # https://gitlab.gnome.org/GNOME/gtk/-/blob/3.24.48/gtk/theme/Adwaita/gtk-contained-dark.css?ref_type=tags
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

  for file in "$translation_table" "$input" "$output"; do
    if ! [ -f "$file" ]; then
      printf '%s %s\n' \
        "File $file either does not exist" \
        "or is not a regular (non-directory) file" >&2
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
    replace_named_white "$named_white_replacement" | remove_assets |
    add_additions > "$output"
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

add_additions()
{
  cat
  printf \\n
  cat << 'EOF'
/* Colorscheme for lxpanel taskbar buttons: */
window#PanelToplevel box box#taskbar widget button.toggle {
    color: shade(@theme_fg_color, 1.10);
    background-image: none;
    background-color: shade(@theme_base_color, 1.02);
}

window#PanelToplevel box box#taskbar widget button.toggle:checked {
    color: shade(@theme_selected_fg_color, 0.90);
    background-image: none;
    background-color: shade(@theme_bg_color, 1.85);
}

window#PanelToplevel box box#taskbar widget button.toggle:hover {
    color: @theme_selected_fg_color;
    background-image: none;
    background-color: @theme_base_color;
}

/* Colorscheme for the lxpanel pager:
       `color:` is the border around windows.
       `background-color` is the color of the window in the pager,
       and a darker shade of it is used for the background
       (and a ligher shade of it is used for the color of the
       active window).
*/
window#PanelToplevel box widget#pager widget wnck-pager.wnck-pager {
    color: @theme_bg_color;
    background-color: shade(@theme_base_color, 3.0);
}

window#PanelToplevel box widget#pager widget wnck-pager.wnck-pager:selected {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}

window#PanelToplevel box widget#pager widget wnck-pager.wnck-pager:hover {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}
EOF
}

compactify()
{
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
}

main "$@"
