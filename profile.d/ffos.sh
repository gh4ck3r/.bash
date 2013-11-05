#!/bin/bash

export GREP_OPTIONS='--exclude=cscope.* --exclude-dir=.git'

if [ -r ~/.ffos/lg_ffos_tools/ffos ];then
	source ~/.ffos/lg_ffos_tools/ffos
fi

function inherit_build_environment()
{
	local old_pwd=$PWD
	while [ "$PWD" != "$HOME" -a "$PWD" != "/" ];do
		if __ffos_is_b2g_dir $PWD;then
			_ffos.at $PWD
			clear
			echo "B2G Build Environment is set at $PWD"
			break;
		fi
		cd ..
	done
	cd $old_pwd
}
if [ ! -v ANDROID_BUILD_TOP ];then
	inherit_build_environment
fi

