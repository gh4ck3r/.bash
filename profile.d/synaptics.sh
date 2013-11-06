# Synaptics TouchPad driver settings
if [ synclient=$(which synclient) -a -x $synclient];then
	# 2 finger scroll
	synclient HorizTwoFingerScroll=1 VertTwoFingerScroll=1 EmulateTwoFingerMinZ=40 EmulateTwoFingerMinW=8
fi
