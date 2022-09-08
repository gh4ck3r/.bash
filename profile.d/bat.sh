#!/bin/bash

[[ -x $(which bat) ]] || return

alias cat='bat --paging=never'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
