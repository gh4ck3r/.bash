#!/bin/bash

type -t git >/dev/null 2>&1 || return

[[ -v PROMPT_COMMAND && "${PROMPT_COMMAND: -1}" != ';' ]] &&
  PROMPT_COMMAND+=';'
PROMPT_COMMAND+="__update_git_branch_info;"

function __update_git_branch_info()
{
  PS1=$__PS1_PREFIX;
  declare branch;
  branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) &&
    PS1+=':\[\e[01;93m\]('$branch')'
  PS1+=$__PS1_SUFFIX;
}

function setup_git_custom_commands()
{
  local git_custom_cmds=$__bashrc_dir/wrappers/git/git-*
  [[ $(ls $git_custom_cmds 2>&- | wc -l) = 0 ]] && return

  local git_exec_path=$(git --exec-path)
  git_custom_cmds=($git_custom_cmds)
  for cmd in $git_custom_cmds;do
    if [[ $(readlink -e $git_exec_path/$(basename $cmd)) = $cmd ]]; then
      git_custom_cmds=${git_custom_cmds#$cmd}
    fi
  done
  [[ -z "$git_custom_cmds" ]] && return

  local cmd_prefix;
  local cmd_postfix;
  if [[ -w $git_exec_path ]]; then
    :
  elif im_sudoer;then
    cmd_prefix="sudo"
  else
    echo "Some custom git commands can't be installed"
    for cmd in $git_custom_cmds;do
      cmd=$(basename $cmd);
      echo -e "  * \033[91;1m$(basename $cmd)\033[0m"
    done
    return
  fi

  for cmd in $git_custom_cmds;do
    echo "Planting git custom command(s) into $git_exec_path"
    echo -e "  * \033[91;1m$(basename $cmd)\033[0m"

    if $cmd_prefix ln -s $cmd $git_exec_path/;then
      echo " -- Ok"
    else
      echo " -- Failed"
    fi

  done
}
setup_git_custom_commands
unset setup_git_custom_commands
