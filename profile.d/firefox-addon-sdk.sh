#!/bin/bash

_addon_sdk_dir="/opt/firefox/addon-sdk-1.17"
if [[ -d $_addon_sdk_dir ]];then
  pushd $_addon_sdk_dir 2>&1 > /dev/null && \
  source bin/activate   2>&1 > /dev/null && \
  popd                  2>&1 > /dev/null
fi
unset _addon_sdk_dir

addon_bin=cfx
type $addon_bin >/dev/null 2>&1 || return;

# Trying to connect with nightly
firefox_bin=/opt/firefox/developer/firefox
[[ -x $firefox_bin ]] && alias $addon_bin="$addon_bin -b $firefox_bin"
unset firefox_bin

__cfx_subcmds="init docs run test xpi"

__cfx_sopts="-h -v -b -f -g -p"
__cfx_lopts="
--version
--help
--verbose
--binary
--binary-args
--dependencies
--extra-packages
--filter
--use-config
--profiledir
--package-path
--parseable
--pkgdir
--static-args
--templatedir
--times
--update-link
--update-url
"

_comp_cfx() {
  local completing=${COMP_WORDS[COMP_CWORD]}

  local complete_target;
  if [[ ${completing:0:2} = -- ]];then
    complete_target="$__cfx_lopts"
  elif [[ ${completing:0:1} = - ]];then
    complete_target="$__cfx_sopts"
  else
    complete_target="$__cfx_subcmds"
  fi

  COMPREPLY=( $(compgen -W "$complete_target" -- $completing) )
}
complete -F _comp_cfx $addon_bin
unset addon_bin
