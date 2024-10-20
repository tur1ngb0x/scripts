#!/usr/bin/env bash

# colors
# bold-1, dim-2, italic-3, underline-4, blink-5, reverse-7, hidden-8, strikethrough-9
# example - ;1 for bold, 1;7; for bold reverse
declare -r Cgrey="\e[90m"
declare -r Cred="\e[91m"
declare -r Cgreen="\e[92m"
declare -r Cyellow="\e[93m"
declare -r Cblue="\e[94m"
declare -r Cmagenta="\e[95m"
declare -r Ccyan="\e[96m"
declare -r Cwhite="\e[97m"
declare -r CwhiteR="\e[97;7m"
declare -r Creset="\e[0m"

#function ps1_datime { printf '%s' "$(date +'%Y-%m-%d %a %H:%M:%S')"; }
#function ps1_status { printf '%s' "${?}"; }
#function ps1_git { printf '%s' "$(git branch --no-color --show-current 2> /dev/null)"; }
function ps1_dir { printf "${Cwhite}%s${Creset}" "$(pwd -L)"; }
function ps1_sign { printf "${Cwhite}%s${Creset}" "\$"; }
function ps1_userhost { printf "${Cwhite}%s@%s${Creset}" "$(id --user --name)" "$(hostname --short)"; }

function ps1_git {
	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
		local git_status="$(git --no-pager status --porcelain | wc -l)"
		local git_local="$(git --no-pager rev-parse --abbrev-ref HEAD 2>/dev/null)"
		local git_remote="$(git --no-pager rev-parse --abbrev-ref HEAD@{upstream} 2>/dev/null)"
		if [[ "${git_status}" -eq 0 ]]; then
			printf "${Cblue}(%s)${Creset} ${Cwhite}%s${Creset} ${Cblue}(%s)${Creset}" "${git_local}" "clean" "${git_remote}"
		else
			local git_untracked=$(git --no-pager ls-files --others --exclude-standard | wc -l)
			local git_unstaged=$(git --no-pager diff --name-only | wc -l)
			local git_staged=$(git --no-pager diff --name-only --cached | wc -l)
			printf "${Cblue}(%s)${Creset} ${Cred}?%s${Creset} ${Cyellow}~%s${Creset} ${Cgreen}>%s${Creset} ${Cblue}(%s)${Creset}" "${git_local}" "${git_untracked}" "${git_unstaged}" "${git_staged}" "${git_remote}"
		fi
	fi
}

# prompt
PS1='$(ps1_userhost):$(ps1_dir) $(ps1_git)\n$(ps1_sign) '

# title
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
