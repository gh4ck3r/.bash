#!/bin/bash

declare -a CSCOPE_TARGET_EXT=('*.aidl' '*.pidl' '*.idl' '*.xml' '*.xbl' '*.mk' '*.js' '*.jsm' '*.java' '*.h' '*.hh' '*.hpp' '*.c' '*.cc' '*.cpp' '*.s' '*.x');
# Generate find parameter to find targets
_CSCOPE_TARGET_FIND_PATTERN="-type f ( ";
for _ptrn in ${CSCOPE_TARGET_EXT[@]}; do
	_CSCOPE_TARGET_FIND_PATTERN+="-iname $_ptrn -o ";
done
unset CSCOPE_TARGET_EXT
_CSCOPE_TARGET_FIND_PATTERN="${_CSCOPE_TARGET_FIND_PATTERN%-o } ) -print";

function _cscope_build_db()
{
	local at=$1
	echo -n "Generate cscope DB" && (
		pushd $at > /dev/null 2>&1 &&
		cscope -bqk &&
		popd > /dev/null 2>&1
	) && echo " -- Done" || echo " -- Failed"
}

function _cscope-linux-at()
{
	local at=$1
	local list_file="$1/cscope.files"

	echo "Generate file list of linux kernel for cscope at $at"
	find $at \
		-type d \
			-path "$at/include/asm-*" \
			! -path "$at/include/asm-arm*" \
			! -path "$at/include/asm-generic*" \
			-prune -o \
		-type d \
			-path "$at/arch/*" \
			! -path "$at/arch/arm*" \
			-prune -o \
		$_CSCOPE_TARGET_FIND_PATTERN > "$list_file"
	_cscope_build_db $at
}

function _cscope-gaia-at()
{
	local at=$1
	local list_file="$1/cscope.files"
	echo "Generate file list of gaia for cscope at $at"
	find $at \
		-path "$at/xulrunner-sdk" -prune -o \
		-path "$at/xulrunner" -prune -o \
		$_CSCOPE_TARGET_FIND_PATTERN > "$list_file"

	_cscope_build_db $at
}

function _cscope-gecko-at()
{
	local at=$1
	local list_file="$1/cscope.files"
	echo "Generate file list of gecko for cscope at $at"
	find $at \
		-path "$at/python" -prune -o \
		-path "$at/*test" -prune -o \
		-path "$at/*tests" -prune -o \
		-path "$at/*testing" -prune -o \
		-path "$at/*gtk2" -prune -o \
		-path "$at/*mswindows" -prune -o \
		$_CSCOPE_TARGET_FIND_PATTERN > "$list_file"

	_cscope_build_db $at
}

function _cscope-b2g-at()
{
	local at=$1

	shift;
	if [ $# -eq 0 ];then
		_cscope-gecko-at $at/gecko
		_cscope-gaia-at  $at/gaia
		_cscope-linux-at $at/kernel
	else
		while [ $# -gt 0 ];do
			case "$1" in
				gecko)
					_cscope-gecko-at $at/gecko
					;;
				gaia)
					_cscope-gaia-at  $at/gaia
					;;
				kernel)
					_cscope-linux-at $at/kernel
					;;
				*)
					echo "Unknown cscope target : $1"
					;;
			esac
			shift
		done
	fi
}

function _cscope-determine-sourcetree()
{
	local target=$1
	if [ ! -d $target -o ! -x $target ];then
		echo "$target is inaccessible"
		return;
	fi

	declare -A source_dirs=(
		# define source type and it's subdirectories here
		[linux]="arch block crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound usr virt"
		[gecko]="accessible addon-sdk b2g browser build caps chrome config content db docshell dom editor embedding extensions gfx hal image intl ipc js layout media memory mfbt mobile modules mozglue netwerk nsprpub other-licenses parser probes profile python rdf security services startupcache storage testing toolkit tools uriloader view webapprt widget xpcom xpfe xulrunner"
		[gaia]="apps bin build distribution_tablet dogfood_apps external-apps locales media-samples shared showcase_apps test_apps test_external_apps test_media tests tools"
		[b2g]="abi build development gaia hardware librecovery ndk prebuilt system bionic device external gecko kernel vendor bootable frameworks gonk-misc libcore packages sdk build/envsetup.sh"
	)
	for type in ${!source_dirs[@]};do
		local found=true
		for f in ${source_dirs[$type]};do
			if [ ! -s "$target/$f" ];then
				found=false;
				break;
			fi
		done
		if $found;then
			echo "$type"
			return
		fi
	done
	echo "unknown"
	return
}

function cscope-at()
{
	local at=$(readlink -e ${1:-$PWD});

	if   [ ! -d "$at" ];then echo "$1 is not a directory"; return 1;
	elif [ ! -x "$at" ];then echo "$1 is not accessible";  return 2;
	elif [ ! -w "$at" ];then echo "$1 is not writable";    return 3;
	fi

	local target=$(_cscope-determine-sourcetree "$at")
	local handler=_cscope-$target-at

	if [ "$(type -t $handler)" = "function" ];then
		if $handler $at;then
			local db=$at/cscope.out
			if [ -f $db ] && [[ "$CSCOPE_DB" != *$db* ]];then
				export CSCOPE_DB+=${CSCOPE_DB:+:}$db;
			fi
		fi
		return 0
	fi

	cat <<EOF >&2
The source at $at is recognized as '$target' but no handler for it.
EOF
	return 255
}
