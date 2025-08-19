#!/bin/bash

[[ -x $(which starship) ]] || return

eval "$(starship init bash)"
