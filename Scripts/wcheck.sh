#!/usr/bin/env bash

voltage=$(cat /sys/class/power_supply/BAT0/voltage_now)
current=$(cat /sys/class/power_supply/BAT0/current_now)

wattage=$(echo "scale=2; $voltage * $current / 1000000000000" | bc)

# Strip leading zeroes if needed
clean=$(echo "$wattage" | sed 's/^0*//')

# Choose style
if (( $(echo "$wattage < 10" | bc -l) )); then
  # primary color
  echo "%{F#00ff31}$clean"
elif (( $(echo "$wattage < 20" | bc -l) )); then
  # secondary color (grayish)
  echo "%{F#f6ff00}$clean"
else
  # alert color (red)
  echo "%{F#ff0000}$clean"
fi
