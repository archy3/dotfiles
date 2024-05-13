#!/bin/sh

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # Set true with the '--force' flag.
  # When true, proceeds with script even if it appears it is not the
  # first login and overwrites files even if they already exist.
  # However, files that have to pre-exist for the procedure to make
  # sense will be overwritten even if this is set to false.
  force=false

  gtk_theme=false
  gtk_bookmarks=false
  make_xdg_user_dirs=false
  make_screenshots_dir=false
  firefox_esr_modify_shortcut=false
  firefox_esr_config=false
  modify_shutdown_prompt_color=false

  if [ "$#" = "0" ]; then
    printf %s\\n \
      "This script requires arguments." \
      "See main() function inside script for details." \
      >&2
    return 1
  fi

  until [ "$#" = "0" ]; do
    case "$1" in
      --force) force=true;;
      --gtk-theme) gtk_theme=true;;
      --gtk-bookmarks) gtk_bookmarks=true;;
      --make-xdg-user-dirs) make_xdg_user_dirs=true;;
      --make-screenshots-dir) make_screenshots_dir=true;;
      --firefox-esr-modify-shortcut) firefox_esr_modify_shortcut=true;;
      --firefox-esr-config) firefox_esr_config=true;;
      --modify-shutdown-prompt-color) modify_shutdown_prompt_color=true;;
      *) printf %s\\n "Invalid argument: ${1}" >&2; return 1;;
    esac
    shift
  done

  test_first_run --force="$force" ~/.bash_history

  if [ "$gtk_theme" = "true" ]; then
    gtk_theme --force="$force"
  fi

  if [ "$gtk_bookmarks" = "true" ]; then
    gtk_bookmarks --force="$force"
  fi

  if [ "$make_xdg_user_dirs" = "true" ]; then
    make_xdg_user_dirs
  fi

  if [ "$make_screenshots_dir" = "true" ]; then
    make_screenshots_dir
  fi

  if [ "$firefox_esr_modify_shortcut" = "true" ]; then
    firefox_esr_modify_shortcut
  fi

  if [ "$firefox_esr_config" = "true" ]; then
    firefox_esr_config --force="$force"
  fi

  if [ "$modify_shutdown_prompt_color" = "true" ]; then
    modify_shutdown_prompt_color
  fi
}

gtk_theme() # <--force=false|--force=true>
(
  test_first_run "$1" ~/.gtkrc-2.0
  test_first_run "$1" ~/.config/gtk-3.0/settings.ini

  gtk2_settings=$(printf %s\\n \
    '# DO NOT EDIT! This file will be overwritten by LXAppearance.' \
    '# Any customization should be done in ~/.gtkrc-2.0.mine instead.' \
    '' \
    "include \"/${HOME%/}/.gtkrc-2.0.mine\"" \
    'gtk-theme-name="Mist-Alt"' \
    'gtk-icon-theme-name="Papirus-Dark"' \
    'gtk-font-name="Sans 10"' \
    'gtk-cursor-theme-name="Adwaita"' \
    'gtk-cursor-theme-size=0' \
    'gtk-toolbar-style=GTK_TOOLBAR_BOTH' \
    'gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR' \
    'gtk-button-images=1' \
    'gtk-menu-images=1' \
    'gtk-enable-event-sounds=0' \
    'gtk-enable-input-feedback-sounds=0' \
    'gtk-xft-antialias=1' \
    'gtk-xft-hinting=1' \
    'gtk-xft-hintstyle="hintfull"'
  )

  gtk3_settings=$(
    printf %s\\n '[Settings]'
    printf %s\\n "$gtk2_settings" | awk 'NR>4{print $0}' | tr -d '"'
  )

  mkdir -p -- ~/.config/gtk-3.0/
  printf %s\\n "$gtk2_settings" > ~/.gtkrc-2.0
  printf %s\\n "$gtk3_settings" > ~/.config/gtk-3.0/settings.ini
)

gtk_bookmarks() # <--force=false|--force=true>
(
  test_first_run "$1" ~/.config/gtk-3.0/bookmarks

  gtk3_bookmarks=$(
    printf "file://${HOME%/}/%s %s\n" \
      documents documents \
      downloads downloads \
      .config config \
      scripts scripts
    printf %s\\n 'file:///tmp /tmp'
  )

  mkdir -p -- ~/.config/gtk-3.0/
  printf %s\\n "$gtk3_bookmarks" > ~/.config/gtk-3.0/bookmarks
)

