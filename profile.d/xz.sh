#!/bin/bash

[[ -x $(which xz) ]] || return

# for maximum CPU utilization
export XZ_DEFAULTS="-T 0"
