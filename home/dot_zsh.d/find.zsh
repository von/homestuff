#
# Find-related functions

# Find any filenames with unicode
# Defaults to current directory or path given as argument
find_unicode()
{
  local findpath=${1:-.}
  find "${findpath}" -regex '.*[^ -~].*'
}
