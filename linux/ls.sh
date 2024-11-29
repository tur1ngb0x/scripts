# #!/usr/bin/env bash

# color_red=$(tput setaf 1)
# color_green=$(tput setaf 2)
# color_yellow=$(tput setaf 3)
# color_blue=$(tput setaf 4)
# color_magenta=$(tput setaf 5)
# color_cyan=$(tput setaf 6)
# color_white=$(tput setaf 7)
# color_reset=$(tput sgr0)
# format_time="%Y/%m/%d-%a-%H:%M:%S"

# command ls \
#     --almost-all \
#     --classify \
#     --format=verbose \
#     --group-directories-first \
#     --human-readable \
#     --time-style=+"${format_time}" \
#     --color=always | \
#     awk -v cyan="${color_cyan}" -v magenta="${color_magenta}" -v yellow="${color_yellow}" -v blue="${color_blue}" -v red="${color_red}" -v green="${color_green}" -v reset="${color_reset}" \
# 		'NR > 1 { printf "%s%s%s %s%s%s %s%s%s %s\n", yellow, $1, reset, green, $6, reset, red, $3 ":" $4, reset, $7}' | \
# 	column --output-separator ' ' --table;

# # command ls \
# # 	--almost-all \
# # 	--classify \
# # 	--format=verbose \
# # 	--group-directories-first \
# # 	--human-readable \
# # 	--time-style=+"${format_time}" \
# # 	--color=always | \
# # 	awk 'NR > 1 {print $3 ":" $4, $1, $6, $7}' | \
# # 	column --table-columns U:G,PERMS,MODIFIED,NAME --output-separator '  ' --table;


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
FORMAT_TIME="%Y/%m/%d-%a-%H:%M:%S"

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
	printf "%s%s%s %s %s%s%s %s%s%s\n",
	green, $6, reset,		# modified
	$7,						# items
	yellow, $1, reset, 		# perm
	red, $3 ":" $4, reset	# user:group
}
EOL
)

# Combine commands
command ls "${LS_OPTIONS[@]}" | \
	awk -v yellow="${COLORS[yellow]}" \
		-v green="${COLORS[green]}" \
		-v red="${COLORS[red]}" \
		-v reset="${COLORS[reset]}" "${AWK_SCRIPT}" | \
	column --output-separator ' ' --table
