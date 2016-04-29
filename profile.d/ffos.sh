#!/bin/bash

[[ -r  ~/.ffos/ffos ]] || return
source ~/.ffos/ffos;

[[ -d "$ANDROID_BUILD_TOP" ]] || return

__old_pwd=$PWD
while [[ "$PWD" != "$HOME" ]] && [[ "$PWD" != "/" ]]; do
  if __ffos_is_b2g_dir $PWD;then
    _ffos.at $PWD
    clear
    echo "B2G Build Environment is set at $PWD"
    break;
  fi
  cd ..
done
cd $__old_pwd
unset __old_pwd
