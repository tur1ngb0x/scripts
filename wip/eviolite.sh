#!/usr/bin/env bash

HP=$1
Def=$2
SpD=$3
Mod=1.5
SpDE=0
DefE=0
BulkE=0
Bulk=0

Bulk=$(expr $Def+$SpD+$HP/1 | bc)
DefE=$(expr $Def*$Mod/1 | bc)
SpDE=$(expr $SpD*$Mod/1 | bc)
BulkE=$(expr $DefE+$SpDE+$HP/1 | bc)

#printf "Eviolite\tDef\tSpD\tBulk\n"
#printf "%s\n" "----------------------------------------"
#printf "Before\t\t${Def}\t${SpD}\t$Bulk\n"
#printf "After\t\t${DefE}\t${SpDE}\t$BulkE\n"

cat << EOF
Eviolite	Def	SpD	Bulk
--------------------------------------------
Before		$Def	$SpD	$Bulk
After		$DefE	$SpDE	$BulkE
EOF
