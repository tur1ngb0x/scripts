#!/usr/bin/env bash

# usage function
usage()
{
	cat << EOF
DESCRIPTION
    Check system and user logs
SYNTAX
    $ ${0##*/} <scope>
USAGE
    $ ${0##*/} system
    $ ${0##*/} user
    $ ${0##*/} all
EOF
}

# header function
text() { tput rev; printf "\n %s \n" "${1}"; tput sgr0; }

# scope of getting logs
log_scope="${1}"

# types of logs
logs_system(){
	log_journalctl="journalctl --system --no-pager --catalog --boot 0 --priority 3"
	text "${log_journalctl}"
	eval "${log_journalctl}"

	log_systemd_blame="systemd-analyze --system --no-pager blame"
	text "${log_systemd_blame}"
	eval "${log_systemd_blame}"

	log_systemd_plot="systemd-analyze --system --no-pager plot > ${HOME}/systemd-analyze-plot-system.svg"
	text "${log_systemd_plot}"
	eval "${log_systemd_plot}"
}

logs_user(){
	log_journalctl="journalctl --user --no-pager --catalog --boot 0 --priority 3"
	text "${log_journalctl}"
	eval "${log_journalctl}"

	log_systemd_blame="systemd-analyze --user --no-pager blame"
	text "${log_systemd_blame}"
	eval "${log_systemd_blame}"

	log_systemd_plot="systemd-analyze --user --no-pager plot > ${HOME}/systemd-analyze-plot-user.svg"
	text "${log_systemd_plot}"
	eval "${log_systemd_plot}"
}

logs_all(){
	logs_system
	logs_user
}

# begin script from here

# if no arguments are provided, exit
if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

if [[ "${log_scope}" == 'system' ]]; then
	logs_system
elif [[ "${log_scope}" == 'user' ]]; then
	logs_user
elif [[ "${log_scope}" == 'all' ]]; then
	logs_all
else
	usage
	exit
fi