make_xdg_user_dirs()
(
  for xdg_dir in \
    DESKTOP DOWNLOAD TEMPLATES PUBLICSHARE DOCUMENTS MUSIC PICTURES VIDEOS
  do
    xdg_dir="$(get_xdg_dir "$xdg_dir")"
    mkdir -p -- "$xdg_dir"
  done
)

make_screenshots_dir()
(
  pictures_dir="$(get_xdg_dir PICTURES)"
  screenshot_dir="${pictures_dir}/screenshots"

  if ! [ -d "$pictures_dir" ]; then
    printf %s\\n \
      "Error: XDG_PICTURES_DIR ${pictures_dir} does not exist or is not a directory." \
      "Will not create ${screenshot_dir}" \
      >&2
    return 1
  fi

  mkdir -p -- "$screenshot_dir"
)

# Uses non-posix sed '-i' flag
firefox_esr_modify_shortcut()
{
  if [ -f ~/.config/sxhkd/sxhkdrc ]; then
    sed -e "s/firefox-esr -P [^ ]* /firefox-esr /g" -i -- ~/.config/sxhkd/sxhkdrc
  else
    printf %s\\n \
      "Error: File ${HOME}/.config/sxhkd/sxhkdrc does not exist or is not a regular file." \
      "Will not modify firefox-esr shortcuts." \
      >&2
    return 1
  fi
}

firefox_esr_config() # <--force=false|--force=true>
(
  test_first_run "$1" ~/.mozilla

  prefix=$(LC_ALL=C tr -dc '[:lower:][:digit:]' < /dev/urandom | head -c 8)
  install_hash='3B6073811A6ABF12'
    # Not sure how this hash in generated but that's what it is on debian FF-ESR.
  mkdir -p -- ~/".mozilla/firefox/${prefix}.default-esr"

  printf %s \
  "
    [Profile0]
    Name=default-esr
    IsRelative=1
    Path=${prefix}.default-esr

    [General]
    StartWithLastProfile=1
    Version=2

    [Install${install_hash}]
    Default=${prefix}.default-esr
    Locked=1
  " | sed -n -e 's/^[[:blank:]]*//' -e '/./,/^$/p' \
    > ~/.mozilla/firefox/profiles.ini

  printf %s \
  "
    [${install_hash}]
    Default=${prefix}.default-esr
    Locked=1
  " | sed -n -e 's/^[[:blank:]]*//' -e '/./,/^$/p' \
    > ~/.mozilla/firefox/install.ini

  printf %s \
  '
    // -----------
    // | General |
    // -----------

    // Ask for confirmation if closing multiple tabs:
    pref("browser.tabs.warnOnClose", true);

    // Ask where to download files:
    pref("browser.download.useDownloadDir", false);
    pref("browser.download.always_ask_before_handling_new_types", true);

    // Enable middle mouse scroll:
    pref("general.autoScroll", true);

    // Disable extension and feature recommendations:
    pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
    pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

    // --------
    // | Home |
    // --------

    // Make homepage and new tabs blank:
    pref("browser.startup.homepage", "about:blank");
    pref("browser.newtabpage.enabled", false);

    // Make "firefox home content" show nothing:
    pref("browser.newtabpage.activity-stream.showSearch", false);
    pref("browser.newtabpage.activity-stream.feeds.topsites", false);
    pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
    pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
    pref("browser.newtabpage.activity-stream.showSponsored", false);

    // ----------
    // | Search |
    // ----------

    // Default search engine cannot be set in a .js file.

    // ----------------------
    // | Privacy & Security |
    // ----------------------

    // Start in private browsing mode:
    pref("browser.privatebrowsing.autostart", true);

    // Disable web recommendations (requires locking for some reason):
    pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false, locked);
    pref("browser.urlbar.suggest.quicksuggest.sponsored", false, locked);

    // Do not block "dangerous and deceptive" content:
    pref("browser.safebrowsing.phishing.enabled", false);
    pref("browser.safebrowsing.malware.enabled", false);
    pref("browser.safebrowsing.downloads.enabled", false);
    pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
    pref("browser.safebrowsing.downloads.remote.block_uncommon", false);

    // Enable HTTPS only mode:
    pref("dom.security.https_only_mode", true);
    pref("dom.security.https_only_mode_ever_enabled", true);

    // ---------------------------------
    // | Settings only in about:config |
    // ---------------------------------

    // Disable about:config warning:
    pref("browser.aboutConfig.showWarning", false);

    // When using "open with" when downloading, save to temp directory:
    pref("browser.download.start_downloads_in_tmp_dir", true);

    // Disable geolocation:
    pref("geo.enabled", false);

    // Disable pocket:
    pref("extensions.pocket.enabled", false);

    // Disable firefox view:
    pref("browser.tabs.firefox-view", false);

    // Disable experiments and studies:
    pref("messaging-system.rsexperimentloader.enabled", false);
    pref("app.normandy.enabled", false);

    // Disable "what is new" page after updates:
    pref("browser.startup.homepage_override.mstone", "ignore");

    // Disable "Firefox Privacy Notice" on first launch:
    pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);

    // Disable captive portal support:
    // Note these are often required to be enabled in order to use public WiFi.
    pref("network.captive-portal-service.enabled", false);
    pref("network.connectivity-service.enabled", false);

    // Do not send metadata of downloaded files to Google:
    pref("browser.safebrowsing.downloads.remote.enabled", false);

    // Disable automatic retrieval of addon metadata:
    pref("extensions.getAddons.cache.enabled", false);

    // Disable general disk cache and video disk cache:
    pref("browser.cache.disk.enable", false);
    pref("browser.privatebrowsing.forceMediaMemoryCache", true);

    // Do not shorten "http://example.com" to "example.com":
    pref("browser.urlbar.trimURLs", false);
  ' | sed \
      -n -e 's/^[[:blank:]]*//' -e 's/^pref(/user_pref(/' \
      -e 's/,[[:blank:]]*locked);$/);/' -e '/./,/^$/p' \
        > ~/".mozilla/firefox/${prefix}.default-esr/prefs.js"

  printf %s \
  '
    {
      "uBlock0@raymondhill.net": {
        "permissions": ["internal:privateBrowsingAllowed"],
        "origins":[]
      }
    }
  ' | sed -n -e 's/^[[:blank:]]*//' -e '/./,/^$/p' \
    > ~/".mozilla/firefox/${prefix}.default-esr/extension-preferences.json"
)

