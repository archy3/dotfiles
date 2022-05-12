#!/bin/sh

# This script tars important configuration files so they
# can be easily copied to another machine.

main()
{
  set -euf
  trap '[ "$?" != "0" ] && printf \\n%s\\n "${0}: An error occurred." >&2' EXIT

  # Directory with needed resources:
  dir="${HOME}/scripts/"

  # File containing list of files to tar:
  list="${dir}/tar-config.list"

  # File containing list of files to exclude from tarring:
  list_exclude="${dir}/tar-config.exclude"

  # Tar output file:
  tar="${dir}/tar-config.tar.gz"

  for file in "$list" "$list_exclude"; do
    if ! [ -f "$file" ]; then
      printf %s\\n "File ${file} does not exist or is not a regular file." >&2
      return 1
    fi
  done

  unset -v file

  while IFS= read -r file; do
    if ! [ -e "${HOME}/${file}" ]; then
      printf %s\\n "Error: File ${file} from list ${list} does not exist." >&2
      return 1
    fi
  done < "$list"

  # -c: create a tar archive
  # -v: be verbose
  # -z: use gzip compression
  # -f: tar to a file
  # -C: change directory (this avoids the tar file containing the full paths)
  # -X: exclude from tarring the list of files specified in this file
  # -T: tar the list of files specified in this file (that are not excluded)
  tar -cvz -f "$tar" -C "$HOME" -X "$list_exclude" -T "$list"
}

main "$@"
