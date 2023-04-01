# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
  # include .bashrc if it exists
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi

## Customizations start:

# startx if on tty1
startx_tty1_auto()
{
  if [ "$(tty)" = "/dev/tty1" ] && command -v startx > /dev/null; then
    startx 2> ~/.xsession-errors
  fi
}

# Set default applications:
export VISUAL='/usr/bin/vim'
export EDITOR="$VISUAL"
export PAGER='less'
export MANPAGER='less --file-size --color=dy --color=uc'

# Prevent gtk scrollbar from autohiding
export GTK_OVERLAY_SCROLLING=0

# Tell gtk apps there is no screenreader (so at-spi2-core can be removed)
export NO_AT_BRIDGE=1

# Make qt5 apps use gtk2 theme (requries qt5-gtk2-platformtheme)
export QT_QPA_PLATFORMTHEME=gtk2

# Enable SDL soundfont support.
export SDL_SOUNDFONTS="${HOME}/.sounds/sf2/gm.sf2"
export SDL_FORCE_SOUNDFONTS=1

startx_tty1_auto