# Uses non-posix sed '-i' flag
modify_shutdown_prompt_color()
{
  if [ -f ~/scripts/shutdown-menu.sh ]; then
    sed -e '/^[[:space:]]*command/s/#//' -i -- ~/scripts/shutdown-menu.sh
  else
    printf %s\\n \
      "Error: File ${HOME}/scripts/shutdown-menu.sh does not exist or is not a regular file." \
      "Will not modify shutdown prompt colors." \
      >&2
    return 1
  fi
}

# Helper function to make_xdg_user_dirs() and make_screenshots_dir()
get_xdg_dir() # <xdg_dir>
(
  if ! [ -f ~/.config/user-dirs.dirs ]; then
    printf %s\\n \
      "Error: File ${HOME%/}/.config/user-dirs.dirs does not exists!" \
      "Cannot determine XDG_${1}_DIR!" \
      >&2
    return 1
  fi

  if
    grep -q "^XDG_${1}_DIR=\"\\\$HOME" -- ~/.config/user-dirs.dirs &&
      [ "$(grep -c "^XDG_${1}_DIR=\"\\\$HOME" -- ~/.config/user-dirs.dirs)" = 1 ]
  then
    xdg_dir="$(grep "^XDG_${1}_DIR=\"\\\$HOME" -- ~/.config/user-dirs.dirs)"
    xdg_dir="${xdg_dir#"XDG_${1}_DIR=\"\$HOME"}"
    xdg_dir="${xdg_dir%'"'}"
    xdg_dir="${HOME%/}/${xdg_dir#/}"
  elif
    grep -q "^XDG_${1}_DIR=\"/" -- ~/.config/user-dirs.dirs &&
      [ "$(grep -c "^XDG_${1}_DIR=\"/" -- ~/.config/user-dirs.dirs)" = 1 ]
  then
    xdg_dir="$(grep "^XDG_${1}_DIR=\"/" -- ~/.config/user-dirs.dirs)"
    xdg_dir="${xdg_dir#"XDG_${1}_DIR=\""}"
    xdg_dir="${xdg_dir%'"'}"
  else
    printf %s\\n \
      "Error: Cannot determine XDG_${1}_DIR from ${HOME%/}/.config/user-dirs.dirs!" \
      "File ${HOME%/}/.config/user-dirs.dirs may be malformatted!" \
      >&2
    return 1
  fi

  printf %s\\n "$xdg_dir"
)

test_first_run() # <--force=false|--force=true> <file>
{
  if [ "$1" != "--force=true" ] && [ -e "$2" ]; then
    printf %s\\n \
      "File ${2} already exists!" \
      "This does not appear to be the first login of this user!" \
      "Exiting script." \
      >&2
    return 1
  fi
}

main "$@"
