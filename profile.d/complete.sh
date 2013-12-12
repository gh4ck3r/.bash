#!/bin/bash

################################################################################
# function : __complete_files_at
#   desc : complete files within given directory including subdirectory
#   param1 : root directory for finding a files to be completed
#
function __complete_files_at()
{
  local rootdir=$(readlink -e ${1:-/})
  local completing=${COMP_WORDS[COMP_CWORD]}

  local finding=$rootdir$completing
  local found=( $(compgen -f $finding) )
  for f in ${found[@]};do
    if [ $f = "$rootdir/." -o $f = "$rootdir/.." ];then continue; fi;
    if [ -d $f -a ! -d "${f#$rootdir}" ];then f+="/"; fi
    COMPREPLY[${#COMPREPLY[@]}]=${f#$rootdir}
  done


  local basedir=${finding%/}
  while [ "$basedir" != "$rootdir" -a $basedir != "/" ];do
    basedir=$(dirname $basedir)
  done

  compopt -o filenames
  if [ ${#COMPREPLY[@]} -ne 1 -o ! -f $basedir/${COMPREPLY[0]} ];then
    compopt -o nospace
  fi
}

