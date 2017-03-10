#!/bin/bash

function set_nodejs_env()
{
  local NODEJS_PREFIX="/opt/nodejs"

  for nodejs_root in $NODEJS_PREFIX/node-v*;do
    local nodejs_bin_dir=$nodejs_root/bin
    if [[ -x $nodejs_bin_dir/node ]];then
      [[ $PATH != *$nodejs_bin_dir* ]] && export PATH=$nodejs_bin_dir:$PATH
      type -P npm >/dev/null 2>&1 && eval "$(npm completion)"
      break;
    fi
  done
}

set_nodejs_env
unset set_nodejs_env
