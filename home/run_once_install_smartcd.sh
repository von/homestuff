#!/bin/sh
# Install smartcd in ~/.smartcd
# https://github.com/cxreg/smartcd

set -o errexit  # Exit on error

echo "Installing smartcd"
_tmpdir=$(mktemp -d)
cd "${_tmpdir}"
git clone https://github.com/cxreg/smartcd.git
cd smartcd
make install
cd
rm -rf ${_tmpdir}
echo "Success."
exit 0
