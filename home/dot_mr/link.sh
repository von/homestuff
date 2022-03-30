# do_link <src> <dest>
# Create a symlink from src to dest, handling issues that arise
lib = do_link() {
    echo "Linking $1 to $2"
    src=$1; shift
    dest=$1; shift
    # -h will return true for symlink to non-existent file/dir
    if test -h "${dest}" ; then
      rm "${dest}" || return 1
    elif test -e "${dest}" ; then
      echo "Link destination ${dest} exists and is not a link" 1>&2
      return 1
    fi
    destdir=$(dirname "${dest}")
    if test ! -d "${destdir}" ; then
      mkdir -p "${destdir}"
    fi
    ln -s "${src}" "${dest}"
  }
