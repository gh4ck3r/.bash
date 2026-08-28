#!/bin/bash

[[ -x $(which starship) ]] || return

# config: ~/.config/starship.toml
eval "$(starship init bash)"
