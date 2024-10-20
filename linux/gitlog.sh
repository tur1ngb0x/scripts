#!/usr/bin/env bash

# (
# 	git --no-pager log --date='format:%Y%m%d-%H:%M:%S' --pretty='format:%C(red)%ad%C(reset)|%C(green)%h%C(reset)|%C(yellow)%s%C(reset)'
# ) | column -t -N 'Date,Commit,Message' -o '    ' -s '|' | fzf --header-lines=1 | awk '{print $2}' | xargs git show

git --no-pager log --date='format:%Y%m%d-%H:%M:%S' --pretty='format:%ad|%h|%s' | column -t -N 'Date,Commit,Message' -o '    ' -s '|' | fzf --header-lines=1 | awk '{print $2}' | xargs git show


#%C(blue)(%an)%C(reset)
