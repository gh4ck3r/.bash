#!/bin/bash

[[ -r ~/.fzf.bash ]] && source ~/.fzf.bash

export FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line,ctrl-f:page-down,ctrl-b:page-up'
[[ -x $(which bat) ]] && FZF_DEFAULT_OPTS+=' --preview "bat --style=numbers --color=always --line-range :500 {}"'
