#!/bin/bash

################################################################################
# Enable window resize with mouse right click
# for 12.04
if type -t gconftool-2 >/dev/null 2>&1;then
  gconftool-2 -s -t bool /apps/metacity/general/resize_with_right_button true
fi
# and for 12.10 ~ 18.04
if [[ -x $(which gsettings) ]];then
  # Enable window resize with mouse right click
  gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true

  # Enable minimize/restore window with unity icon
  version=$(grep DISTRIB_RELEASE /etc/lsb-release | cut -f2 -d=)
  if (( $(echo "18.04 <= $version" | bc -l) ));then
    gsettings set org.gnome.shell.extensions.dash-to-dock click-action 'minimize'
  else
    gsettings set org.compiz.unityshell:/org/compiz/profiles/unity/plugins/unityshell/ launcher-minimize-window true
  fi
fi
