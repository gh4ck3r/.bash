#!/bin/bash

[[ -x $(which bat) ]] || return

alias cat='bat --paging=never'

export MANROFFOPT="-c" # https://github.com/sharkdp/bat/issues/652
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
