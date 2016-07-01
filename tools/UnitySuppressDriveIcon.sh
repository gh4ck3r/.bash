#!/bin/bash

# Register this to crontab or StartUp Application

KEY="com.canonical.Unity.Devices blacklist"

gsettings monitor $KEY | while read key unused val; do
  [[ $val = '[]' ]] && gsettings set $KEY "['-']";
done
