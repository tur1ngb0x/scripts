#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

builtin printf -- \
    "\033[1;38;2;0;200;200m  DISTRO \033[0m: %s\n" \
    "$(/usr/bin/sed --silent -- 's/^PRETTY_NAME="\([^"]*\)"/\1/p' /etc/os-release)"

builtin printf -- \
    "\033[1;38;2;64;150;200m  KERNEL \033[0m: %s\n" \
    "$(/usr/bin/uname --kernel-release --)"

builtin printf -- \
    "\033[1;38;2;128;100;200m  UPTIME \033[0m: %s\n" \
    "$(/usr/bin/uptime --pretty -- | /usr/bin/sed -- 's/up //g; s/,//g; s/ hour/hr/g; s/ minutes/min/g')"

builtin printf -- \
    "\033[1;38;2;170;60;190m    DISK \033[0m: %s GiB\n" \
    "$(/usr/bin/df / -- | /usr/bin/awk 'FNR==2 {printf "%.2f\n", $3/1024/1024}')"
    # "$(/usr/bin/df / -- | /usr/bin/awk 'FNR==2 {printf "%.2f\n", $2/1024/1024}')"

builtin printf -- \
    "\033[1;38;2;200;20;170m     RAM \033[0m: %s GiB\n" \
    "$(/usr/bin/free -- | /usr/bin/awk -- 'FNR==2 {printf "%.2f\n", $3/1024/1024}')"
    # "$(/usr/bin/free -- | /usr/bin/awk -- 'FNR==2 {printf "%.2f\n", $2/1024/1024}')"
