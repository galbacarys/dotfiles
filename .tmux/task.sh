#!/bin/bash

main() {
	task_id=$(task +ACTIVE ids | cut -f1 -d' ')
	if [ -z $task_id ]; then
		echo "No active tasks"
		exit 0
	fi
	task_desc=$(task _get ${task_id}.description)

	echo "${task_id}:${task_desc:0:20}"
}

if type task >/dev/null 2>&1; then
	main
fi
