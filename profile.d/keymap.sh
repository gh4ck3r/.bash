#!/bin/bash
# vim: syntax=sh

[[ -v DISPLAY ]] || return

# This is for Ubuntu 14.04 on my own gram
[[ $HOSTNAME == "gh4ck3r" && $(grep DISTRIB_RELEASE= /etc/lsb-release | cut -f2 -d'=') = "14.04" ]] ||
# This is for Ubuntu 18.04 on my corp ws with hhkb
[[ $HOSTNAME == "cpark1-ws" && $(grep DISTRIB_RELEASE= /etc/lsb-release | cut -f2 -d'=') = "18.04" ]] ||
  return

if type -t xmodmap >/dev/null 2>&1; then
  xmodmap -e 'keycode 108 = Hangul' -e 'keycode 105 = Hangul_Hanja'
  while read mod_key rest; do
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
  done < <(xmodmap -pm) # ProcessSubstitution
  # For more detail -> http://tldp.org/LDP/abs/html/process-sub.html
else
  echo "xmodmap is not found --> Check hangul/hanja key remapping"
fi

if type -t gsettings >/dev/null 2>&1; then
  [[ $HOSTNAME == "cpark1-ws" && $(grep DISTRIB_RELEASE= /etc/lsb-release | cut -f2 -d'=') = "18.04" ]] ||
    gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "['Hangul']"
else
  echo "gsetting is not found --> Check hangul key binding"
fi
