#!/bin/bash

[[ -d ~/Android ]] || return;

ANDROID_TOOLKIT_DIR=~/Android

function set_android_env()
{
  # I don't want android build system to change my PROMPT_COMMAND
  export STAY_OFF_MY_LAWN="yes"

  local ANDROID_SDK=$ANDROID_TOOLKIT_DIR/Sdk

  [[ -d $ANDROID_SDK ]] || return
  local platform_tools=$ANDROID_SDK/platform-tools
  PATH=$platform_tools:$ANDROID_SDK/tools:$PATH

  local adb=$platform_tools/adb
  alias adb=$adb

  [[ -x $adb ]] && [[ -w $adb ]] && ! [[ -L $adb ]] || return
  echo -e "\033[91;1mReplace adb with wrapper\033[0m : $adb"
  mv $adb $adb.orig 2>&1 >/dev/null
  ln -s $__bashrc_dir/wrappers/adb $adb 2>&1 >/dev/null
}
set_android_env
unset set_android_env

function eclipse-at()
{
	local eclipse_bin=/home/changbin.park/Android/eclipse/eclipse
	local workspace

	case $# in
		0)
			workspace=`zenity --file-selection --directory  --width=200 --height=100 --title="Select workspace"`;;
		1)
			if [ -d $@ ]; then workspace=$@; fi;;
	esac

	if [[ -n "$workspace"  &&  -d $workspace ]]; then
		pushd $workspace > /dev/null
		$eclipse_bin -data $workspace -name $workspace > /dev/null &
		popd > /dev/null
	else
		echo "Usage) eclipse-at <directory>"
		echo "  Launch eclipse with <directory> as workspace"
	fi
}

function sget()
{
	local dest

	case "${1:0:5}" in
		smb://)
			dest=$1;;
		*)
			if [[ ${1:0:2} = '\\' ]]; then
				dest=smb:${1//\\/\/}
			fi;;
	esac

	if [[ -n "$dest" ]]; then
		smbget -u $USER -w LGE -D ''"$dest"''
	fi
}

function instrument()
{
	case $1 in
		list)
			adb shell pm list instrumentation $2 | sed -e 's/^instrumentation:\(.\+\)\s\+(target=\(.\+\))/\2 : \1/'
			;;
		test)
			adb shell am instrument -w $2
			;;
		*)
			echo "Usage) instrument list [target-package]"
			echo "       instrument test <instrument>"
			return;
			;;
	esac
}

function devenv()
{
	local DEVROOT=$HOME/work/Android

	local TARGET
	local ZENITY_ARGS
	for TARGET in `find $DEVROOT/ -mindepth 2 -maxdepth 2 -type d -printf "%P " | sort`; do
		ZENITY_ARGS="$ZENITY_ARGS $TARGET $(dirname $TARGET) $(basename $TARGET)"
	done

	local TARGET_DIR=$(zenity --list --text="Development list" --hide-column=1 --column="Path" --column="Projects" --column="Versions" $ZENITY_ARGS)

	setup_android_env "$DEVROOT/$TARGET_DIR"
}

function _check_android_dir_structure()
{
	if [ ! -d $@ ];then
		echo "Directory '$@' is not exist"
		echo "  --> No environment is set!!"
		return 1;
	fi
	local ANDROID_KNOWN_DIRS="
		bionic
		bootable
		build
		build/core
		build/target
		build/target/board
		build/target/board/generic
		cts
		dalvik
		development
		device
		external
		frameworks
		frameworks/base
		hardware
		hardware/libhardware
		hardware/libhardware_legacy
		packages
		prebuilt
		system
		system/core
		system/core/init
		system/vold
		vendor"
	local ANDROID_DIR
	for ANDROID_DIR in $ANDROID_KNOWN_DIRS;do
		if [ ! -d $@/$ANDROID_DIR ];then
			echo "'$@/$ANDROID_DIR' is not exist'"
			echo "  --> No environment is set!!"
			return 1;
		fi
	done
	if [ ! -f $@/build/envsetup.sh ];then
		echo "'$@/$ANDROID_DIR/build/envsetup.sh' is not exist'"
		echo "  --> No environment is set!!"
		return 1;
	fi

	return 0;
}

