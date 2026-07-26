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
    replace_named_white "$named_white_replacement" | remove_assets |
    compactify --true | add_additions "$visited_link_color" > "$output"
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

add_additions() # visited_link_color
{
  # Pipe previous input through:
  cat

  printf '\n\n'
  printf '/* Set visited link color: */\nlink:visited {color: %s;}\n\n' "$1"

  cat << 'EOF'
/* Use a more readable color for days not in the selected month: */
calendar:indeterminate {color: mix(@theme_base_color, @theme_fg_color, 0.47);}

/* Make separator bars more apparent against the background: */
separator {background-color: shade(@theme_fg_color, 0.43);}
separator.sidebar {background-color: shade(@theme_fg_color, 0.43);}
treeview.view.separator {color: shade(@theme_fg_color, 0.43);}
paned > separator {background-image: image(shade(@theme_fg_color, 0.43));}
paned > separator.wide {background-image: image(shade(@theme_fg_color, 0.43)), image(shade(@theme_fg_color, 0.43));}
frame > border, .frame {border: 1px solid shade(@theme_fg_color, 0.43);}

/* Reduce padding and removed rounded corners on tooltips: */
tooltip * {padding: 0px;}
tooltip {border-radius: 0px;}

/* Reduce the amount of vertical space that statusbars take: */
statusbar.horizontal {margin-top: -3px; margin-bottom: -3px;}

/* Make column headers more distinguishable: */
treeview.view header button {color: @theme_fg_color; background-color: @theme_bg_color; font-weight: normal;}
treeview.view header button:hover {color: @theme_fg_color; background-color: shade(@theme_base_color, 0.97);}
treeview.view header button:active {color: @theme_fg_color; background-color: shade(@theme_bg_color, 0.7);}

/* Make sliders (like volume control) and progress bars more apparent: */
scale trough {
    background-color: shade(@theme_bg_color, 0.7);
    border-radius: 0px;
}
progressbar trough {
    background-color: shade(@theme_bg_color, 0.7);
    border: 1px solid shade(@theme_bg_color, 0.35);
    border-radius: 0px;
}
levelbar trough {
    background-color: shade(@theme_bg_color, 0.7);
    border-radius: 0px;
}

scale trough highlight {
    background-color: shade(@theme_selected_bg_color, 1.12);
    border: 1px solid shade(@theme_bg_color, 0.47);
    border-radius: 0px;
}
progressbar trough progress {
    background-color: shade(@theme_selected_bg_color, 1.12);
    border: 1px solid shade(@theme_selected_bg_color, 0.7);
    border-radius: 0px;
}
levelbar.discrete trough block.filled {
    background-color: shade(@theme_selected_bg_color, 1.12);
    border-color: shade(@theme_selected_bg_color, 1.12);
    border-radius: 0px;
}
levelbar.discrete trough block.full {
    background-color: @success_color;
    border-color: @success_color;
    border-radius: 0px;
}
levelbar.continuous trough block.filled {
    background-color: shade(@theme_selected_bg_color, 1.12);
    border-color: shade(@theme_selected_bg_color, 1.12);
    border-radius: 0px;
}
levelbar.continuous trough block.full {
    background-color: @success_color;
    border-color: @success_color;
    border-radius: 0px;
}

scale.horizontal trough {min-height: 8px;}
scale.vertical trough {min-width: 8px;}
progressbar.horizontal trough {min-height: 19px;}
progressbar.vertical trough {min-width: 19px;}
progressbar.horizontal trough progress {
    min-height: 17px;
    border-radius: 0px;
    margin: 0px;
}
progressbar.vertical trough progress {
    min-width: 17px;
    border-radius: 0px;
    margin: 0px;
}
levelbar.discrete.horizontal trough block {min-height: 4px;}
levelbar.continuous.horizontal trough block {min-height: 4px;}
levelbar.discrete.vertical trough block {min-width: 4px;}
levelbar.continuous.vertical trough block {min-width: 4px;}

scale:not(.marks-before):not(.marks-after) slider {background-image: none;}
scale:not(.marks-before):not(.marks-after) slider {background-color: shade(@theme_base_color, 1.37);}
scale:not(.marks-before):not(.marks-after) slider:hover {background-color: shade(@theme_base_color, 1.6);}
scale:not(.marks-before):not(.marks-after) slider:hover:active {background-color: shade(@theme_base_color, 1.6);}

treeview.view.trough {background-color: shade(@theme_base_color, 1.37);}
treeview.view.trough:selected:focus, treeview.view.trough:selected {background-color: shade(@theme_base_color, 1.7);}
treeview.view.progressbar:selected:focus, treeview.view.progressbar:selected {background-image: image(shade(@theme_selected_bg_color, 1.25));}

/* Switch, check button, and radio button settings: */
switch:checked:not(:disabled) {background-color: shade(@theme_selected_bg_color, 1.05);}
switch slider {background-image: image(shade(@theme_base_color, 1.37));}
switch:hover slider {background-image: image(shade(@theme_base_color, 1.6));}
switch:disabled slider {background-image: image(@theme_bg_color);}

check, radio {transition: none;}

check:checked, radio:checked {
    background-image: image(shade(@theme_selected_bg_color, 1.05));
    border-color: shade(@theme_selected_bg_color, 1.05);
}
check:checked:backdrop, radio:checked:backdrop {background-image: image(shade(@theme_selected_bg_color, 1.05));}
check:indeterminate, radio:indeterminate {
    background-image: image(shade(@theme_selected_bg_color, 1.05));
    border-color: shade(@theme_selected_bg_color, 1.05);
}
check:indeterminate:backdrop, radio:indeterminate:backdrop {background-image: image(shade(@theme_selected_bg_color, 1.05));}

check:checked:hover, radio:checked:hover {background-image: image(shade(@theme_selected_bg_color, 1.25));}
check:indeterminate:hover, radio:indeterminate:hover {background-image: image(shade(@theme_selected_bg_color, 1.25));}

check:active, radio:active {
    box-shadow: none;
    background-image: image(shade(@theme_selected_bg_color, 1.02));
}

check:checked:active, radio:checked:active {
    box-shadow: none;
    background-image: image(shade(@theme_selected_bg_color, 1.5));
}

check:indeterminate:active, radio:indeterminate:active {
    box-shadow: none;
    background-image: image(shade(@theme_selected_bg_color, 1.5));
}

/* Scrollbar settings: */
scrollbar {
    -GtkScrollbar-has-backward-stepper: true;
    -GtkScrollbar-has-forward-stepper: true;
}

scrollbar.top {border-bottom: 2px solid @theme_bg_color;}
scrollbar.bottom {border-top: 2px solid @theme_bg_color;}
scrollbar.left {border-right: 2px solid @theme_bg_color;}
scrollbar.right {border-left: 2px solid @theme_bg_color;}

scrollbar.horizontal trough {
    background-color: shade(@theme_bg_color, 0.77);
    border-top: 1px solid shade(@theme_bg_color, 0.53);
    border-bottom: 1px solid shade(@theme_bg_color, 0.53);
}

scrollbar.vertical trough {
    background-color: shade(@theme_bg_color, 0.77);
    border-left: 1px solid shade(@theme_bg_color, 0.53);
    border-right: 1px solid shade(@theme_bg_color, 0.53);
}

scrollbar.horizontal slider {min-height: 13px;}
scrollbar.vertical slider {min-width: 13px;}

scrollbar.horizontal slider, scrollbar.vertical slider {
    background-color: shade(@theme_bg_color, 1.55);
    transition: none;
    border: 1px solid shade(@theme_bg_color, 0.85);
    border-radius: 0px;
}
scrollbar.horizontal slider:hover, scrollbar.vertical slider:hover {background-color: shade(@theme_bg_color, 1.80);}
scrollbar.horizontal slider:hover:active, scrollbar.vertical slider:hover:active {background-color: shade(@theme_bg_color, 1.95);}

scrollbar button {
    background-color: shade(@theme_bg_color, 1.55);
    color: @theme_fg_color;
    border: 1px solid shade(@theme_bg_color, 0.85);
}
scrollbar button:hover {background-color: shade(@theme_bg_color, 1.95);}
scrollbar button:active, scrollbar button:checked {background-color: shade(@theme_bg_color, 0.77);}
scrollbar button:disabled {
    color: shade(@theme_fg_color, 0.5);
    background-color: shade(@theme_bg_color, 0.95);
}

/* Tab settings: */
notebook > header tab {min-height: 24px; min-width: 24px; padding: 1px 10px;}
notebook > header.top tabs, notebook > header.bottom tabs {padding: 0px;}
notebook > header.left tabs, notebook > header.right tabs {padding: 0px;}
notebook > header.top tab {padding-bottom: 1px;}
notebook > header.bottom tab {padding-top: 1px;}

notebook > header.top tabs tab,
notebook > header.bottom tabs tab,
notebook > header.left tabs tab,
notebook > header.right tabs tab {
    margin: 0px;
}
notebook > header.top tabs tab {margin-bottom: 1px;}
notebook > header.bottom tabs tab {margin-top: 1px;}
notebook > header.left tabs tab {margin-right: 1px;}
notebook > header.right tabs tab  {margin-left: 1px;}

notebook > header {border-color: shade(@theme_base_color, 1.03); background-color: @theme_bg_color;}

notebook.frame > header {border: 0px solid shade(@theme_fg_color, 0.43);}
notebook.frame > header.top {border-bottom-width: 1px;}
notebook.frame > header.bottom {border-top-width: 1px;}
notebook.frame > header.left {border-right-width: 1px;}
notebook.frame > header.right {border-left-width: 1px;}

notebook > header.top > tabs > tab:hover,
notebook > header.top > tabs > tab:checked,
notebook > header.bottom > tabs > tab:hover,
notebook > header.bottom > tabs > tab:checked,
notebook > header.left > tabs > tab:hover,
notebook > header.left > tabs > tab:checked,
notebook > header.right > tabs > tab:hover,
notebook > header.right > tabs > tab:checked {
    box-shadow: none;
}

notebook > header.top tabs tab,
notebook > header.bottom tabs tab,
notebook > header.left tabs tab,
notebook > header.right tabs tab {
    background-color: shade(@theme_bg_color, 0.7);
}

notebook > header.top tabs tab.reorderable-page,
notebook > header.bottom tabs tab.reorderable-page,
notebook > header.left tabs tab.reorderable-page,
notebook > header.right tabs tab.reorderable-page {
    border: 1px solid shade(@theme_bg_color, 0.48);
}

notebook > header.top tabs tab.reorderable-page:hover,
notebook > header.bottom tabs tab.reorderable-page:hover,
notebook > header.left tabs tab.reorderable-page:hover,
notebook > header.right tabs tab.reorderable-page:hover {
    background-color: shade(@theme_bg_color, 0.95);
}

notebook.frame > header.top tabs tab.reorderable-page:hover:not(:checked),
notebook.frame > header.bottom tabs tab.reorderable-page:hover:not(:checked),
notebook.frame > header.left tabs tab.reorderable-page:hover:not(:checked),
notebook.frame > header.right tabs tab.reorderable-page:hover:not(:checked) {
    background-color: shade(@theme_bg_color, 0.85);
}

notebook > header.top tabs tab.reorderable-page:checked,
notebook > header.bottom tabs tab.reorderable-page:checked,
notebook > header.left tabs tab.reorderable-page:checked,
notebook > header.right tabs tab.reorderable-page:checked {
    background-color: @theme_bg_color;
    border: 1px solid shade(@theme_base_color, 1.03);
}

notebook > header.top tabs tab.reorderable-page:not(:last-child),
notebook > header.top tabs tab.reorderable-page:checked:not(:last-child),
notebook > header.bottom tabs tab.reorderable-page:not(:last-child),
notebook > header.bottom tabs tab.reorderable-page:checked:not(:last-child) {
    margin-right: -1px;
}

notebook > header.left tabs tab.reorderable-page:not(:last-child),
notebook > header.left tabs tab.reorderable-page:checked:not(:last-child),
notebook > header.right tabs tab.reorderable-page:not(:last-child),
notebook > header.right tabs tab.reorderable-page:checked:not(:last-child) {
    margin-bottom: -1px;
}

notebook.frame > header.top tabs tab.reorderable-page,
notebook.frame > header.bottom tabs tab.reorderable-page {
    border-top-width: 0px;
    border-bottom-width: 0px;
}
notebook.frame > header.left tabs tab.reorderable-page,
notebook.frame > header.right tabs tab.reorderable-page {
    border-left-width: 0px;
    border-right-width: 0px;
}

notebook > header tabs tab:not(.reorderable-page) {
    border: 1px solid shade(@theme_fg_color, 0.43);
    margin: 0px;
}

notebook > header.top > tabs > tab:not(.reorderable-page),
notebook > header.bottom > tabs > tab:not(.reorderable-page) {
    margin-left: -1px;
}
notebook > header.top > tabs > tab:not(.reorderable-page):last-child,
notebook > header.bottom > tabs > tab:not(.reorderable-page):last-child {
    margin-right: -1px;
}
notebook > header.left > tabs > tab:not(.reorderable-page),
notebook > header.right > tabs > tab:not(.reorderable-page) {
    margin-top: -1px;
}
notebook > header.left > tabs > tab:not(.reorderable-page):last-child,
notebook > header.right > tabs > tab:not(.reorderable-page):last-child {
    margin-bottom: -1px;
}

notebook.frame > header.top tabs tab:not(.reorderable-page) {border-top-width: 0px;}
notebook.frame > header.bottom tabs tab:not(.reorderable-page) {border-bottom-width: 0px;}
notebook.frame > header.left tabs tab:not(.reorderable-page) {border-left-width: 0px;}
notebook.frame > header.right tabs tab:not(.reorderable-page) {border-right-width: 0px;}

notebook > header.top tabs tab:not(.reorderable-page):checked {border-bottom-width: 0px;}
notebook > header.bottom tabs tab:not(.reorderable-page):checked {border-top-width: 0px;}
notebook > header.left tabs tab:not(.reorderable-page):checked {border-right-width: 0px;}
notebook > header.right tabs tab:not(.reorderable-page):checked {border-left-width: 0px;}

notebook > header tabs tab:not(.reorderable-page):hover:not(:checked) {
    background-color: mix(@theme_bg_color, @theme_base_color, 0.125);
}

notebook > header tabs tab:not(.reorderable-page):checked {
    background-color: @theme_base_color;
}
EOF

  printf '\n\n'
  add_additions_lxpanel

  printf '\n\n'
  add_additions_xfce4_panel

  printf '\n\n'
  add_additions_pcmanfm

  printf '\n\n'
  add_additions_firefox
}

