#!/bin/bash

function _cscope_build_db()
{
  local gen_db_cmd="cscope -bqk"

	echo -n "Generate cscope DB" && (
		pushd $1 > /dev/null 2>&1 &&
		$gen_db_cmd &&
		popd > /dev/null 2>&1
	) && echo " -- Done" || echo " -- Failed"
}

function cscope-at()
{
	local at=$(readlink -e ${1:-$PWD});

	if   [ ! -d "$at" ];then echo "$1 is not a directory"; return 1;
	elif [ ! -x "$at" ];then echo "$1 is not accessible";  return 2;
	elif [ ! -w "$at" ];then echo "$1 is not writable";    return 3;
	fi

  local listfile="$at/cscope.files";
  if [[ -r "$listfile" ]];then
    echo "Existing $listfile is used"
  else
    local sources=$($__bashrc_dir/tools/source-list.sh "$at");
    rm -f $listfile;  # To make sure empty
    for f in $sources;do  # Add only when the sources is readable
      [[ -r $f ]] && echo "$f" >> "$listfile";
    done
  fi

  _cscope_build_db "$at"

  local db="$at/cscope.out"
  if [ -f $db ] && [[ "$CSCOPE_DB" != *$db* ]];then
    export CSCOPE_DB+=${CSCOPE_DB:+:}$db;
  fi
}
