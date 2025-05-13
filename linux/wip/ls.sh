#!/usr/bin/env bash

# # Colors using tput
# declare -A COLORS=(
#     [red]=$(tput setaf 1)
#     [green]=$(tput setaf 2)
#     [yellow]=$(tput setaf 3)
#     [blue]=$(tput setaf 4)
#     [magenta]=$(tput setaf 5)
#     [cyan]=$(tput setaf 6)
#     [white]=$(tput setaf 7)
#     [reset]=$(tput sgr0)
# )

# # Date/time format
# FORMAT_TIME="%Y%m%d-%a-%H%M%S"

# # LS options as an array for modularity
# LS_OPTIONS=(
#     "--almost-all"
#     "--classify"
#     "--format=verbose"
#     "--group-directories-first"
#     "--human-readable"
#     "--time-style=+${FORMAT_TIME}"
#     "--color=always"
# )

# # Pass color variables correctly to AWK
# # $1 - perms
# # $2 - number of links
# # $3 - owner
# # $4 - group
# # $5 - size
# # $6 - yyyy-mm-dd ddd hh:mm:ss
# # $7 - files folders links
# # $8 - link symbol ->
# # $9 - link target location

# # AWK_SCRIPT=$(cat <<'EOL'
# # NR > 1 {
# #     printf "%s%s%s %s%s%s %s%s%s %s\n",
# #     yellow, $1, reset,     # perm
# #     red, $3 ":" $4, reset, # user:group
# #     green, $6, reset,      # modified
# #     $7                     # items
# # }
# # EOL
# # )

# # fall back if ls <arg> prints nothing
# AWK_SCRIPT=$(cat <<'EOL'
# /^[dl-]/ {
#     item = $7
#     if ($8 == "->") {
#         item = item"@"      # add @ to symlink name
#     }
#     printf "%s%s%s %s%s%s %s%s%s %s\n",
#     yellow, $1, reset,         # perms
#     red, $3 ":" $4, reset,     # user:group
#     green, $6, reset,          # modified
#     item                       # file name with optional @
# }
# EOL
# )

# # Combine commands
# command ls "${LS_OPTIONS[@]}" "${@}" | \
#     awk -v yellow="${COLORS[yellow]}" \
#         -v green="${COLORS[green]}" \
#         -v red="${COLORS[red]}" \
#         -v reset="${COLORS[reset]}" "${AWK_SCRIPT}" | \
#     column --output-separator ' ' --table


#### rewrite 1

# set colors
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

# timestamp
#TIMESTAMP="%Y%m%d-%a-%H%M%S"
TIMESTAMP="%Y%m%d-%H%M%S"

# ls command arguments
LS_OPTIONS=(
    "--almost-all"
    "--classify"
    "--format=verbose"
    "--group-directories-first"
    "--human-readable"
    "--time-style=+${TIMESTAMP}"
    "--color=always"
)

# awk script
AWK_SCRIPT=$(cat <<'EOL'
/^[dl-]/ {
    item = $7
    if ($8 == "->") {
        item = item "@"      # Add @ for symlinks
    }
    printf "%s%s%s %s%s%s %s%s%s %s\n",
    red, $3 ":" $4, reset,     # user:group
    yellow, $1, reset,         # permissions
    green, $6, reset,          # last modified
    item                       # filename (with @ if symlink)
}
EOL
)

# function to print a formatted listing for a given path
list_dir() {
    local path="${1}"

    # print if directory does not exist
    if [[ ! -d "${path}" ]]; then
        echo "Directory '${path}' does not exist."
        exit
    fi

    # print if directory is empty
    if [ -z "$(command ls -A "${path}")" ]; then
        echo "Directory '${path}' is empty."
    fi

    # dir name as heading
    echo -e "${COLORS[cyan]}${path}:${COLORS[reset]}"

    # ls output as body
    command ls "${LS_OPTIONS[@]}" "${path}" | \
        awk -v yellow="${COLORS[yellow]}" \
            -v green="${COLORS[green]}" \
            -v red="${COLORS[red]}" \
            -v reset="${COLORS[reset]}" "${AWK_SCRIPT}" | \
        column --separator $'\0' --output-separator ' ' --table
}


# if multiple dirs as args, print ls per dir
# else show current dir name
if [[ ${#} -ge 1 ]]; then
    for arg in "${@}"; do
        list_dir "${arg}"
    done
else
    list_dir "$(pwd)"
fi
