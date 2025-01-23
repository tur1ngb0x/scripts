#!/usr/bin/env bash

# TEMPLATE
#Mon: 00 ✅❌🛏️ 00000 0.00h
#Tue: 00 ✅❌🛏️ 00000 0.00h
#Wed: 00 ✅❌🛏️ 00000 0.00h
#Thu: 00 ✅❌🛏️ 00000 0.00h
#Fri: 00 ✅❌🛏️ 00000 0.00h
#Sat: 00 ✅❌🛏️ 00000 0.00h
#Sun: 00 ✅❌🛏️ 00000 0.00h

# HEADER
cat << EOF
Wk$(date +%-V): Diet | Workout | Steps | Sleep
EOF

# DATA
cat << EOF | grep --invert-match '^#' | column --keep-empty-lines --output-separator '  ' --table
$(echo '```')
Mon: 10 ✅ 12436 6.50h
#Tue: 00 ✅ 00000 0.00h
#Wed: 00 ✅ 00000 0.00h
#Thu: 00 ✅ 00000 0.00h
#Fri: 00 ✅ 00000 0.00h
#Sat: 00 ✅ 00000 0.00h
#Sun: 00 ✅ 00000 0.00h
$(echo '```')
EOF
