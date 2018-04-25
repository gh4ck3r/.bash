#!/bin/bash

type -t git >/dev/null 2>&1 || return

[[ -v PROMPT_COMMAND && "${PROMPT_COMMAND: -1}" != ';' ]] &&
  PROMPT_COMMAND+=';'
PROMPT_COMMAND+="__update_git_branch_info;"

function __update_git_branch_info()
{
  PS1=$__PS1_PREFIX;

  local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null);
  if [[ -n $branch ]];then
    local origin;
    case $(git ls-remote --get-url origin 2>/dev/null) in
      *github.com*)
        origin=" "
        ;;
      *corpzone.internalzone.com*)
        origin=" "
        ;;
      *)
        origin=" "
        ;;
    esac

    if [[ $(git rev-parse --is-inside-git-dir) != false ]];then
      PS1+=':\[\e[0;33m\]'$origin'⎇ <git-dir>'
    elif git diff-index --quiet HEAD -- 2>/dev/null;then
      # No changes
      PS1+=':\[\e[1;33m\]'$origin'⎇ '$branch
    else
      if [[ $(git diff --numstat | wc -l) != 0 ]];then
        # Unstaged changes
        PS1+=':\[\e[1;31m\]'$origin'⎇ '$branch
      else
        # Only staged changes
        PS1+=':\[\e[0;32m\]'$origin'⎇ '$branch
      fi
    fi
  fi
  PS1+=$__PS1_SUFFIX;
}

function setup_git_custom_commands()
{
  local git_custom_cmds=$__bashrc_dir/wrappers/git/git-*
  [[ $(ls $git_custom_cmds 2>&- | wc -l) = 0 ]] && return

  local git_exec_path_proxy=$HOME/.git-exec-path-proxy;
  if [[ -d $git_exec_path_proxy ]];then
    export GIT_EXEC_PATH=$git_exec_path_proxy
  fi
  local git_exec_path=$(git --exec-path)

  # Remove already planted commands
  git_custom_cmds=($git_custom_cmds)
  local i;
  local cmd_cnt=${#git_custom_cmds[@]}
  for ((i=0;i<$cmd_cnt;++i));do
    local cmd=${git_custom_cmds[$i]}
    if [[ $(readlink -e $git_exec_path/$(basename $cmd)) = $cmd ]]; then
      unset git_custom_cmds[$i]
    fi
  done
  git_custom_cmds=${git_custom_cmds[@]}
  [[ -z $git_custom_cmds ]] && return

  local cmd_prefix;
  local cmd_postfix;
  if [[ -w $git_exec_path ]]; then
    :
  elif im_sudoer;then
    cmd_prefix="sudo"
  elif [[ $git_exec_path_proxy != $GIT_EXEC_PATH ]]; then
    echo "Make Git exec-path proxy : $git_exec_path_proxy"
    [[ -d $git_exec_path_proxy ]] || mkdir -p $git_exec_path_proxy
    for f in $git_exec_path/*; do
      if [[ $(readlink -e $git_exec_path_proxy/$(basename $f)) = $f ]];then continue;fi
      ln -s $f $git_exec_path_proxy/
    done
    unset f
    git_exec_path=$git_exec_path_proxy
    export GIT_EXEC_PATH=$git_exec_path_proxy
  fi

  for cmd in $git_custom_cmds;do
    # Cache sudo password first if necessary
    [[ $cmd_prefix = "sudo" ]] && $cmd_prefix [ ]
    echo "Planting git custom command(s) into $git_exec_path"
    echo -en "  * \033[91;1m$(basename $cmd)\033[0m"

    if $cmd_prefix ln -s $cmd $git_exec_path/ 2>&- ;then
      echo " -- Ok"
    else
      echo " -- Failed"
    fi
  done
  unset cmd
}
setup_git_custom_commands
unset setup_git_custom_commands

. $__bashrc_dir/wrappers/git/bash-completion.sh