add_additions_lxpanel()
{
  cat << 'EOF'
/* BEGIN LXPANEL SETTINGS: */

/* Colorscheme for lxpanel taskbar buttons: */
window#PanelToplevel.background > box.horizontal > box#taskbar.horizontal > widget > button.toggle {
    color: shade(@theme_fg_color, 1.10);
    background-image: none;
    background-color: shade(@theme_base_color, 1.02);
    border: 1px solid shade(@theme_bg_color, 0.9);
    border-radius: 0px;
}

window#PanelToplevel.background > box.horizontal > box#taskbar.horizontal > widget > button.toggle:checked {
    color: shade(@theme_selected_fg_color, 0.90);
    background-image: none;
    background-color: shade(@theme_bg_color, 1.85);
}

window#PanelToplevel.background > box.horizontal > box#taskbar.horizontal > widget > button.toggle:hover {
    color: @theme_selected_fg_color;
    background-image: none;
    background-color: shade(@theme_bg_color, 2.15);
}

/* Colorscheme for the lxpanel pager:
       `color:` is the border around windows.
       `background-color` is the color of the window in the pager,
       and a darker shade of it is used for the background
       (and a ligher shade of it is used for the color of the
       active window).
*/
window#PanelToplevel.background > box.horizontal > widget#pager > widget > wnck-pager > wnck-pager.wnck-pager {
    color: @theme_bg_color;
    background-color: shade(@theme_base_color, 3.0);
}

