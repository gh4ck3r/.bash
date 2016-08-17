#!/bin/bash

[[ -x $(which sdcv) ]] || return;

[[ -x $(which colorit) ]] && SDCV_PAGER="colorit | ";
SDCV_PAGER+="less -R"

export SDCV_PAGER
alias dict=sdcv
