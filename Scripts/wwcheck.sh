#!/usr/bin/env bash
# waybar watt check
voltage=$(cat /sys/class/power_supply/BAT0/voltage_now)
current=$(cat /sys/class/power_supply/BAT0/current_now)

# Calculate wattage
wattage=$(echo "scale=2; $voltage * $current / 1000000000000" | bc)

# Strip leading zeroes (optional)
clean=$(echo "$wattage" | sed 's/^0*//')

# Determine class for styling
if (( $(echo "$wattage < 10" | bc -l) )); then
  class="low"
elif (( $(echo "$wattage < 20" | bc -l) )); then
  class="medium"
else
  class="high"
fi

# Output JSON for Waybar
echo "{\"text\": \"$clean\", \"tooltip\": \"Current power usage: $clean watts\", \"class\": \"$class\"}"