window#PanelToplevel.background > box.horizontal > widget#pager > widget > wnck-pager > wnck-pager.wnck-pager:selected {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}

window#PanelToplevel.background > box.horizontal > widget#pager > widget > wnck-pager > wnck-pager.wnck-pager:hover {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}
EOF
}

add_additions_xfce4_panel()
{
  cat << 'EOF'
/* BEGIN XFCE4-PANEL SETTINGS: */

/* Colorscheme for the xfce4-panal taskbar buttons: */
window#XfcePanelWindow.xfce4-panel > widget  > widget > box.horizontal > widget.tasklist > button.toggle > box.horizontal {
    color: shade(@theme_fg_color, 1.10);
    background-image: none;
    background-color: shade(@theme_base_color, 1.02);
}

window#XfcePanelWindow.xfce4-panel > widget  > widget > box.horizontal > widget.tasklist > button.toggle:checked > box.horizontal {
    color: shade(@theme_selected_fg_color, 0.90);
    background-image: none;
    background-color: shade(@theme_bg_color, 1.85);
}

window#XfcePanelWindow.xfce4-panel > widget  > widget > box.horizontal > widget.tasklist > button.toggle:hover > box.horizontal {
    color: @theme_selected_fg_color;
    background-image: none;
    background-color: shade(@theme_bg_color, 2.15);
}

