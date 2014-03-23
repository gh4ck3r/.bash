# Synaptics TouchPad driver settings
if [[ synclient=$(type -tfp synclient) && -x $synclient ]];then
  if [[ $(xinput -list | grep "Synaptics TouchPad") ]];then
    # 2 finger scroll
    synclient HorizTwoFingerScroll=1 VertTwoFingerScroll=1 EmulateTwoFingerMinZ=40 EmulateTwoFingerMinW=8 2>/dev/null
    # Palm rejection
    synclient PalmDetect=1 PalmMinWidth=6 PalmMinZ=100 2>/dev/null
  fi
fi
