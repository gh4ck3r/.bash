#!/bin/bash

function setup_local_tools()
{
#  local shopt_backup=$(shopt -p globstar)
#  shopt -s globstar
  for bindir in ~/tools/*/bin ~/.local/bin;do
    if [[ -d $bindir ]] && [[ "$PATH" != *$bindir* ]];then
      export PATH=$bindir:$PATH
    fi
  done
#  eval "$shopt_backup" 2> /dev/null
}
setup_local_tools
unset setup_local_tools

function im_sudoer()
{
  type -t sudo >/dev/null 2>&1 &&
    [[ $(sudo -vn 2>&1) != "Sorry, user $USER may not run sudo on $HOSTNAME." ]];
}
