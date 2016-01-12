#!/bin/bash

function setup_local_tools()
{
#  local shopt_backup=$(shopt -p globstar)
#  shopt -s globstar
  for bindir in ~/tools/*/bin;do
    if [[ "$PATH" != *$bindir* ]];then
      export PATH=$bindir:$PATH
    fi
  done
#  eval "$shopt_backup" 2> /dev/null
}
setup_local_tools
unset setup_local_tools
