#!/bin/bash

# Function to calculate network traffic
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
    # Get memory usage
    MEMORY=$(free -h | awk '/^Mem/ {printf "Mem %s/%s", $3, $2}')
    
    # Get network traffic statistics
    rx=$(update /sys/class/net/[ew]*/statistics/rx_bytes)
    tx=$(update /sys/class/net/[ew]*/statistics/tx_bytes)
    NET=$(printf "Net(d/u) %4sB/%4sB" $(numfmt --to=iec $rx $tx))
    
    # Get keyboard layout
    LAYOUT=$(xset -q | grep LED | awk '{if(substr($10,5,1)==1) printf "ru"; else printf "en"}')
    
    # Get current date and time
    DATETIME=$(date "+%a, %d %b %H:%M:%S")
    
    # Combine all information
    STATUS=" [$MEMORY] [$NET] [$LAYOUT] [$DATETIME] "
    
    # Set root window name
    xsetroot -name "$STATUS"
    
    # Wait before next update
    sleep 2
done
