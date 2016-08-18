#!/bin/bash

[[ -x $(which sdcv) ]] || return;

SDCV_PAGER="$__bashrc_dir/tools/colorit | ";
SDCV_PAGER+="less -R"

export SDCV_PAGER
alias dict=sdcv
