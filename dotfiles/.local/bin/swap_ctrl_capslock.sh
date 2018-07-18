#!/bin/bash

#/usr/bin/setxkbmap -option ctrl:swapcaps

# setting values is obtained from '$ gnome-tweak-tool -v'
cmd_get="gsettings get org.gnome.desktop.input-sources xkb-options"
cmd_set="gsettings set org.gnome.desktop.input-sources xkb-options"

#sudo -u cpark $cmd_get >> /tmp/asdf
value_swap=ctrl:swapcaps
declare -a values=( $($cmd_get | tr -d "[]',") )

#echo "${values[*]}" >> /tmp/asdf
#for ((idx=0; idx < ${#values[*]};++idx));do
#  echo "$idx : ${values[$idx]}" >> /tmp/asdf
#done

if [[ "${values[@]}" == *$value_swap* ]];then
  for ((idx=0; idx < ${#values[*]};++idx));do
    if [[ ${values[$idx]} == $value_swap ]];then
      if [[ $# == 0 ]] || [[ $1 == "restore" ]]; then
        unset values[$idx]
      fi
      break;
    fi
  done
else
  if [[ $# == 0 ]] || [[ $1 == "swap" ]]; then
    values[${#values[@]}]=$value_swap;
  fi
fi

#for ((idx=0; idx < ${#values[*]};++idx));do
#  echo "$idx : ${values[$idx]}" >> /tmp/asdf
#done

value="["
for ((idx=0; idx < ${#values[*]};++idx));do
  value+="'${values[$idx]}', "
done

value="${value::-2}]"

#echo "$value $1" >> /tmp/asdf

$cmd_set "$value"
