#!/bin/bash
# vim: syntax=sh

# This is only for Ubuntu 14.04 on my own gram
if [[ $(uname -n) = "gh4ck3r" && $(grep DISTRIB_RELEASE= /etc/lsb-release | cut -f2 -d'=') = "14.04" ]];then
  if which xmodmap > /dev/null 2>&1; then
    xmodmap -e 'keycode 108 = Hangul'
    xmodmap -e 'keycode 105 = Hangul_Hanja'
    xmodmap -pm | while read mod_key rest; do
      case "$mod_key" in
        "mod1")
          [[ "$rest" = *Hangul* ]] &&
              xmodmap -e 'remove mod1 = Hangul'
          ;;
        "control")
          [[ "$rest" = *Hangul_Hanja* ]] &&
              xmodmap -e 'remove control = Hangul_Hanja'
          ;;
        *);;
      esac
    done
  else
    echo "xmodmap is not found --> Check hangul/hanja key remapping"
  fi

  if which gsettings > /dev/null 2>&1; then
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['Hangul']"
  else
    echo "gsetting is not found --> Check hangul key binding"
  fi
fi
