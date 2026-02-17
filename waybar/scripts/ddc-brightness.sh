#!/usr/bin/env bash

# Get current brightness
get_brightness() {
    ddcutil getvcp 10 | sed -n 's/.*current value = *\([0-9]*\),.*/\1/p'
}

# Set brightness
set_brightness() {
    ddcutil --sleep-multiplier=1 setvcp 10 "$1" --noverify >/dev/null 2>&1
}

# If called with argument, set brightness
if [[ "$1" != "" ]]; then
    set_brightness "$2"
    exit 0
fi

# Otherwise open slider
current=$(get_brightness)

yad --scale \
    --min-value=0 \
    --max-value=100 \
    --value="$current" \
    --step=1 \
    --title="Monitor Brightness" \
    --print-partial \
    --on-top \
    --width=400 \
| while read value; do
    set_brightness "$value"
done

