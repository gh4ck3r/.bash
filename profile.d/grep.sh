#!/bin/bash

declare -a exclude_files=(cscope.* GPATH GRTAGS GSYMS GTAGS)
declare -a exclude_dirs=(.git)

for f in ${exclude_files[*]};do GREP_OPTIONS+=" --exclude=$f";done
unset exclude_files;

for d in ${exclude_dirs[*]};do GREP_OPTIONS+=" --exclude-dir=$d";done
unset exclude_dirs;

export GREP_OPTIONS
export GREP_COLORS='fn=01;36:ln=01;32'

function highlight()
{
  local pattern="^"
  while [[ $# -gt 1 ]];do
    pattern+="|$1"
    shift
  done

  if [[ -r $1 ]];then
    local filename="$1"
  else
    pattern+="|$1"
  fi

  grep -E "$pattern" $filename
}
