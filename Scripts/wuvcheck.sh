# undervolt status display script for Polybar

status_file=~/Scripts/uvolt-status

if [[ ! -f "$status_file" ]]; then
    echo "{\"text\":\"ERR!",\"tooltip\":\"undervolting\",\"class\":\"error\"}"  # uvolt-status file not found
    exit 1
fi

status=$(cat "$status_file")

if [[ "$status" == "1" ]]; then
    echo "{\"text\":\"Y\",\"tooltip\":\"\",\"class\":\"yes\"}"  # Cyan
elif [[ "$status" == "0" ]]; then
    echo "{\"text\":\"N\",\"tooltip\":\"not undervolting\",\"class\":\"no\"}"   # Red
else
    echo "%{F#ffaa00}UNKNOWN%{F-}"  # Fallback
fi
