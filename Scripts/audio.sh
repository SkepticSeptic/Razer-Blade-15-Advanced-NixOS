#!/usr/bin/env bash

# Get volume and mute status
volume_info=$(pactl get-sink-volume @DEFAULT_SINK@)
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@)

# Extract the first volume percentage (typically left channel)
volume=$(echo "$volume_info" | awk '{print $5}' | head -n1)

if echo "$mute_status" | grep -q "yes"; then
    echo "X%"
else
    echo "$volume"
fi
