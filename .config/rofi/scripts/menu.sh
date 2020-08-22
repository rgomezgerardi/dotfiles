#!/bin/bash

selection=$(rofi -dmenu -p "Menu: ")
[[ -z $selection]] && exit
