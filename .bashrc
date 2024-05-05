# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# shellcheck shell=bash
# shellcheck disable=SC1090
# shellcheck disable=SC1091

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

PS1="\w$ "
PS1='${debian_chroot:+($debian_chroot)}'"${PS1}"

# Set title if xterm or tmux:
case "$TERM" in
  xterm*|rxvt*|tmux*|screen*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\W\a\]${PS1}";;
esac

# Make prompt red if nonzero return code:
PS1='\[\e[$(($?==0 ? 0 : 31))m\]'"$PS1"'\[\e[0m\]'

# Show exit code on left:
#PS1='\[$(__display_exit_code_on_left__)\]'"$PS1"
PROMPT_COMMAND=__display_exit_code_on_left__

# Disable CTRL-S freezing the terminal:
stty -ixon

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Idea from https://wiki.archlinux.org/title/Bash/Prompt_customization#Right-justified_text
# See also https://superuser.com/a/517110
# (backspacing for some reason deletes the right-hand prompt)
__display_exit_code_on_left__()
{
  case "$?" in
    [!0]*) printf '\e[31m%*s\e[0m\r' "$COLUMNS" '('"$?"')';;
  esac
}
