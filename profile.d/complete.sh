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
  local let i=0
  for ((i;i<${#found[@]};++i)) ;do
    local f="${found[$i]}"
    [[ ${f: -2} = "/." || ${f: -3} = "/.." ]] && continue
    local _f="${f#$rootdir}"
    [[ -d "$f" && ! -d "$_f" ]] && _f+="/";
    COMPREPLY[${#COMPREPLY[@]}]="$_f"
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

# This is referenced from /usr/share/bash-completion/bash_completion
BASH_COMPLETION_USER_DIR=$__bashrc_dir
