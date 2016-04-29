#!/bin/bash

GREP_OPTIONS='--exclude=cscope.*'
GREP_OPTIONS+=' --exclude=GPATH --exclude=GRTAGS --exclude=GSYMS --exclude=GTAGS'
GREP_OPTIONS+=' --exclude-dir=.git'
export GREP_OPTIONS

function setup_global_env()
{
  local PATH_GLOBAL_PREFIX=/opt/global
  local PATH_GLOBAL_BIN=$PATH_GLOBAL_PREFIX/bin

  if [[ -x $PATH_GLOBAL_BIN/global ]];then
    if [[ "$PATH" != *$PATH_GLOBAL_BIN* ]];then
      export PATH=$PATH_GLOBAL_BIN:$PATH
    fi
  fi

  if type -t gtags >/dev/null 2>&1;then
    # To make gtags invokes Exuberant Ctags internally
    # https://www.gnu.org/software/global/manual/global.html#Plug_002din
    if ! [[ -v GTAGSCONF ]];then
      export GTAGSCONF=$PATH_GLOBAL_PREFIX/share/gtags/gtags.conf
    fi
    if ! [[ -v GTAGSLABEL ]];then
      export GTAGSLABEL=ctags
    fi
  fi
}
setup_global_env
unset setup_global_env
