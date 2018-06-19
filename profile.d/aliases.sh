#!/bin/bash
# vim: syntax=sh

# some more ls aliases
# This alias prevent colirized output
alias ls='ls --show-control-char'
alias l='ls -ClNFh --ignore={GPATH,GTAGS,GRTAGS,gtags.files}'
alias ll='ls -ClNFh'
alias la='ls -AlNFh'

alias rm='rm -iv'
alias mv='mv -iv'
alias cp='cp -iv'

alias ..='cd ..'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias hexdump='od -t x1z'
