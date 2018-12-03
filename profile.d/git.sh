#!/bin/bash

type -t git >/dev/null 2>&1 || return

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

  local color;
  # \[ and \] in PS1 is translated into \001 and \002 respectively
  # https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt
  if [[ $(git rev-parse --is-inside-git-dir) != false ]];then
    color='0;33'
  elif git diff-index --quiet HEAD -- 2>&-;then
    # No changes
    color='1;33'
  else
    if [[ $(git diff --numstat 2>&- | wc -l) != 0 ]];then
      # Unstaged changes
      color='1;31'
    else
      # Only staged changes
      color='0;32'
    fi
  fi
  [[ -n $color ]] && echo -ne ":\001\e[${color}m\002${origin}⎇ ${branch}"
}


[[ -r $__bashrc_dir/wrappers/git/install.sh ]] && . $__bashrc_dir/wrappers/git/install.sh
[[ -r $__bashrc_dir/wrappers/git/bash-completion.sh ]] && . $__bashrc_dir/wrappers/git/bash-completion.sh
