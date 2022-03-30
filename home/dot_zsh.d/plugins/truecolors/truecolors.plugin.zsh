#!/bin/zsh
#
# Support for true 24-bit colors
# See https://jdhao.github.io/2018/10/19/tmux_nvim_true_color/
# See https://gist.github.com/XVilka/8346728
# And https://gist.github.com/XVilka/8346728#gistcomment-1868722
# And https://unix.stackexchange.com/a/450366/29832
# Also see ../../../../scripts/24-bit-color.sh
# For mapping of 256 colorset to RGB codes, see https://jonasjacek.github.io/colors/

truecolor() {
  local mode=38  # 0 for clear, 38 for foreground, 48 for background
  local usage="Usage: truecolor [-h] [-c] [-f|-b <red> <green> <blue>]"

  # Leading colon means silent errors, script will handle them
  # Colon after a parameter, means that parameter has an argument in $OPTARG
  while getopts ":bcfhp" opt; do
    case $opt in
      b) mode=48 ;;
      c) mode=0 ;;
      f) mode=38 ;;
      h) echo ${usage} ; return 0 ;;
      \?) echo "Invalid option: -$OPTARG" >&2 ;;
    esac
  done

  shift $(($OPTIND - 1))

  local str="\x1b[${mode}"
  if test ${mode} -ne 0 ; then
    if test $# -ne 3 ; then
      echo "Wrong number of color codes (!=3)"
      echo ${usage}
      return 1
    fi
    local red=$1; shift
    local green=$1; shift
    local blue=$1; shift
    str+=";2;${red};${green};${blue}"
  fi
  str+="m"
  printf ${str}
}

truecolor_test() {
  echo "Output should be smooth band..."
  [[ $COLORTERM =~ ^(truecolor|24bit)$ ]] || echo "Warning: truecolor support not indicated"
  row_args=(
    "0 0 0"
    "\${intensity} 0 0"
    "0 \${intensity} 0"
    "0 0 \${intensity}"
    "\${intensity} \${intensity} 0"
    "\${intensity} 0 \${intensity}"
    "0 \${intensity} \${intensity}"
    "\${intensity} \${intensity} \${intensity}"
    )
  for row_args in $row_args ; do
    # Demonstrate use of embedding escape sequences in a string
    local str=""
    for col in {1..$COLUMNS} ; do
      intensity=$(( 255 * ${col} / ${COLUMNS}))
      # Fancy processing here to deal with $row_args being indirectly resolved
      eval "str+=\$(truecolor -b ${row_args})X"
    done
    str+=$(truecolor -c)
    echo ${str}
  done
  for col in {1..$COLUMNS} ; do
    red=$(( 255 - 255 * ${col} / ${COLUMNS} ))
    green=$(( 510 * ${col} / ${COLUMNS} ))
    [[ ${green} -gt 255 ]] && green=$(( 510 - ${green} ))
    blue=$(( 255 * ${col} / ${COLUMNS}))
    truecolor -b ${red} ${green} ${blue}
    truecolor -f $(( 255 - ${red} )) $(( 255 - ${green} )) $(( 255 - ${blue} ))
    echo -n "X"
  done
  truecolor -c
}
