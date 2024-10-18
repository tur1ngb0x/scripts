#!/usr/bin/env bash

# colors
# bold-1, dim-2, italic-3, underline-4, blink-5, reverse-7, hidden-8, strikethrough-9
# example - ;1 for bold, 1;7; for bold reverse
Cgrey="\e[90m"
Cred="\e[91m"
Cgreen="\e[92m"
Cyellow="\e[93m"
Cblue="\e[94m"
Cmagenta="\e[95m"
Ccyan="\e[96m"
Cwhite="\e[97;7m"
Creset="\e[0m"

#function ps1_datime { printf '%s' "$(date +'%Y-%m-%d %a %H:%M:%S')"; }
#function ps1_status { printf '%s' "${?}"; }
#function ps1_git { printf '%s' "$(git branch --no-color --show-current 2> /dev/null)"; }
function ps1_dir { printf "${Cwhite} %s ${Creset}" "$(pwd -L)"; }
function ps1_sign { printf "%s" "\$"; }
function ps1_userhost { printf "${Cwhite} %s@%s ${Creset}" "$(id --user --name)" "$(hostname --short)"; }
function ps1_git {
	if [[ $(git rev-parse --is-inside-git-repository 2> /dev/null) ]]; then
		git_status="$(git --no-pager status --porcelain | wc -l)"
		git_branch_local="$(git --no-pager rev-parse --abbrev-ref HEAD)"
		git_branch_remote="$(git --no-pager rev-parse --abbrev-ref HEAD@{upstream})"
		git_untracked=$(git --no-pager ls-files --others --exclude-standard | wc -l)
		git_unstaged=$(git --no-pager diff --name-only | wc -l)
		git_staged=$(git --no-pager diff --name-only --cached | wc -l)
		if [[ "${git_status}" -eq 0 ]]; then
			printf "${Cblue}%s %s${Creset}" "${git_branch_local}" "${git_branch_remote}"
		else
			printf "${Cblue}%s${Creset} ${Cred}?%s${Creset} ${Cyellow}~%s${Creset} ${Cgreen}>%s${Creset} ${Cblue}%s ${Creset}" "${git_branch_local}" "${git_untracked}" "${git_unstaged}" "${git_staged}" "${git_branch_remote}"
		fi
	fi
}

# prompt
PS1='$(ps1_userhost) $(ps1_dir) $(ps1_git)\n$(ps1_sign) '

# title
PS1="\[\e]0;\u@\h \w\a\]${PS1}"
