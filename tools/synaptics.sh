#!/bin/bash

# Synaptics TouchPad driver settings

type -t synclient >/dev/null 2>&1 || return

# Gram : Elantech Touchpad
# XPS13 : DLL075B:01 06CB:76AF Touchpad
xinput -list 2>/dev/null |
  grep --fixed-strings "
Synaptics TouchPad
Elantech Touchpad
DLL075B:01 06CB:76AF Touchpad
" >/dev/null 2>&1 || return

# 2 finger scroll
synclient HorizTwoFingerScroll=1 VertTwoFingerScroll=1 EmulateTwoFingerMinZ=40 EmulateTwoFingerMinW=8 2>/dev/null
# for XPS13 horizontal natural scroll
synclient HorizScrollDelta=-27
# Palm rejection
synclient PalmDetect=1 PalmMinWidth=5 PalmMinZ=10 2>/dev/null
# Ignore Left/Right edge since those're used to be clicked by palm
if [[ $(synclient -V) =~ ^1\.9(.*)?$ ]]; then
  # Apply values of 'LeftEdge' and 'RightEdge' to 'AreaLeftEdge' and
  # 'AreaRightEdge' respectively
  if [[ $(hostname) = 'xps13' ]];then
    # id 13 comes from xinput -list
    id=$(xinput list --id-only "DLL075B:01 06CB:76AF Touchpad");
    xinput disable $id
    xinput enable $id
    synclient AreaLeftEdge=200 AreaRightEdge=1000 2>/dev/null
  else
    synclient $(synclient | grep -e '\<\(Left\|Right\)Edge\>' | sed -e 's/\(\w\+\)\s*=\s*\([0-9]\+\)/Area\1=\2/') 2>/dev/null
  fi
else
  # AreaLeftEdge and AreaRightEdge should be specified in percent from
  # synaptics 1.9 and later(See man page for detail)
  echo "Failed to ignore left/right edge area of touchpad" >&2
fi
# Tap with 3 finger emulates middle click
synclient ClickFinger3=2 2>/dev/null
