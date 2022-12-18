#!/usr/bin/env bash

# color
magenta="\033[1;35m"
green="\033[1;32m"
white="\033[1;37m"
blue="\033[1;34m"
red="\033[1;31m"
black="\033[1;40;30m"
yellow="\033[1;33m"
cyan="\033[1;36m"
reset="\033[0m"
bgyellow="\033[1;43;33m"
bgwhite="\033[1;47;37m"
c0=${reset}
c1=${magenta}
c2=${green}
c3=${white}
c4=${blue}
c5=${red}
c6=${yellow}
c7=${cyan}
c8=${black}
c9=${bgyellow}
c10=${bgwhite}


get_distro() { awk -F '"' '/PRETTY_NAME/ { print $2 }' /etc/os-release; }
get_kernel() { uname r; }
get_pkgs() { dpkg --get-selections | wc -l; }
get_shell() { echo $SHELL; }
get_uptime() { uptime -p | sed 's/up //'; }
get_ram_total() { free -mt | awk 'FNR == 2 {print $2}'; }
get_ram_used() { free -mt | awk 'FNR == 2 {print $3}'; }
get_disk_used() { df -h --output=used / | awk 'FNR == 2 {print $1}'; }
get_disk_total() { df -h --output=size / | awk 'FNR == 2 {print $1}'; }
