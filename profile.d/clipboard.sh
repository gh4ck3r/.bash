#!/bin/bash

# e.g) copy output of ls to clipboard
#  $ ls | clipboard

if type -t xclip 2>&1 >/dev/null ;then
  alias clipboard='(xclip && echo -n $(xclip -o) | xclip -selection clipboard)';
else
  echo "xclip is not installed";
fi