function setup_android_env()
{
	local PROJECTROOT=$@
	local ANDROID_ROOT=$PROJECTROOT/android

	_check_android_dir_structure $ANDROID_ROOT
	if [ $? -ne 0 ];then
		return $?;
	fi;

	cd $ANDROID_ROOT
	source build/envsetup.sh

	if [ -f $PROJECTROOT/.config ];then
		source $PROJECTROOT/.config
	fi

	$ANDROID_BUILD_PRE_ENV

	if [ $ANDROID_BUILD_TYPE ] && [ $ANDROID_BUILD_PRODUCT ] && [ $ANDROID_BUILD_VARIANT ];then
		echo "choosecombo $ANDROID_BUILD_TYPE $ANDROID_BUILD_PRODUCT $ANDROID_BUILD_VARIANT"
		choosecombo $ANDROID_BUILD_TYPE $ANDROID_BUILD_PRODUCT $ANDROID_BUILD_VARIANT
	else
		# Copy of choosecombo() routine in 'build/envsetup.sh'.
		choosetype $ANDROID_BUILD_TYPE
		chooseproduct $ANDROID_BUILD_PRODUCT
		choosevariant $ANDROID_BUILD_VARIANT
		set_stuff_for_environment
		printconfig
	fi

	$ANDROID_BUILD_POST_ENV

	unset ANDROID_BUILD_PRE_ENV
	unset ANDROID_BUILD_POST_ENV
	unset ANDROID_BUILD_TYPE
	unset ANDROID_BUILD_PRODUCT
	unset ANDROID_BUILD_VARIANT

	local BROWSER_DIR=$ANDROID_ROOT/vendor/lge/apps/Browser
	if [ ! -d $BROWSER_DIR ];then BROWSER_DIR=$ANDROID_ROOT/packages/apps/Browser; fi
	local PRODUCT_DIR=$ANDROID_ROOT/$(get_build_var PRODUCT_OUT)

	export APK_DIR=$PRODUCT_DIR/system/app
	export TEST_APK_DIR=$PRODUCT_DIR/data/app

	android_build_cscope_db $ANDROID_ROOT

	cd $BROWSER_DIR
}

function adb-uninstall()
{
	local TARGETS=$@
	if [ -z $TARGETS ];then
		adb shell pm list packages | cut -d ':' -f2
	else
		adb uninstall $TARGETS
	fi
}

function adb-install()
{
	local apk
	local apks

	[ -n $APK_DIR ] || APK_DIR=$PWD
	[ -n $TEST_APK_DIR ] || TEST_APK_DIR=$PWD

	if [ $# -eq 0 ];then
		apks=`zenity --title="Select APK to install"	\
				--file-selection						\
				--filename=$APK_DIR/*					\
				--multiple								\
				--separator=' '							\
				--file-filter="APK|*.apk"`
	else
		for apk in $@; do
			if [ ${apk##*.} != "apk" ];then
				apk=$apk.apk
			fi

			if [ -f $apk ];then
				apks="$apks $apk"
			elif [ -f $APK_DIR/$apk ];then
				apks="$apks $APK_DIR/$apk"
			elif [ -f $TEST_APK_DIR/$apk ];then
				apks="$apks $TEST_APK_DIR/$apk"
			else
				echo "'$apk' is not found -- skipped"
			fi
		done
	fi

	for apk in $apks; do
		_do_adb-install $apk;
	done
}

function _do_adb-install()
{
	adb install -r $@;
}

function _adb_install()
{
	local cur
	COMPREPLY=()

    _get_comp_words_by_ref cur

	if [ -n $APK_DIR ];then
		local apps=$( compgen -f -X '!*.apk' -- $APK_DIR/$cur )
		apps=${apps//$APK_DIR\//}
	fi

	if [ -n $TEST_APK_DIR ];then
		local testapps=$( compgen -f -X '!*.apk' -- $TEST_APK_DIR/$cur )
		testapps=${testapps//$TEST_APK_DIR\//}
	fi

	COMPREPLY=( $(echo "$apps $testapps" | sort) )
}
complete -F _adb_install -o dirnames -f -X '!*.apk' adb-install

function android_build_cscope_db()
{
	if [ -z $@ ];then
		echo "android_build_cscope_db | Error : pass android root path as parameter"
		return 1;
	fi

	export CSCOPE_DB=$@/cscope.out
	if [ -f $CSCOPE_DB ]; then
		echo "Android cscope DB already exist -- skippped."
		return 1;
	fi

	echo "Listing Android files ..."

	find "$@/bionic"		\
	"$@/bootable"			\
	"$@/build"				\
	"$@/dalvik"				\
	"$@/development"		\
	"$@/device"				\
	"$@/external"			\
	"$@/frameworks"			\
	"$@/hardware"			\
	"$@/packages"			\
	"$@/system"				\
	"$@/vendor"				\
	-name '*.java' -print -o	\
	-name '*.aidl' -print -o	\
	-name '*.hpp' -print -o		\
	-name '*.cpp'  -print -o	\
	-name '*.xml'  -print -o	\
	-name '*.mk'  -print -o		\
	-name '*.[chxsS]' -print > cscope.files

	echo "Listing Kernel files ..."
	find  kernel							\
	-path "kernel/arch/*" -prune -o			\
	-path "kernel/tmp*" -prune -o			\
	-path "kernel/Documentation*" -prune -o	\
	-path "kernel/scripts*" -prune -o		\
	-name "*.[chxsS]" -print >> cscope.files

	find "$@/kernel/arch/arm/include/"	\
	"$@/kernel/arch/arm/kernel/"			\
	"$@/kernel/arch/arm/common/"			\
	"$@/kernel/arch/arm/boot/"			\
	"$@/kernel/arch/arm/lib/"			\
	"$@/kernel/arch/arm/mm/"				\
	"$@/kernel/arch/arm/mach-msm/" -name "*.[chxsS]" -print >> cscope.files

	echo "Creating cscope DB ..."
	/usr/bin/cscope -b -q -k
	echo "Done"

	return 0;
}

function adb-key()
{

	# Reference 'http://developer.android.com/reference/android/view/KeyEvent.html'
	local key
	if [ $# -ge 1 ];then
		for key in $@;do
			local ev
			case $key in
				home)	ev=3	;;
				back)	ev=4	;;
				menu)	ev=82	;;
				center)	ev=23	;;
				down)	ev=20	;;
				left)	ev=21	;;
				right)	ev=22	;;
				up)		ev=19	;;
				enter)	ev=66	;;
				*)		ev=0	;; # KEYCODE_UNKNOWN
			esac
			adb shell input keyevent $ev
		done
	else
		local stty_backup=$( stty -g )
		stty -icanon min 1 time 0
		#trap "stty '$stty_backup'" INT
		echo -n "Enter key : "
		read -n1 key
		echo
		if [ $key = 0x1b ];then
			echo "Arrow key..."
		fi
		echo -n "$key" | xxd -p

	fi

}

