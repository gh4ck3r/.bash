#!/bin/bash

function setup_global_env()
{
  local PATH_GLOBAL_PREFIX=/opt/global
  local PATH_GLOBAL_BIN=$PATH_GLOBAL_PREFIX/bin

  if [[ -x $PATH_GLOBAL_BIN/global ]] &&
     [[ "$PATH" != *$PATH_GLOBAL_BIN* ]];then
    PATH=$PATH_GLOBAL_BIN:$PATH
  fi
}
setup_global_env
unset setup_global_env
