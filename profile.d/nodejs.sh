#!/bin/bash

function set_nodejs_env()
{
  local NODEJS_PREFIX="/opt/nodejs"

  node_dirs=$(ls -d /opt/nodejs/node-v* | sort -r) # let higher version first
  for nodejs_root in $node_dirs;do
    local nodejs_bin_dir=$nodejs_root/bin
    local nodejs_lib_dir=$nodejs_root/lib/node_modules
    if [[ -x $nodejs_bin_dir/node ]];then
      [[ $PATH != *$nodejs_bin_dir* ]] && export PATH=$nodejs_bin_dir:$PATH
      [[ $NODE_PATH != *$nodejs_lib_dir* ]] &&
        export NODE_PATH+=${NODE_PATH:+:}$nodejs_lib_dir
      type -P npm >/dev/null 2>&1 && eval "$(npm completion)"
      break;
    fi
  done
}

set_nodejs_env
unset set_nodejs_env
