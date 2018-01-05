#!/bin/bash

type -t gconftool-2 >/dev/null 2>&1 || return;
################################################################################
# Enable window resize with mouse right click
# for 12.04
gconftool-2 -s -t bool /apps/metacity/general/resize_with_right_button true
# and for 12.10/13.04
if [[ -x $(which gsettings) ]];then
  # Enable window resize with mouse right click
  gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
  # Enable minimize/restore window with unity icon
  gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
fi
