#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
# polybar-msg cmd quit
# Otherwise you can use the nuclear option:
pkill polybar

# Launch bar1 and bar2
echo "Launching without logs (polybar -q)"
polybar -q

echo "Bars launched..."
