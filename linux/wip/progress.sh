#!/usr/bin/env bash

# DATA
# cat << EOF | grep --invert-match '^#' | sed 's/Diet/🍛/g; s/Workout/🏋️‍♀️/g; s/Steps/👣/g; s/Sleep/🛏️/g; s/\bY\b/✅/g; s/\bN\b/❌/g; s/\bR\b/💤/g' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5
# cat << EOF | grep --invert-match '^#' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5




today() {
    if [[ $# -eq 0 ]]; then                # no args? → just show today
        date '+%Y-%m-%d %a'
        return
    fi

    local day_name="${1,,}"                                                   # convert argument to lowercase
    local week_number="$(date +%V)"                                           # get current week number
    local day_number="$(date +%u)"                                            # get current day number
    local date_monday="$(date -d "-$((day_number-1)) day" +%F)" || return     # get date based on current week monday

    local day_offset                                                          # calculate day offset based on current day
    case "${day_name}" in
        mon) day_offset=0 ;;
        tue) day_offset=1 ;;
        wed) day_offset=2 ;;
        thu) day_offset=3 ;;
        fri) day_offset=4 ;;
        sat) day_offset=5 ;;
        sun) day_offset=6 ;;
        *)
            printf 'Usage: today {mon|tue|wed|thu|fri|sat|sun}\n'
            return
            ;;
    esac

    # --- print result ---
    date -d "$date_monday +$day_offset day" '+%Y-%m-%d-%a'
}



echo '```'
cat << EOF | column --output-separator '    ' --table-right 1,2,3,4,5 --keep-empty-lines  --table
DATE GYM STEPS DIET SLEEP
$(today mon) Yes 8924 10 7:24
$(today tue) Yes 13258 10 7:26
$(today wed) - - - -
$(today thu) - - - -
$(today fri) - - - -
$(today sat) - - - -
$(today sun) - - - -
EOF
echo '```'
