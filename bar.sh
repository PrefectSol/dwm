#!/bin/bash

update() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=/tmp/${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
}

while true; do
    # Get memory usage percentage
    MEM=$(free | awk '/Mem/ {printf "%2.0f", $3/$2 * 100}')

    # Get CPU usage percentage
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2)}')

    # Get network traffic statistics
    rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
    tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)
    NET=$(printf "%4sB/%4sB" $(numfmt --to=iec $rx $tx))
    
    # Get keyboard layout and caps status
    CAPS=$(xset -q | grep "Caps Lock" | awk '{print $4}')
    LAYOUT=$(xset -q | grep LED | awk '{if(substr($10,5,1)==1) printf "ru"; else printf "en"}')
    if [ "$CAPS" = "on" ]; then
        LAYOUT=$(echo "$LAYOUT" | tr '[:lower:]' '[:upper:]')
    fi

    # Get current date and time in AM/PM format
    DATETIME=$(date "+%I:%M:%S %p - %a, %d %b %Y")

    # Set colors using status2d
    BLUE="^b#7aa2f7^^c#1a1b26^"
    SEPARATOR="^c#444444^"
    RESET="^d^"

    # Combine all information with colored blocks
    STATUS=" mem: ${MEM}% ${SEPARATOR}|${RESET} cpu: ${CPU}% ${SEPARATOR}|${RESET} net: ${NET} ${SEPARATOR}|${RESET} ${LAYOUT} ${SEPARATOR}|${RESET} ${DATETIME} ${RESET}"

    # Set root window name
    xsetroot -name "$STATUS"

    # Wait before next update (0.5 seconds)
    sleep 0.5
done
