#!/bin/bash

TIZEN_SDK_HOME=$HOME/tizen-sdk
[[ -d $TIZEN_SDK_HOME ]] || return;

export PATH+=":$TIZEN_SDK_HOME/tools:$TIZEN_SDK_HOME/tools/ide/bin"

function set_tizen_env()
{
  local sdb=$TIZEN_SDK_HOME/tools/sdb;

  [[ -x $sdb ]] && [[ -w $sdb ]] && ! [[ -L $sdb ]] || return;
  echo -e "\033[91;1mReplace sdb with wrapper\033[0m : $sdb"
  mv $sdb $sdb.orig 2>&1 >/dev/null
  ln -s $__bashrc_dir/wrappers/sdb $sdb 2>&1 >/dev/null
}
set_tizen_env
unset set_tizen_env
