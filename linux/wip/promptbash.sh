#!/usr/bin/env bash

# text formatting
declare Cbold="\e[1m"
declare Cdim="\e[2m"
declare Citalic="\e[3m"
declare Cunderline="\e[4m"
declare Cblink="\e[5m"
declare Creverse="\e[7m"
declare Chidden="\e[8m"
declare Cstrike="\e[9m"

# text colors
declare Cgrey="\e[90m"
declare Cred="\e[91m"
declare Cgreen="\e[92m"
declare Cyellow="\e[93m"
declare Cblue="\e[94m"
declare Cmagenta="\e[95m"
declare Ccyan="\e[96m"
declare Cwhite="\e[97m"
declare CwhiteR="\e[97;7m"
declare Creset="\e[0m"

# username hostname directoryname
function ps1_userhostdir {
    printf "${Cgreen}%s@%s ${Ccyan}%s${Creset}" "$(id --user --name)" "$(hostname --short)" "$(pwd -L)"
}

# prompt sign
function ps1_sign {
    printf "${Cwhite}%s${Creset}" "\$"
}

# git info
function ps1_git {
    # printf '%s' "$(git branch --no-color --show-current 2> /dev/null)"
    local git_status git_local git_remote git_untracked git_unstaged git_staged
    if git rev-parse --is-inside-git-repository &> /dev/null ; then
        git_status="$(git --no-pager status --porcelain 2>/dev/null | wc -l)"
        git_local="$(git --no-pager rev-parse --abbrev-ref HEAD 2>/dev/null)"
        git_remote="$(git --no-pager rev-parse --abbrev-ref 'HEAD@{upstream}' 2>/dev/null)"
        if [[ "${git_status}" -eq 0 ]]; then
            printf "${Cblue}(%s)${Creset} ${Cwhite}%s${Creset} ${Cblue}(%s)${Creset}" "${git_local}" "clean" "${git_remote}"
        else
            git_untracked=$(git --no-pager ls-files --others --exclude-standard | wc -l)
            git_unstaged=$(git --no-pager diff --name-only | wc -l)
            git_staged=$(git --no-pager diff --name-only --cached | wc -l)
            printf "${Cblue}(%s)${Creset} ${Cred}?%s${Creset} ${Cyellow}~%s${Creset} ${Cgreen}>%s${Creset} ${Cblue}(%s)${Creset}" "${git_local}" "${git_untracked}" "${git_unstaged}" "${git_staged}" "${git_remote}"
        fi
    fi
}

# prompt variable
PS1='$(ps1_userhostdir) $(ps1_git)\n$(ps1_sign) '

# console title
PS1="\[\e]0;\u@\h \w\a\]${PS1}"

#function ps1_status { printf '%s' "${?}"; }
#function ps1_today { printf "${Ccyan}%s${Creset}" "$(date +'%Y-%m-%d %a %H:%M:%S')"; }