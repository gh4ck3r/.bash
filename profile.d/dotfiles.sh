#!/bin/bash

function link_dot_files()
{
  unset link_dot_files;

  local DOTFILES_ROOT=$__bashrc_dir/dotfiles
  local shopt_cmd="shopt -p nullglob dotglob globstar"

  local orig_shopt=$($shopt_cmd)

  ${shopt_cmd/-p/-s}
  for f in $DOTFILES_ROOT/**; do
    if [[ -d $f ]]; then continue; fi

    local rc_file_fullpath=${f#$DOTFILES_ROOT/}
    if [[ ! -L ~/$rc_file_fullpath ]]; then
      if [[ -e ~/$rc_file_fullpath ]]; then
        echo "~/$rc_file_fullpath exists but not a link to $f"
      else
        echo "Making a symbolic link $rc_file_fullpath to $f"

        local rc_file_dir=~/
        if [[ $rc_file_fullpath != ${rc_file_fullpath##*/} ]];then
          rc_file_dir+=${rc_file_fullpath%/*}
        fi

        mkdir -p $rc_file_dir
        ln -s -t $rc_file_dir $f
      fi
    fi

  done
  eval "$orig_shopt"
}
link_dot_files
