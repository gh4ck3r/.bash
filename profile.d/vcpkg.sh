#!/bin/bash

[[ -x $(which vcpkg) ]] || return

source $(dirname $(realpath $(which vcpkg)))/scripts/vcpkg_completion.bash
