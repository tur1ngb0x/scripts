#!/usr/bin/env bash

# colors, 1; bold, 7; reverse
Cred="\e[91;1;7m"
Cgreen="\e[92;1;7m"
Cyellow="\e[93;1;7m"
Cblue="\e[94;1;7m"
Cmagenta="\e[95;1;7m"
Ccyan="\e[96;1;7m"
Cwhite="\e[97;1;7m"
Creset="\e[0m"

#function ps1_datime { printf '%s' "$(date +'%Y-%m-%d %a %H:%M:%S')"; }
#function ps1_status { printf '%s' "${?}"; }
#function ps1_git { printf '%s' "$(git branch --no-color --show-current 2> /dev/null)"; }
function ps1_dir { printf "${Cblue} %s ${Creset}" "$(pwd -L)"; }
function ps1_sign { printf "%s" "$"; }
function ps1_userhost { printf '\e[92;1;7m %s@%s \e[0m' "$(id --user --name)" "$(hostname --short)"; }
function ps1_git {
	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
		git_branch="$(git --no-pager branch --no-color --show-current)"
		git_status="$(git --no-pager status --porcelain | wc -l)"
		if [[ "${git_status}" -eq 0 ]]; then
			printf "${Cyellow} %s ${Creset}" "${git_branch}"
		else
			printf "${Cyellow} %s [%s] ${Creset}" "${git_branch}" "${git_status}"
		fi
	fi
}

# prompt
PS1='$(ps1_userhost) $(ps1_dir) $(ps1_git)\n $(ps1_sign) '

# title
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
