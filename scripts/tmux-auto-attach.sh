#!/bin/sh

# Modified TMUX start script from:
#   http://forums.gentoo.org/viewtopic-t-836006-start-0.html

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  base_session="${1:-0}"
  make_new_window="${2:-true}"

  # This actually works without the trim() on all systems except OSX
  tmux_nb="$(trim "$(tmux ls | grep -c "^$base_session" || true)")"

  if [ "$tmux_nb" = "0" ]; then
    exec tmux new-session -s "$base_session"

  # Make sure we are not already in a tmux session
  elif [ -z "${TMUX:-}" ]; then
    # Session id is date and time to prevent conflict
    session_id="$(date +%Y%m%d%H%M%S)"

    # Create a new session (without attaching it) and link to base session
    # to share windows
    tmux new-session -d -t "$base_session" -s "$session_id"

    # Create a new window in that session.
    [ "$make_new_window" = 'true' ] &&  tmux new-window

    # Attach to the new session & kill it once orphaned
    exec tmux attach-session -t "$session_id" \; set-option destroy-unattached
  else
    echo_portable "It appears you are already in tmux." >&2
    trap '' EXIT
    return 1
  fi
}

# Works because the shell automatically trims by assigning to variables and by
# passing arguments
trim()
{
  # shellcheck disable=SC2086
  echo_portable $1
}

echo_portable()
{
  printf '%s\n' "$*"
}

main "$@"
