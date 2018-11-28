#!/bin/bash

# Termux and MINGW don't need font-awesome
[[ $(uname -o) =~ (Android|Msys) ]] && return;

# Check & install font-awesome if necessary
function +FontAwesome()
{
  unset -f +FontAwesome
  (fc-list | grep fontawesome-webfont\.ttf >/dev/null 2>&1) && return

  echo "Font Awesome is not installed!"

  if im_sudoer;then
    local apt_get_cmd="sudo apt-get install fonts-font-awesome"
    echo "Trying to install via '$apt_get_cmd'"
    $apt_get_cmd
  else
    local download_url="https://github.com/FortAwesome/Font-Awesome/raw/master/fonts/fontawesome-webfont.ttf"
    local font_dir=~/.local/share/fonts;

    mkdir -p $font_dir &&
    wget -O $font_dir/$(basename $download_url) $download_url &&
    fc-cache -v
  fi
}

if ! +FontAwesome; then
  echo "Failed to install Font Awesome!"
  return
fi
