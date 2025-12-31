#!/bin/sh
# Set up and run chezmoi
# XXX TODO: Get gpg in functional shape

set -o errexit  # Exit on error

chezmoi_path="${HOME}/.local/share/chezmoi"

# Path to directory containing this script
# Kudos: https://stackoverflow.com/a/246128/197789
my_path=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if test -d "${chezmoi_path}" ; then
  echo "${chezmoi_path} already exists."
else
  echo "Creating ${chezmoi_path} as symlink to this directory."
  mkdir -p $(dirname "${chezmoi_path}")
  ln -s "${chezmoi_path}" "${my_path}"
fi

echo "Running 'chezmoi apply'"
chezmoi apply -v

echo "Success."
exit 0
