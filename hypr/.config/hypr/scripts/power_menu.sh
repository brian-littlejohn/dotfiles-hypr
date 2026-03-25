#!/bin/bash

SELECTION="$(printf "󰌾 Lock\n󰤄 Suspend\n󰍃 Log out\n Reboot\n Reboot to UEFI\n󰐥 Shutdown" | fuzzel --dmenu -a top-right -l 6 -w 18 -p "Select an option: ")"

confirm_action() {
    local action="$1"
    CONFIRMATION="$(printf "No\nYes" | fuzzel --dmenu -a top-right -l 2 -w 18 -p "$action?")"
    [[ "$CONFIRMATION" == *"Yes"* ]]
}

case $SELECTION in
    *"󰌾 Lock"*)
        hyprlock;;
    *"󰤄 Suspend"*)
        if confirm_action "Suspend"; then
            systemctl suspend
        fi;;
    *"󰍃 Log out"*)
        if confirm_action "Log out"; then
            command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit
        fi;;
    *" Reboot"*)
        systemctl reboot;;        
   *" Reboot to UEFI"*)
        if confirm_action "Reboot to UEFI"; then
            systemctl reboot --firmware-setup
        fi;;
    *"󰐥 Shutdown"*)
       # if confirm_action "Shutdown"; then
            systemctl poweroff
       # fi;;
esac
