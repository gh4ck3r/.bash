#!/bin/bash

# Append GREP_OPTIONS to alias of grep
IFS=\= read unused GREP_OPTIONS <<< $(alias grep)
unset unused
GREP_OPTIONS=${GREP_OPTIONS:1:-1} # trim single quotes

declare -a exclude_files=(cscope.* GPATH GRTAGS GSYMS GTAGS gtags.files)
declare -a exclude_dirs=(.git)

for f in ${exclude_files[*]};do GREP_OPTIONS+=" --exclude=$f";done
unset f exclude_files;

for d in ${exclude_dirs[*]};do GREP_OPTIONS+=" --exclude-dir=$d";done
unset d exclude_dirs;

alias grep="$GREP_OPTIONS"
unset GREP_OPTIONS

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
