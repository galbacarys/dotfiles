#!/bin/bash

# Fail out for other OSes
if [ -z $(echo $OSTYPE | grep "darwin") ]; then
	echo "??%"
fi

percent=$(pmset -g batt | grep [0-9][0-9]% | awk 'NR==1{print$3}' | cut -c1-3)
printf "$percent%%\n"
