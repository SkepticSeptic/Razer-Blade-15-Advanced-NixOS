sleep 2
pkill waybar
waybar -c /home/skep/.config/waybar/left.json &
sleep 0.2
waybar &
sleep 0.2
waybar -c /home/skep/.config/waybar/bottom.json &


