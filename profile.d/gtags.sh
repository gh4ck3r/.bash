#!/bin/bash

function gtags-at()
{
	local at=$(readlink -e ${1:-$PWD});

	if   [ ! -d "$at" ];then echo "$1 is not a directory"; return 1;
	elif [ ! -x "$at" ];then echo "$1 is not accessible";  return 2;
	elif [ ! -w "$at" ];then echo "$1 is not writable";    return 3;
	fi

  local listfile="$at/gtags.files";
  if [[ -r "$listfile" ]];then
    echo "Existing $listfile is used"
  else
    local sources=$($__bashrc_dir/tools/source-list.sh "$at");
    rm -f $listfile;  # To make sure empty
    for f in $sources;do  # Add only when the sources is readable
      [[ -r $f ]] && echo "$f" >> "$listfile";
    done
    unset f;
  fi

	echo -n "Generate gtags DB" && (
		pushd $1 > /dev/null 2>&1 &&
		gtags &&
		popd > /dev/null 2>&1
	) && echo " -- Done" || echo " -- Failed"

  local db="$at/cscope.out"
  if [ -f $db ] && [[ "$CSCOPE_DB" != *$db* ]];then
    export CSCOPE_DB+=${CSCOPE_DB:+:}$db;
  fi
}

function gtags-clean() {
  local db_path=$(global -qp)

  if [[ -d $db_path ]] && [[ -x $db_path ]];then
    echo "Clean gtags files at $db_path";
    rm -f $db_path/GTAGS \
          $db_path/GRTAGS \
          $db_path/GPATH \
          $db_path/gtags.files \
          > /dev/null;
  else
    echo "No global DB here..";
  fi
}
