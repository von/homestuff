#!/bin/zsh
# yy: copy and paste files

export YY_FILE=${HOME}/.yy

# yy: Record file(s)
function yy()
{
  test $# -eq 0 && { test -f ${YY_FILE} && cat ${YY_FILE} ; return 0 ; }
  { for f in ${(q)@} ; do echo ${f:A} ; done } > ${YY_FILE}
}

# YY: Record file(s) by appending to current files
function YY()
{
  test $# -eq 0 && { test -f ${YY_FILE} && cat ${YY_FILE} ; return 0 ; }
  { for f in ${(q)@} ; do echo ${f:A} ; done } >> ${YY_FILE}
}

# pp: Copy files(s) from record to current directory
function pp()
{
  test -f ${YY_FILE} || { echo "No files to copy." ; return 0 ; }
  echo "Copying..."
  for f in $(cat ${YY_FILE}) ; do cp -v ${f} . ; done
}

# PP: Move files(s) from record to current directory
function PP()
{
  test -f ${YY_FILE} || { echo "No files to move." ; return 0 ; }
  echo "Moving..."
  for f in $(cat ${YY_FILE}) ; do mv -v ${f} . ; done
  rm -f ${YY_FILE}
}
