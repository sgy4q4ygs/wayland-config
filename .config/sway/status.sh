#!/bin/bash

while true; do

    status_string=$([ $(date +'%l') -lt 10 ] && date +'%D,%l:%M:%S %p' || date +'%D, %I:%M:%S %p')

    if acpi -b > /dev/null 2>&1; then
        BATTERY_CAPACITY=$(acpi -b | awk '/(Disc|C)harging/{print $4}' | tr -d ',%')
        status_string="Battery: $BATTERY_CAPACITY% | $status_string"
    fi

    ETH_INTERFACE_NAME=$(ip link show | awk '/[1-9]+: eth|enp|enx/ {print $2}' | sed 's/://')
    WIFI_INTERFACE_NAME=$(ip link show | awk '/[1-9]+: wlan|wifi|wlp/ {print $2}' | sed 's/://')

    if ip addr show "$ETH_INTERFACE_NAME" > /dev/null 2>&1; then
        ETH_IP_ADDR=$(ip addr show "$ETH_INTERFACE_NAME" | awk '/inet / { ip = ip ? ip ", " $2 : $2 } END { print ip }')
        status_string="$ETH_INTERFACE_NAME: $ETH_IP_ADDR | $status_string"
    fi

    if ip addr show "$WIFI_INTERFACE_NAME" > /dev/null 2>&1 && iwgetid -r > /dev/null 2>&1; then
        WIFI_IP_ADDR=$(ip addr show "$WIFI_INTERFACE_NAME" | awk '/inet / {print $2}')
        WIFI_SSID=$(iwgetid -r)
        WIFI_FREQ=$(iwgetid --freq | sed 's/.*:\(.*\)/\1/')
        WIFI_SIGNAL=$(awk 'NR==3 {print $3}' /proc/net/wireless | sed 's/\..*//')
        status_string="$WIFI_INTERFACE_NAME: $WIFI_IP_ADDR, $WIFI_SSID, $WIFI_FREQ, Strength: $WIFI_SIGNAL% | $status_string"
    fi

    if [ -d "/sys/class/backlight/intel_backlight" ]; then
        BRIGHTNESS=$(brightnessctl -m | awk -F',' '{print $4}' | sed 's/%//')
        status_string="Backlight: $BRIGHTNESS% | $status_string"
    fi

    if amixer get Master | grep -q '\[on\]'; then
        AUDIO_VOLUME=$(amixer get Master | awk -F'[][]' 'END{ print $2 }')
        status_string="Audio: $AUDIO_VOLUME | $status_string"
    fi

    echo "$status_string"

    sleep 0.25
done
