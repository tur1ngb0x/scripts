#!/usr/bin/env bash

Pokemon=$1
HP=$2
Atk=$3
Def=$4
SpA=$5
SpD=$6
Spe=$7

# Delta Attack Factor
DAtk=$(expr "${Atk}"-"${SpA}" | bc);

# Bulk Factor
Bulk=$(expr "${Def}"+"${SpD}"+"${HP}"/1 | bc)

# Sweep Factor
Sweep=$(expr "${DAtk#-}"+"${Spe}" | bc)

cat << EOF
---------------------------------------------------------------------------------
Pokemon		Bulk	Sweep
---------------------------------------------------------------------------------
${Pokemon}	${Bulk}	${Sweep}
EOF
