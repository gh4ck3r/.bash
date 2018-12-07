#!/bin/bash

type -t git >/dev/null 2>&1 || return

if  type -t __git_ps1 > /dev/null 2>&1;then
  export GIT_PS1_SHOWDIRTYSTATE=true
  export GIT_PS1_SHOWUNTRACKEDFILES=true
  export GIT_PS1_SHOWUPSTREAM="auto verbose"
  export GIT_PS1_DESCRIBE_STYLE="branch"
  export GIT_PS1_HIDE_IF_PWD_IGNORED=true
else
function __git_ps1()
{
  git rev-parse --abbrev-ref HEAD 2>&-
}
fi

declare -A GIT_PS1_COLOR=(
  [git_dir]="0;33"
  [no_change]="1;33"
  [stage_only]="0;32"
  [modified]="1;31"
);

function _git_ps1()
{
  local branch=$(__git_ps1 %s)
  [[ -z $branch ]] && return;

  if [[ -n $GIT_PS1_SHOWDIRTYSTATE ]];then
                     #|   branch   ||       status       ||   upstream   |
    if [[ $branch =~ ^([[:graph:]]+)([[:space:]][*+#$%]+)?([|[:space:]].*)?$ ]];then
      branch=${BASH_REMATCH[1]}${BASH_REMATCH[3]}
      local status=${BASH_REMATCH[2]}
    fi
  fi

  local color;
  if [[ $(git rev-parse --is-inside-git-dir) != false ]];then
    color=${GIT_PS1_COLOR[git_dir]};
  elif [[ -n $GIT_PS1_SHOWDIRTYSTATE ]];then
    case $status in
      "")   color=${GIT_PS1_COLOR[no_change]};;
      " +") color=${GIT_PS1_COLOR[stage_only]};;
      *)    color=${GIT_PS1_COLOR[modified]};
    esac
  else
    if git diff-index --quiet HEAD -- 2>&-;then
      color=${GIT_PS1_COLOR[no_change]};
    elif [[ $(git diff --numstat 2>&- | wc -l) != 0 ]];then
      color=${GIT_PS1_COLOR[modified]};
    else
      color=${GIT_PS1_COLOR[stage_only]};
    fi
  fi
  if [[ -n $color ]];then
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

    # \[ and \] in PS1 is translated into \001 and \002 respectively
    # https://superuser.com/questions/301353/escape-non-printing-characters-in-a-function-for-a-bash-prompt
    echo -ne ":\001\e[${color}m\002${origin}⎇ ${branch}"
  fi
}

[[ -r $__bashrc_dir/wrappers/git/install.sh ]] && . $__bashrc_dir/wrappers/git/install.sh
[[ -r $__bashrc_dir/wrappers/git/bash-completion.sh ]] && . $__bashrc_dir/wrappers/git/bash-completion.sh
