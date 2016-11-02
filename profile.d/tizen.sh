#!/bin/bash

TIZEN_SDK_HOME=$HOME/tizen-sdk
[[ -d $TIZEN_SDK_HOME ]] || return;

export PATH+=":$TIZEN_SDK_HOME/tools:$TIZEN_SDK_HOME/tools/ide/bin"
