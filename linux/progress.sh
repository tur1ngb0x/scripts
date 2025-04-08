#!/usr/bin/env bash

# today="$(date +'%Y%m%d')"
# today_day="$(date +'%a')"
# today_week="$(date +'%-V')"

# get_day_date() {
#   local target_day="$1"
#   local current_day="$2"
#   local current_date="$3"
#   local target_index
#   local current_index
#   local target_date
#   local days

#   days=("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun")
#   target_index=$(for i in "${!days[@]}"; do if [[ "${days[$i]}" == "${target_day}" ]]; then echo "$i"; fi; done)
#   current_index=$(for i in "${!days[@]}"; do if [[ "${days[$i]}" == "${current_day}" ]]; then echo "$i"; fi; done)
#   diff=$((target_index - current_index))
#   #target_date=$(date -d "${current_date} ${diff} days" +'%Y/%m/%d-%a')
#   target_date=$(date -d "${current_date} ${diff} days" +'%a')
#   echo "${target_date}"
# }

# DATA
# cat << EOF | grep --invert-match '^#' | sed 's/Diet/🍛/g; s/Workout/🏋️‍♀️/g; s/Steps/👣/g; s/Sleep/🛏️/g; s/\bY\b/✅/g; s/\bN\b/❌/g; s/\bR\b/💤/g' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5
# echo '```'
# cat << EOF | grep --invert-match '^#' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5
# WEEK-${today_week} DIET WORKOUT STEPS SLEEP
# $(get_day_date "Mon" "${today_day}" "${today}") 0 Y 2000 6:10
# $(get_day_date "Tue" "${today_day}" "${today}") 2 Y 4000 6:15
# $(get_day_date "Wed" "${today_day}" "${today}") 4 Y 6000 6:20
# $(get_day_date "Thu" "${today_day}" "${today}") 6 Y 8000 6:25
# $(get_day_date "Fri" "${today_day}" "${today}") 8 Y 10000 6:30
# $(get_day_date "Sat" "${today_day}" "${today}") 10 R 12000 6:35
# $(get_day_date "Sun" "${today_day}" "${today}") - R 14000 6:40
# EOF
# echo '```'


cat << EOF | column --output-separator '  ' --table --table-right 1,2,3,4,5
$(echo '```')
W$(command date +'%V') DIET GYM STEPS SLEEP
MON 2 N 6689 8:02
$(echo '```')
EOF
