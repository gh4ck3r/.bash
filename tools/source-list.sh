#!/bin/bash

if ! which fd >/dev/null;then
  echo 'Download & install "fd" first - https://github.com/sharkdp/fd/releases'
  exit 1
fi

# Generate find parameter to find targets
FIND_PATTERN="-at f ";

function sourcetree-type()
{
	local target="$1"
	if [ ! -d "$target" -o ! -x "$target" ];then
		echo "$target is inaccessible"
		return;
	fi

  # define source type and it's subdirectories here
	declare -A source_dirs=(
		[linux]="arch block crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound usr virt"
		[gecko]="accessible b2g browser build caps chrome config content db docshell dom editor embedding extensions gfx hal image intl ipc js layout media memory mfbt mobile modules mozglue netwerk nsprpub other-licenses parser probes profile python rdf security services startupcache storage testing toolkit tools uriloader view webapprt widget xpcom xpfe xulrunner"
		[gaia]="apps build dogfood_apps external-apps locales media-samples shared showcase_apps test_apps test_external_apps test_media tests tools"
		[b2g]="abi build development gaia hardware librecovery ndk prebuilt system bionic device external gecko kernel vendor bootable frameworks gonk-misc libcore build/envsetup.sh"
    [nodejs-prj]="node_modules"
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
	echo "generic"
	return
}

function list-generic-sources() {
  echo "# Source files of generic project"
  fd $FIND_PATTERN -p "$1"
}

function list-linux-sources() {
  echo "FIXME : Find linux sources at $1" >&2
  return 1
  fd \
    -type d \
      -path "$1/include/asm-*" \
      ! -path "$1/include/asm-arm*" \
      ! -path "$1/include/asm-generic*" \
      -prune -o \
    -type d \
      -path "$1/arch/*" \
      ! -path "$1/arch/arm*" \
      -prune -o \
    $FIND_PATTERN "$1"
}

function list-gaia-sources() {
  fd --full-path "$1" \
    --exclude /xulrunner-sdk* \
    --exclude /xulrunner \
    $FIND_PATTERN
}

function list-gecko-sources() {
  fd --full-path "$1" \
    --exclude /python \
    --exclude /*test \
    --exclude /*tests \
    --exclude /*testing \
    --exclude /*gtk2 \
    --exclude /*mswindows \
    $FIND_PATTERN
}

function list-b2g-sources() {
  list-gecko-sources "$1/gecko";
  list-gaia-sources  "$1/gaia";
  list-linux-sources "$1/kernel";
}

function list-nodejs-prj-sources() {
  echo "# Source files of Node.js project"
  fd --full-path "$1" \
    --exclude node_modules \
    --exclude .eslintrc.js \
    --exclude /package*.json \
    $FIND_PATTERN
}

while [[ $# > 0 ]];do
  src_type=$(sourcetree-type "$1");
  set -f && list-${src_type}-sources "$1";
  shift;
done
