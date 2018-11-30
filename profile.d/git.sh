#!/bin/bash

type -t git >/dev/null 2>&1 || return

#[[ -v PROMPT_COMMAND && "${PROMPT_COMMAND: -1}" != ';' ]] &&
#  PROMPT_COMMAND+=';'
#PROMPT_COMMAND+="__update_git_branch_info;"

if ! type -t __git_ps1 > /dev/null 2>&1;then
function __git_ps1()
{
  git rev-parse --abbrev-ref HEAD 2>&-
}
fi

function _git_ps1()
{
  local branch=$(__git_ps1 %s)
  [[ -z $branch ]] && return;

  local origin;
  case $(git ls-remote --get-url origin 2>&-) in
    *github.com[:/]*)
      origin=" "
      ;;
    *github*)
      origin=" "
      ;;
    *)
      origin=" "
      ;;
  esac

  local info;
  if [[ $(git rev-parse --is-inside-git-dir) != false ]];then
    info=':\e[0;33m'$origin'⎇ <git-dir>'
  elif git diff-index --quiet HEAD -- 2>&-;then
    # No changes
    info=':\e[1;33m'$origin'⎇ '$branch
  else
    if [[ $(git diff --numstat | wc -l) != 0 ]];then
      # Unstaged changes
      info=':\e[1;31m'$origin'⎇ '$branch
    else
      # Only staged changes
      info=':\e[0;32m'$origin'⎇ '$branch
    fi
  fi
  [[ -n $info ]] && echo -ne $info
}


[[ -r $__bashrc_dir/wrappers/git/install.sh ]] && . $__bashrc_dir/wrappers/git/install.sh
[[ -r $__bashrc_dir/wrappers/git/bash-completion.sh ]] && . $__bashrc_dir/wrappers/git/bash-completion.sh