function adb-tcpdump()
{
	echo "Press enter to capture";
	read
	echo "Press Ctrl+c to stop capture";
	adb shell tcpdump -w /data/dump.pcap -s 0
	adb pull /data/dump.pcap
	echo "    --> dump.pcap"
}

function ndk-at()
{
	local ndk_inst_dir
	case $# in
		0)
			ndk_inst_dir=`zenity --file-selection --directory  --width=200 --height=100 --title="Select directory to install NDK toolchain"`;;
		1)
			ndk_inst_dir=$1;;
		*)
			echo " Usage) ndk-at <target-directory>" >&2
      return 1
			;;
	esac

  local ANDROID_NDK=$ANDROID_TOOLKIT_DIR/ndk

	if [ -d $ndk_inst_dir										\
		-a -d $ndk_inst_dir/arm-linux-androideabi				\
		-a -d $ndk_inst_dir/bin 								\
		-a -d $ndk_inst_dir/include 							\
		-a -d $ndk_inst_dir/lib 								\
		-a -d $ndk_inst_dir/lib32 								\
		-a -d $ndk_inst_dir/libexec								\
		-a -d $ndk_inst_dir/sysroot								\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-addr2line	\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-ar		\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-as		\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-gcc		\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-g++		\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-gdb		\
		-a -x $ndk_inst_dir/bin/arm-linux-androideabi-ld		\
	];then
		echo "Using NDK toolkit which already installed at $ndk_inst_dir"
	else
		echo "Install NDK standalone toolchain at $ndk_inst_dir"
		$ANDROID_NDK/build/tools/make-standalone-toolchain.sh --arch=arm --platform=android-14 --install-dir=$ndk_inst_dir
	fi
	if [ -d $ndk_inst_dir -a -d $ndk_inst_dir/bin ];then
		if [ -v NDK ];then
			PATH=${PATH##$NDK/bin:}
		fi
		export NDK=$(readlink -f $ndk_inst_dir)
		export PATH=$NDK/bin:$PATH
	fi
}

#alias browser="adb shell am start com.android.browser"
#alias android-connect="mtpfs -o allow_other /media/OptimusPad"
#alias android-disconnect="fusermount -u /media/OptimusPad"

function _fzf_complete_adb_tap() {
  _fzf_complete "--multi --reverse" "$@" < <(
    adb shell 'uiautomator dump >&- && cat /sdcard/window_dump.xml' |
      xsltproc --path $__bashrc_dir/tools uiautomator.text.xslt -
  )
}

complete -F _fzf_complete_adb_tap -o default -o bashdefault adb tap
