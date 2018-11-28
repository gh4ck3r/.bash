#!/bin/bash

[[ $(uname -o) == Msys ]] && return; # Skip on windows

# e.g) copy output of ls to clipboard
#  $ ls | clipboard

if type -t xclip 2>&1 >/dev/null; then
  alias clipboard='(xclip && echo -n "$(xclip -o)" | xclip -selection clipboard)';
elif type -t termux-clipboard-set 2>&1 >/dev/null; then
  alias clipboard='termux-clipboard-set';
else
  echo "clipboard(xclip) is not installed";
fi
