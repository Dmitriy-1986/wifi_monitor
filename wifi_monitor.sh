#!/bin/bash

SSID="Zaporigia2"
INTERFACE="wlp4s0"
CHECK_INTERVAL=7  # интервал проверки в секундах
PING_HOST="8.8.8.8"  # проверочный адрес

RED_BOLD='\e[1;31m'
GREEN_BOLD='\e[1;32m'
PURPLE_BOLD='\e[1;35m'
RESET='\e[0m'

echo -e "${PURPLE_BOLD}Wi-Fi монитор запущен для сети: $SSID на интерфейсе $INTERFACE${RESET}"

while true; do
    if ping -I "$INTERFACE" -c 1 -W 2 "$PING_HOST" > /dev/null; then
        echo -e "$(date): ${GREEN_BOLD}Интернет работает${RESET}"
    else
        echo -e "$(date): ${RED_BOLD}Интернет не работает. Переподключение...${RESET}"
        sudo nmcli device disconnect "$INTERFACE"
        sleep 2
        sudo nmcli connection up "$SSID" ifname "$INTERFACE"
        sleep 5
    fi
    sleep "$CHECK_INTERVAL"
done
