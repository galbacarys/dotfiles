#!/bin/bash

macos() {
	uptime | awk -F'load average{s}*:' '{print $2}'
}

linux () {
	cat /proc/loadavg | awk '{ print $1 " " $2 " " $3 }'
}

if [ -z $(echo $OSTYPE | grep "darwin") ]; then
	linux
else
	macos
fi
