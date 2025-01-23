#!/usr/bin/env bash

# Colors using tput
declare -A COLORS=(
	[red]=$(tput setaf 1)
	[green]=$(tput setaf 2)
	[yellow]=$(tput setaf 3)
	[blue]=$(tput setaf 4)
	[magenta]=$(tput setaf 5)
	[cyan]=$(tput setaf 6)
	[white]=$(tput setaf 7)
	[reset]=$(tput sgr0)
)

# Date/time format
FORMAT_TIME="%Y%m%d-%a-%H%M%S"

# LS options as an array for modularity
LS_OPTIONS=(
  "--almost-all"
  "--classify"
  "--format=verbose"
  "--group-directories-first"
  "--human-readable"
  "--time-style=+${FORMAT_TIME}"
  "--color=always"
)

# Pass color variables correctly to AWK
# $1 - perms
# $2 - links
# $3 - user
# $4 - group
# $5 - size
# $6 - month
# $7 - day
# $8 - h:m
# $9 - items

AWK_SCRIPT=$(cat <<'EOL'
NR > 1 {
	printf "%s%s%s %s%s%s %s%s%s %s\n",
	yellow, $1, reset, 		# perm
	red, $3 ":" $4, reset,	# user:group
	green, $6, reset,		# modified
	$7						# items
}
EOL
)

# Combine commands
command ls "${LS_OPTIONS[@]}" "${@}" | \
	awk -v yellow="${COLORS[yellow]}" \
		-v green="${COLORS[green]}" \
		-v red="${COLORS[red]}" \
		-v reset="${COLORS[reset]}" "${AWK_SCRIPT}" | \
	column --output-separator ' ' --table
