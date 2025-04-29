#!/usr/bin/env bash
# check-usbguard.sh

# check if usbguard is running
if systemctl is-active --quiet usbguard; then
  echo '{"text":"GTFO","tooltip":"USBGuard active – USB locked down","class":"no"}'
else
  echo '{"text":"uhoh","tooltip":"USBGuard NOT running – USB wide open!","class":"yes"}'
fi
