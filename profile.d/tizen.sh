#!/bin/bash

TIZEN_SDK=$HOME/tizen/studio
[[ -d $TIZEN_SDK ]] || return;

export TIZEN_SDK

export PATH+=":$TIZEN_SDK/tools:$TIZEN_SDK/tools/ide/bin";

function set_tizen_env()
{
  local tools=$TIZEN_SDK/tools;
  local sdb=$tools/sdb;
  local sdb_completion=$tools/.sdb-completion.bash;

  [[ -r $sdb_completion ]] && . $sdb_completion;

  [[ -x $sdb ]] && [[ -w $sdb ]] && ! [[ -L $sdb ]] || return;
  echo -e "\033[91;1mReplace sdb with wrapper\033[0m : $sdb"
  mv $sdb $sdb.orig 2>&1 >/dev/null
  ln -s $__bashrc_dir/wrappers/sdb $sdb 2>&1 >/dev/null
}
set_tizen_env
unset set_tizen_env
