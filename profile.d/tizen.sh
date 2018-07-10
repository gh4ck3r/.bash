#!/bin/bash

TIZEN_SDK=$HOME/tizen/studio
[[ -d $TIZEN_SDK ]] || return;

export TIZEN_SDK

TIZEN_PATH=":$TIZEN_SDK/tools:$TIZEN_SDK/tools/ide/bin";
[[ $PATH == *$TIZEN_PATH* ]] || export PATH+=$TIZEN_PATH

function set_tizen_env()
{
  local tools=$TIZEN_SDK/tools;
  local sdb=$tools/sdb;
  local sdb_completion=$tools/.sdb-completion.bash;
  local tizen_completion=$tools/ide/bin/tizen-autocomplete;

  [[ -r $sdb_completion ]] && . $sdb_completion;
  [[ -r $tizen_completion ]] && . $tizen_completion;

  [[ -x $sdb ]] && [[ -w $sdb ]] && ! [[ -L $sdb ]] || return;
  echo -e "\033[91;1mReplace sdb with wrapper\033[0m : $sdb"
  mv $sdb $sdb.orig 2>&1 >/dev/null
  ln -s $__bashrc_dir/wrappers/sdb $sdb 2>&1 >/dev/null
}
set_tizen_env
unset set_tizen_env