/* Colorscheme for the xfce4-panal pager: */
window#XfcePanelWindow.xfce4-panel > widget > widget > wnck-pager > wnck-pager {
    color: @theme_bg_color;
    background-color: shade(@theme_base_color, 3.0);
}

window#XfcePanelWindow.xfce4-panel > widget > widget > wnck-pager > wnck-pager:selected {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}

window#XfcePanelWindow.xfce4-panel > widget > widget > wnck-pager > wnck-pager:hover {
    color: @theme_fg_color;
    background-color: @theme_selected_bg_color;
}

/* Colorscheme for the xfce4-panal clock: */
window#XfcePanelWindow.xfce4-panel > widget > widget > button#clock-button {
    color: shade(@theme_selected_fg_color, 0.90);
    background-image: none;
    background-color: transparent;
    border-style: none;
}

window#XfcePanelWindow.xfce4-panel > widget > widget > button#clock-button:checked {
    color: @theme_fg_color;
}

window#XfcePanelWindow.xfce4-panel > widget > widget > button#clock-button:hover {
    color: @theme_selected_fg_color;
}

/* Colorscheme for the xfce4-panal application menu button: */
window#XfcePanelWindow.xfce4-panel > widget > widget > button.flat.toggle#applicationmenu-button {
    background-image: none;
    background-color: transparent;
    border-style: none;
}

