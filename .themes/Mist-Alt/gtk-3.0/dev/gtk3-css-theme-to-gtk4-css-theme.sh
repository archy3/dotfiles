#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != 0 ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  dir_of_this_theme=~/.themes/Mist-Alt
  input="${1:-"${dir_of_this_theme}/gtk-3.0/gtk.css"}"
  output="${2:-"${dir_of_this_theme}/gtk-4.0/gtk.css"}"

  < "$input" \
    replace_gtk3_url_with_gtk4_url |
    remove_single_line_universal_selectors |
    remove_removed_properties |
    remove_removed_functions |
    add_additions \
    > "$output"
}

replace_gtk3_url_with_gtk4_url()
{
  set -- \
    resource:///org/gtk/libgtk/theme/Adwaita/gtk-contained-dark.css \
    resource:///org/gtk/libgtk/theme/Default/Default-dark.css

  sed "s|${1}|${2}|g"
}

# Remove lines like `* {padding: 0;}`
remove_single_line_universal_selectors()
{
  sed 's/^[[:blank:]]*[*][[:blank:]]*{.*}[[:blank:]]*$//g'
}

# Remove properties that start with a dash, like
# "-gtk-outline-radius",
# "-GtkScrollbar-has-backward-stepper:",
# "-XfceTasklist-min-button-length:",
# etc.
remove_removed_properties()
{
  remove_declaration_from_declaration_blocks '-[-a-zA-Z]*:[^;]*;'
}

# Remove declarations that contain functions that start with "-gtk-",
# like "-gtk-gradient()" and "-gtk-icontheme()".
# (here, for simplicity, we assume a space immediately precedes the function).
remove_removed_functions()
{
  remove_declaration_from_declaration_blocks \
    '[-a-zA-Z][-a-zA-Z]*:[^;]*[[:blank:]]-gtk-[-a-zA-Z]*[(][^;]*;'
}

# The <pattern> must include the terminating ';'.
remove_declaration_from_declaration_blocks() # <pattern>
{
  # `sed -e ':L' -e 's/old/new/' -e 'tL'` creates a label `L`,
  # executes the command `s/old/new/`, and `tL` loops back to the label `L`
  # if the command `s/old/new/` was successful (i.e. a substitution took place).
  # This is different than `sed -e 's/old/new/g'` because sed will restart at
  # the beginning of the line after each substitution, allowing the previous
  # replacement text to be included in the pattern match for the next
  # `s/old/new/` operation.
  sed \
    -e ':LOOP' -e "s/;[[:blank:]]*${1}/;/" -e 'tLOOP' \
    -e "s/{[[:blank:]]*${1}/{/g" \
    -e "s/^[[:blank:]]*${1}//g"
}

add_additions()
{
  cat
  printf '\n\n/* BEGIN GTK4-SPECIFIC SETTINGS: */\n\n'
  printf "@import url('%s');\n" gtk4-specific.css
}

main "$@"
