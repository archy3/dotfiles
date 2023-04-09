#!/bin/sh

# Modified TMUX start script from:
#   http://forums.gentoo.org/viewtopic-t-836006-start-0.html

main() # <base_session> <true|false>
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  base_session="${1:-0}"
  make_new_window="${2:-true}"

  # If base sesseion does not already exist, create it
  if ! { tmux ls | grep -q "^${base_session}:"; }; then
    exec tmux new-session -s "$base_session"

  # Else make sure we are not already in a tmux session
  elif [ -z "${TMUX:-}" ]; then
    # Session id is base session with random suffix to prevent conflicts
    session_suffix="$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c 8)"
    session_id="${base_session}-${session_suffix}"

    # Create a new session (without attaching it) and link to base session
    # to share windows
    tmux new-session -d -t "$base_session" -s "$session_id"

    # Create a new window in that session.
    [ "$make_new_window" = 'true' ] &&  tmux new-window

    # Attach to the new session & kill it once orphaned
    exec tmux attach-session -t "$session_id" \; set-option destroy-unattached
  else
    printf %s\\n "It appears you are already in tmux." >&2
    trap '' EXIT
    return 1
  fi
}

main "$@"
