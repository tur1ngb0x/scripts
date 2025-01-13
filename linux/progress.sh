#!/usr/bin/env bash

#Mon: 00 ✅❌- 00000 0.00h
#Tue: 00 ✅❌- 00000 0.00h
#Wed: 00 ✅❌- 00000 0.00h
#Thu: 00 ✅❌- 00000 0.00h
#Fri: 00 ✅❌- 00000 0.00h
#Sat: 00 ✅❌- 00000 0.00h
#Sun: 00 ✅❌- 00000 0.00h

# HEADER
cat << EOF
Wk51: Diet | Workout | Steps | Sleep
EOF

# DATA
cat << EOF | grep -v '^#' | column --keep-empty-lines --output-separator '  ' -t
$(echo '```')
#Mon: 00 ✅❌- 00000 0.00h
#Tue: 00 ✅❌- 00000 0.00h
#Wed: 00 ✅❌- 00000 0.00h
#Thu: 00 ✅❌- 00000 0.00h
#Fri: 00 ✅❌- 00000 0.00h
#Sat: 00 ✅❌- 00000 0.00h
#Sun: 00 ✅❌- 00000 0.00h
$(echo '```')
EOF
