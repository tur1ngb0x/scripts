#!/usr/bin/env bash

if [[ "${#}" -eq 0 ]]; then
	echo 'syntax:'
	echo 'print <path>'
	echo 'print /etc/os-release'
	exit 1
elif command -v batcat &>/dev/null; then
	command batcat --set-terminal-title --style full "${@}"
elif command -v bat &>/dev/null; then
	command bat --set-terminal-title --style full "${@}"
elif command -v cat &>/dev/null; then
	command cat -n "${@}"
else
	echo 'bat/cat not found'
	exit 1
fi
