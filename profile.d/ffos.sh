#!/bin/bash

GREP_OPTIONS='--exclude=cscope.*'
GREP_OPTIONS+=' --exclude=GPATH --exclude=GRTAGS --exclude=GSYMS --exclude=GTAGS'
GREP_OPTIONS+=' --exclude-dir=.git'
export GREP_OPTIONS

if [ -r ~/.ffos/ffos ];then
	source ~/.ffos/ffos;

	if [ -d "$ANDROID_BUILD_TOP" ];then
		__old_pwd=$PWD
		while [ "$PWD" != "$HOME" -a "$PWD" != "/" ];do
			if __ffos_is_b2g_dir $PWD;then
				_ffos.at $PWD
				clear
				echo "B2G Build Environment is set at $PWD"
				break;
			fi
			cd ..
		done
		cd $__old_pwd
		unset __old_pwd
	fi
fi
