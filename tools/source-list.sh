#!/bin/bash

declare -a SRC_PTRN=(
    '*.webidl' '*.aidl' '*.ipdl' '*.idl'
    '*.xml' '*.xbl' '*.html'
    '*.mk'
    '*.js' '*.jsm' '*.json'
    '*.java'
    '*.h' '*.H' '*.hh' '*.hpp' '*.hxx'
    '*.c' '*.C' '*.cc' '*.cpp' '*.c++' '*.cxx'
    '*.s' '*.S'
    '*.x'
    '*.y'
    '*.php' '*.php3' '*.phtml');
# Generate find parameter to find targets
FIND_PATTERN="-type f ( ";
set -f
for _ptrn in ${SRC_PTRN[@]}; do
	FIND_PATTERN+="-iname $_ptrn -o ";
done
unset SRC_PTRN
FIND_PATTERN="${FIND_PATTERN%-o } ) -print";
set +f

function sourcetree-type()
{
	local target=$1
	if [ ! -d $target -o ! -x $target ];then
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
  find "$1" $FIND_PATTERN
}

function list-linux-sources() {
  find $1 \
    -type d \
      -path "$1/include/asm-*" \
      ! -path "$1/include/asm-arm*" \
      ! -path "$1/include/asm-generic*" \
      -prune -o \
    -type d \
      -path "$1/arch/*" \
      ! -path "$1/arch/arm*" \
      -prune -o \
    $FIND_PATTERN
}

function list-gaia-sources() {
  find $1 \
    -path "$1/xulrunner-sdk*" -prune -o \
    -path "$1/xulrunner" -prune -o \
    $FIND_PATTERN
}

function list-gecko-sources() {
  find $1 \
    -path "$1/python" -prune -o \
    -path "$1/*test" -prune -o \
    -path "$1/*tests" -prune -o \
    -path "$1/*testing" -prune -o \
    -path "$1/*gtk2" -prune -o \
    -path "$1/*mswindows" -prune -o \
    $FIND_PATTERN
}

function list-b2g-sources() {
  list-gecko-sources $1/gecko;
  list-gaia-sources  $1/gaia;
  list-linux-sources $1/kernel;
}

function list-nodejs-prj-sources() {
  echo "# Source files of Node.js project"
  find "$1" \
    -path "$1/node_modules" -prune -o \
    -name ".eslintrc.js" -prune -o \
    -name "package.json" -prune -o \
    -name "package-lock.json" -prune -o \
    $FIND_PATTERN
}

while [[ $# > 0 ]];do
  src_type=$(sourcetree-type "$1");
  set -f && list-${src_type}-sources "$1";
  shift;
done
