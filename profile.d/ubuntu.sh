#!/bin/bash

################################################################################
# Enable window resize with mouse right click
# for 12.04
gconftool-2 -s -t bool /apps/metacity/general/resize_with_right_button true
# and for 12.10/13.04
gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true

