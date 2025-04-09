# undervolt status display script for Polybar

status_file=~/Scripts/uvolt-status

if [[ ! -f "$status_file" ]]; then
    echo "%{F#ffaa00}UNKNOWN%{F-}"  # Orange-ish for error
    exit 1
fi

status=$(cat "$status_file")

if [[ "$status" == "1" ]]; then
    echo "%{F#00ffff}UVLT%{F-}"  # Cyan
elif [[ "$status" == "0" ]]; then
    echo "%{F#ff0000}STD%{F-}"   # Red
else
    echo "%{F#ffaa00}UNKNOWN%{F-}"  # Fallback
fi
