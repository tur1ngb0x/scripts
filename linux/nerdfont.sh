#!/usr/bin/env bash

function show { (set -x; "${@:?}"); }
function stdout { printf "%s\n" "${1}"; }
function header  { tput bold; tput setaf 4; printf "\n%s \n" "${1}"; tput sgr0; }
function stderr { tput bold; tput setaf 1; printf "\nError: "; tput sgr0; printf "%s\n" "${1}"; tput sgr0; }

function CheckCmd {
    cmd_list=("${@}")
    cmd_missing=()
    for cmd in "${cmd_list[@]}"; do
        if ! command -v "${cmd}" &> /dev/null; then
            cmd_missing+=("${cmd}")
        # else
        #     echo "${cmd} found in PATH"
        fi
    done
    if [[ "${#cmd_missing[@]}" -gt 0 ]]; then
        stderr "not found in PATH"
        for cmd in "${cmd_missing[@]}"; do
            printf '%s ' "${cmd}"
        done
        exit 1
    fi
}

function ShowFontsLocal {
        header "Installed Fonts"
        if [[ -d "${HOME}"/.local/share/fonts ]]; then
           find "${HOME}"/.local/share/fonts -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
           # awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}'
    else
        printf '%s\n' 'No fonts installed'
    fi
}

function ShowFontsRemote {
    header "Available Fonts"
    echo 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts'
    # if [[ ! -f /tmp/nerdfont-curl ]]; then
    #     curl -4 -s -L 'https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts' > /tmp/nerdfont-curl
    # fi
    # grep -o '/ryanoasis/nerd-fonts/tree/master/patched-fonts/[^"]*' /tmp/nerdfont-curl > /tmp/nerdfont-grep
    # sed 's|/ryanoasis/nerd-fonts/tree/master/patched-fonts/||' /tmp/nerdfont-grep > /tmp/nerdfont-sed
    # sort -u /tmp/nerdfont-sed > /tmp/nerdfont-sort
    # awk '{printf "%-25s", $0; if (NR % 3 == 0) print ""} END {if (NR % 3 != 0) print ""}' /tmp/nerdfont-sort > /tmp/nerdfont-awk
    # cat /tmp/nerdfont-awk
    # # column -t /tmp/nerdfont-awk > /tmp/nerdfont-column
    # # cat /tmp/nerdfont-column
}

function ShowUsage {
    header 'Syntax'
    cat << EOF
$ nerdfont.sh 'font'
$ nerdfont.sh 'font1' 'font2' 'font3' ... 'fontN'
EOF
    header 'Example'
    cat << EOF
$ nerdfont.sh 'CascadiaMono'
$ nerdfont.sh 'FiraMono' 'IBMPlexMono' 'RobotoMono'
EOF
}

function PatchFonts {

    stock_fonts="${1}"
    patched_fonts="${2}"

    mkdir -pv "${1}" "${2}"

    show docker --debug --log-level 'debug' container run --rm \
    --volume "${stock_fonts}":/in:Z \
    --volume "${patched_fonts}":/out:Z \
    --env "PN=4" \
    nerdfonts/patcher \
        --debug 3 \
        --complete \
        --mono \
        --single-width-glyphs \
        --removeligs \
        --adjust-line-height \
        --progressbars

    sudo chown -Rc "${USER}":"${USER}" "${2}"
}

function InstallFonts {
    # if no arguments are provided, exit
    if [[ -z "${1}" ]]; then
        stderr "No font name provided."
        exit
    fi

    # store arguments as font names in array
    font_names=("${@}")

    # loop through the array
    for font in "${font_names[@]}"; do
        # # if font name is invalid, show error, and continue loop
        # if ! grep "${font}" /tmp/nerdfont-awk &> /dev/null; then
        #     stderr "${font} is an invalid font name."
        #     continue
        # fi

        # install font
        header "Installing Nerd Font - ${font}"
		show mkdir -p /tmp/nerd-fonts
        show curl -s -L -o /tmp/nerd-fonts/"${font}".tar.xz https://github.com/ryanoasis/nerd-fonts/releases/latest/download/"${font}".tar.xz
		show mkdir -p "${HOME}"/.local/share/fonts/"${font}"
        show tar --file /tmp/nerd-fonts/"${font}".tar.xz --extract --xz --directory "${HOME}"/.local/share/fonts/"${font}"
    done
}

function SetupFonts {
    header 'Finalizing Installation'
    # set font permissions
    show sudo chown -Rc "${USER}":"${USER}" "${HOME}"/.local/share/fonts
    # regenerate font cache
    show fc-cache -r
    # show xdg-open "${HOME}"/.local/share/fonts
}

function main {
    set -e
    CheckCmd find curl awk grep sed sort tar fc-cache
    ShowFontsLocal
    ShowFontsRemote
    ShowUsage
    InstallFonts "${@}"
    SetupFonts
    set +e
}

# begin script from here
main "${@}"
