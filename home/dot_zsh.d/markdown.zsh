#
# Configuration for working with markdown

function open-markdown {
  if test $# -ne 1 ; then
    echo "Usage: $0 <markdown file>"
    return 1
  fi

  _my_basename=$(basename ${0})
  _tmp_dir=$(mktemp -d -t ${_my_basename})
  _html_file=${_tmp_dir}"/"$(basename -s .markdown -s .md ${1})".html"
  markdown ${1} > ${_html_file}
  open ${_html_file}
}
