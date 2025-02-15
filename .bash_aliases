# shellcheck shell=bash

# shorthand:
alias c='clear'
alias r='less'
ee() { nohup mousepad "$@" </dev/null >/dev/null 2>&1 & }
complete -F _longopt ee
alias e='vim'
alias ge='gvim'
alias p='cat'
alias o='xdg-open'
alias tls='tmux ls'
alias ht='htop -u'
ec() { printf %s\\n "$*"; }
int() { [ -z "${TMUX:-}" ] && echo "Not in tmux." || echo "In tmux."; }

# colors:
alias ls="ls --color=auto -v --group-directories-first --time-style='+%Y %m-%d %H:%M'"
alias l="ls --color=auto -1v --group-directories-first --time-style='+%Y %m-%d %H:%M'"
alias la="ls --color=auto -1Av --group-directories-first --time-style='+%Y %m-%d %H:%M'"
alias lla="ls --color=auto -lAvh --group-directories-first --time-style='+%Y %m-%d %H:%M'"
alias ll="ls --color=auto -lvh --group-directories-first --time-style='+%Y %m-%d %H:%M'"
cdl() { cd "$@" && ls --color=auto -lvh --group-directories-first --time-style='+%Y %m-%d %H:%M'; }
lsd() # [dir]
(
  if [ -n "$1" ]; then
    cd -- "$1" || exit "$?"
  fi

  set -- */
  if test -d "$1"; then
    ls -1 -d -v --group-directories-first --color=auto -- "$@"
  fi
)
lad() # [dir]
(
  if [ -n "$1" ]; then
    cd -- "$1" || exit "$?"
  fi

  set --
  local file
  for file in .[!.]*/ ..?*/ */; do
    if test -d "$file"; then
      set -- "$file" "$@"
    fi
  done
  if [ "$#" -ge "1" ]; then
    ls -1 -d -v --group-directories-first --color=auto -- "$@"
  fi
)
alias lsda=lad
alias grep='grep --color=auto'
alias g='grep --color=auto'

# safety:
alias saferm='rm -i'
alias safecp='cp -i'
alias safemv='mv -i'

# directory shortcuts:
alias tmp='cd /tmp'
alias sc='cd ~/scripts'
alias tags='cd ~/scripts/tags'
alias conf='cd ~/.config'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# outside path:
alias dp='~/scripts/doom/p'
alias i500='~/scripts/tags/img500x500.sh'
alias ta='~/scripts/tmux-auto-attach.sh 0 false'
alias custom-tag='~/scripts/tags/custom-tag.sh'
tagtools()
{
  # Work on all flac files in the current directory (as well as files
  # specified on the command line). The for loop prevents "./*" from being
  # passed as an argument when no flac files are in the current directory.
  local file
  for file in ./*.flac; do
    if [ -f "$file" ]; then
      set -- "$@" ./*.flac
      break
    fi
  done
  ~/scripts/tags/tag-tools.sh "$@"
}

# functions
repeat() # count commands...
{
  local count
  local i

  if [ "$#" -lt 2 ]; then
    printf %s\\n "Usage: ${FUNCNAME[0]} <count> <commands...>"
    return 1
  fi

  case "$1" in
    *[!0-9]*|'')
      printf %s\\n "The first argument must be a number" >&2
      return 1
      ;;
  esac

  count="$1"
  shift

  for (( i=1; i<=count; i++ )); do
    "$@"
  done
}

# history search
hs() # [grep_expression]
{
  if [ "$#" -lt 1 ]; then
    history
  else
    history | grep --color=auto -e "$*"
  fi
}

vmshare() # a|d libvirt-vm-domain
{
  local attach_detach="$1"
  local libvirt_domain="$2"
  local script="${HOME}/virt-manager/share/share.sh"
  local drive="${HOME}/virt-manager/share/e64.img"

  if [ "$#" != "2" ]; then
    printf '%s\n\n%s\n' \
      'This function requires two arguments.' \
      'Usage: vmshare a|d libvirt-vm-domain' >&2
    return 1
  fi

  case "$attach_detach" in
    a|d) "$script" "$attach_detach" "$libvirt_domain" "$drive" rw;;
    *)
      printf '%s\n' \
        'First argument must be "a" (for attach) or "d" (for detach).' >&2
      return 1
      ;;
  esac
}

#alias up='su - root -c "apt-get update && apt upgrade && apt dist-upgrade && apt-get autoremove && apt-get clean"'
