#!/bin/zsh
# Wrapper around script to set SCRIPT_FILE environment variable

script() {
  _file="${@: -1}"
  env SCRIPT_FILE="${_file}" script ${(j. .)${(q)@}}
}
