# Synaptics TouchPad driver settings

# Skip if the session is on ssh
if [[ -z "$SSH_CLIENT" ]] && [[ -x $(type -tfp synclient) ]];then
  if xinput -list | grep -e "Synaptics TouchPad" -e "Elantech Touchpad" >/dev/null 2>&1 ;then
    # 2 finger scroll
    synclient HorizTwoFingerScroll=1 VertTwoFingerScroll=1 EmulateTwoFingerMinZ=40 EmulateTwoFingerMinW=8 2>/dev/null
    # Palm rejection
    synclient PalmDetect=1 PalmMinWidth=6 PalmMinZ=100 2>/dev/null
    # Tap with 3 finger emulates middle click
    synclient ClickFinger3=2 2>/dev/null
  fi
fi
