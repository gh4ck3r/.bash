# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=4000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set prompt using terminal ANSI code
__PS1_PREFIX='\[\e[01;32m\][\u@\h'
__PS1_SUFFIX=' \[\e[36;1m\]\W\[\e[01;32m\]]\$\[\e[0m\] '
PS1=$__PS1_PREFIX$__PS1_SUFFIX
export PS4='+${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PROMPT_COMMAND='echo -ne "\e]0;$USER@$HOSTNAME: ${PWD/$HOME/~}\a"'
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

__bashrc_dir=$(dirname $(readlink -e ${BASH_SOURCE[0]}))
for f in $__bashrc_dir/profile.d/*.sh;do
	if [ -r $f ];then . $f;fi
done

# for Korean support on rhythmbox
if [ -x /usr/bin/rhythmbox ];then
	GST_TAG_ENCODING=cp949
	export GST_TAG_ENCODING
fi

export GREP_COLORS='fn=01;36:ln=01;32'
