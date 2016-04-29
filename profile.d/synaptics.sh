# Synaptics TouchPad driver settings

# Skip if the session is on ssh
[[ -v SSH_CLIENT ]] && return

type -t synclient >/dev/null 2>&1 || return

xinput -list 2>/dev/null |
  grep --fixed-strings \
    -e "Synaptics TouchPad" \
    -e "Elantech Touchpad" >/dev/null 2>&1 || return

# 2 finger scroll
synclient HorizTwoFingerScroll=1 VertTwoFingerScroll=1 EmulateTwoFingerMinZ=40 EmulateTwoFingerMinW=8 2>/dev/null
# Palm rejection
synclient PalmDetect=1 PalmMinWidth=5 PalmMinZ=10 2>/dev/null
# Tap with 3 finger emulates middle click
#synclient ClickFinger3=2 2>/dev/null
