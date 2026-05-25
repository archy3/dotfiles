# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 0027

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.bin" ]; then
  PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi

## Customizations start:

# startx if on tty1
startx_tty1_auto() # <card> <max-attempts> <time-between-attempts>
{
  if [ "$(tty)" = "/dev/tty1" ] && command -v startx > /dev/null; then
    while [ "$2" -gt 0 ]; do
      set -- "$1" "$(($2-1))" "$3"
      # Make sure the video card has been initalized:
      if [ -c "$1" ]; then
        until [ "$(stat -c %G "$1")" = video ]; do
          :
        done
        startx 2> ~/.xsession-errors
        printf '\n'
        break
      elif [ "$2" -gt 0 ]; then
        printf '%s\n' "${1} not found. Trying again in ${3} second(s)." >&2;
        sleep "$3"
      else
        printf '%s\n' "${1} was not found. No more attempts are left." >&2;
      fi
    done
  fi
}

# Set default applications:
export VISUAL="$(command -v vim || command -v vi)"
export EDITOR="$VISUAL"

if command -v less > /dev/null; then
  export PAGER="$(command -v less)"
  export MANPAGER="${PAGER} --file-size --color=dy --color=uc"

  # Make less understand bold/underline in manpages:
  export MANROFFOPT=-c
fi

# Prevent gtk scrollbar from autohiding
export GTK_OVERLAY_SCROLLING=0

# Tell gtk apps there is no screenreader (so at-spi2-core can be removed)
export NO_AT_BRIDGE=1

# Make qt5/qt6 apps use dark Adwaita theme (requires adwaita-qt/adwaita-qt6)
export QT_STYLE_OVERRIDE=Adwaita-Dark

# Enable SDL soundfont support.
export SDL_SOUNDFONTS="${HOME}/.sounds/sf2/gm.sf2"
export SDL_FORCE_SOUNDFONTS=1

startx_tty1_auto /dev/dri/card0 10 1
