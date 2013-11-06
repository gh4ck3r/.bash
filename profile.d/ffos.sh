#!/bin/bash

export GREP_OPTIONS='--exclude=cscope.* --exclude-dir=.git'

if [ -r ~/.ffos/ffos ];then
	source ~/.ffos/ffos;

	if [ ! -v ANDROID_BUILD_TOP ];then
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
