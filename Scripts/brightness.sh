#!/usr/bin/env bash

# Get current brightness
current=$(brightnessctl get)

# Calculate percent (max = 19200)
percent=$(( current * 100 / 19200 ))

# Output only the number
echo "$percent"
