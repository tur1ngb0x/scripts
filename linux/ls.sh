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


#### rewrite

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

# Updated AWK script
AWK_SCRIPT=$(cat <<'EOL'
/^[dl-]/ {
    item = $7
    if ($8 == "->") {
        item = item "@"      # Add @ for symlinks
    }
    printf "%s%s%s %s%s%s %s%s%s %s\n",
    yellow, $1, reset,         # perms
    red, $3 ":" $4, reset,     # user:group
    green, $6, reset,          # modified
    item                       # filename (with @ if symlink)
}
EOL
)

# Function to print a formatted listing for a given path
list_dir() {
    local path="${1}"
    # Heading
    echo -e "${COLORS[cyan]}# ${path}${COLORS[reset]}"
    # ls + awk + column pipeline
    command ls "${LS_OPTIONS[@]}" "$path" 2>/dev/null | \
        awk -v yellow="${COLORS[yellow]}" \
            -v green="${COLORS[green]}" \
            -v red="${COLORS[red]}" \
            -v reset="${COLORS[reset]}" "${AWK_SCRIPT}" | \
        column --output-separator ' ' --table
}

# Logic for handling arguments
if [[ ${#} -ge 1 ]]; then
    for arg in "${@}"; do
        list_dir "${arg}"
    done
else
    list_dir "$(pwd)"  # Use "." (current directory) if no arg is given
fi
