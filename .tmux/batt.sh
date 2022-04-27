#!/bin/bash

macos() {
	percent=$(pmset -g batt | grep [0-9][0-9]% | awk 'NR==1{print$3}' | cut -c1-3)
	printf "$percent%%\n"
}

linux() {
	percent=$(upower -i `upower -e | grep 'BAT'` | grep 'percentage' | awk '{ print $2 };')
	printf "$percent%%\n"
}
# Fail out for other OSes
if [ -z $(echo $OSTYPE | grep "darwin") ]; then
	linux
else
	macos
fi

