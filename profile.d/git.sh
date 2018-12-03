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
  # \[ and \] in PS1 is translated into \001 and \002 respectively
  # https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt
  if [[ $(git rev-parse --is-inside-git-dir) != false ]];then
    info=':\001\e[0;33m\002'$origin'⎇ <git-dir>'
  elif git diff-index --quiet HEAD -- 2>&-;then
    # No changes
    info=':\001\e[1;33m\002'$origin'⎇ '$branch
  else
    if [[ $(git diff --numstat | wc -l) != 0 ]];then
      # Unstaged changes
      info=':\001\e[1;31m\002'$origin'⎇ '$branch
    else
      # Only staged changes
      info=':\001\e[0;32m\002'$origin'⎇ '$branch
    fi
  fi
  [[ -n $info ]] && echo -ne "${info}"
}


[[ -r $__bashrc_dir/wrappers/git/install.sh ]] && . $__bashrc_dir/wrappers/git/install.sh
[[ -r $__bashrc_dir/wrappers/git/bash-completion.sh ]] && . $__bashrc_dir/wrappers/git/bash-completion.sh
