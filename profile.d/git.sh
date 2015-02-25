#!/bin/bash

function __update_git_branch_info()
{
  PS1=$__PS1_PREFIX;
  declare branch;
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) &&
    PS1+=':\[\e[01;93m\]('$branch')'
  PS1+=$__PS1_SUFFIX;
}

if command -v git >/dev/null 2>&1 ;then
  [[ -v PROMPT_COMMAND && "${PROMPT_COMMAND: -1}" != ';' ]] &&
    PROMPT_COMMAND+=';'
  PROMPT_COMMAND+="__update_git_branch_info;"
fi
