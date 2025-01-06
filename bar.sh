#!/bin/bash

while true; do
    BAR_BG="^b#2a2a2a^"
    
    GRAY3="#bbbbbb"
    GRAY4="#eeeeee"
    CYAN="#005577"
    
    MEMORY=$(free -h | awk '/^Mem/ {printf "^c'$CYAN'^RAM ^c'$GRAY4'^%s/%s", $3, $2}')
    
    NET=$(ifstat -i wlan0 1 1 | awk 'NR==3 {printf "^c'$CYAN'^NET ^c'$GRAY4'^%.1fK/%.1fK", $1, $2}')
    
    LAYOUT=$(xset -q | grep LED | awk '{if(substr($10,5,1)==1) \
        printf "^c'$CYAN'^KB ^c'$GRAY4'^RU"; \
        else printf "^c'$CYAN'^KB ^c'$GRAY4'^EN"}')
    
    DATETIME=$(date "+^c'$CYAN'^%H:%M ^c'$GRAY4'^%d.%m.%Y")
    
    STATUS="$BAR_BG $MEMORY ^c$GRAY3^| $NET ^c$GRAY3^| $LAYOUT ^c$GRAY3^| $DATETIME ^b#000000^"
    
    xsetroot -name "$STATUS"
    sleep 1
done
