#!/usr/bin/env bash

# Read temps
CPU0=$(( $(< /sys/class/thermal/thermal_zone7/temp) / 1000 ))
CPU1=$(( $(< /sys/class/thermal/thermal_zone8/temp) / 1000 ))

# Function to color temp based on threshold
color_temp() {
  local temp=$1
  if [ "$temp" -lt 50 ]; then
    echo "%{F#00ff31}$temp"
  elif [ "$temp" -lt 80 ]; then
    echo "%{F#f6ff00}$temp"
  else
    echo "%{F#ff0000}$temp"
  fi
}

C0=$(color_temp "$CPU0")
C1=$(color_temp "$CPU1")

# Output with color reset between
echo "$C0%{F-} | $C1"
