#!/bin/bash
# vim: syntax=sh

# some more ls aliases
[[ "$TERM" =~ .*color ]] || alias ls='ls -F'
# This alias prevent colirized output
alias ls='ls --show-control-char'
alias l='ls -ClNh --ignore={GPATH,GTAGS,GRTAGS,gtags.files}'
alias ll='ls -ClNh'
alias la='ls -AlNh'

alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'

alias ..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

[[ $(type -t hexdump) == file ]] || alias hexdump='od -t x1z'

alias tunnel='ssh -fnNT -o ServerAliveInterval=60 -o ExitOnForwardFailure=yes -L'
