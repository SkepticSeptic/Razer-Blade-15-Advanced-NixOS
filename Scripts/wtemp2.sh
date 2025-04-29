#!/usr/bin/env bash
# Waybar: CPU0 temperature widget

ZONE="/sys/class/thermal/thermal_zone8/temp"   # adjust if your zone index differs
LABEL="CPU0"

temp=$(( $(< "$ZONE") / 1000 ))

# pick a class for CSS theming
if (( temp < 50 )); then
  class="low"
elif (( temp < 80 )); then
  class="medium"
else
  class="high"
fi

# JSON for Waybar
echo "{\"text\":\"${temp}°C\",\"tooltip\":\"${LABEL} temperature: ${temp}°C\",\"class\":\"${class}\"}"
