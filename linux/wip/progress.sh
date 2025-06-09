#!/usr/bin/env bash

# DATA
# cat << EOF | grep --invert-match '^#' | sed 's/Diet/🍛/g; s/Workout/🏋️‍♀️/g; s/Steps/👣/g; s/Sleep/🛏️/g; s/\bY\b/✅/g; s/\bN\b/❌/g; s/\bR\b/💤/g' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5
# cat << EOF | grep --invert-match '^#' | column --keep-empty-lines --output-separator ' ' --table --table-right 1,2,3,4,5


echo '```'

cat << EOF | column --table --table-right 1,2,3,4,5,6 --output-separator ' '
W$(command date +'%V') DIET GYM STEPS SLEEP WEIGHT
MON 2 N 39 9:23 71.4
TUE 10 Y 12882 7:58 71.5
WED 10 Y 11848 7:38 71.3
THU 10 Y 10505 6:58 71.7
FRI 10 Y 3879 8:07 71.5
SAT - R - - -
SUN - R - - -
EOF

echo '```'