/* Set xfce4-panel taskbar button size: */
window#XfcePanelWindow.xfce4-panel > widget  > widget > box.horizontal > widget.tasklist {
    -XfceTasklist-min-button-length: 150;
    -XfceTasklist-max-button-length: 150;
}

/* On the xfce4-panel, make the xfce4-systemload-plugin use the same
   width and background color as the xfce4-cpugraph-plugin:
*/
.xfce4-panel progressbar.vertical trough {
    min-width: 40px;
    border-style: none;
    border-radius: 0px;
    background-color: black;
}

.xfce4-panel progressbar.vertical progress {
    min-width: 40px;
    border-style: none;
    border-radius: 0px;
}
EOF
}

add_additions_pcmanfm()
{
  cat << 'EOF'
/* BEGIN PCMANFM SETTINGS: */

/* Make the "Places/Directory Tree" combo box be the right color: */
window.background:only-child > decoration:first-child + box.vertical >
    menubar#menubar:first-child + toolbar#toolbar.horizontal + notebook >
    header.top:first-child + stack:last-child > paned.horizontal >
    box.vertical:first-child > box.horizontal:first-child >
    button.flat:only-child {background-color: @theme_bg_color;}

/* Remove border on free-space indicator: */
window.background:only-child > decoration:first-child + box.vertical >
    menubar#menubar:first-child + toolbar#toolbar.horizontal + notebook + statusbar.horizontal:last-child >
    frame:first-child + frame:last-child > border:first-child {border: none;}
EOF
}

add_additions_firefox()
{
  cat << 'EOF'
/* BEGIN FIREFOX SETTINGS: */

/* Make scrollbar more apparent: */
window.background > widget > scrollbar.horizontal > contents > trough,
window.background > widget > scrollbar.vertical > contents > trough {
    background-color: shade(@theme_base_color, 0.975);
}
window.background > widget > scrollbar.horizontal > contents > trough > slider,
window.background > widget > scrollbar.vertical > contents > trough > slider {
    background-color: shade(@theme_base_color, 2.7);
}
window.background > widget > scrollbar.horizontal > contents > trough > slider:hover,
window.background > widget > scrollbar.vertical > contents > trough > slider:hover {
    background-color: shade(@theme_base_color, 3.075);
}
window.background > widget > scrollbar.horizontal > contents > trough > slider:hover:active,
window.background > widget > scrollbar.vertical > contents > trough > slider:hover:active {
    background-color: shade(@theme_base_color, 2.7);
}
EOF
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

main "$@"
