#!/usr/bin/env

clear

cat << EOF
=======================================================================
RAM
=======================================================================
EOF
ram_total=$(free -mltw | awk 'FNR == 2 {print $2}')
ram_used=$(free -mltw | awk 'FNR == 2 {print $3}')
ram_free=$(free -mltw | awk 'FNR == 2 {print $4}')
echo -e 'total\t' $ram_total
echo -e 'used\t' $ram_used
echo -e 'free\t' $ram_free

cat << EOF
=======================================================================
SWAP
=======================================================================
EOF
swp_total=$(free -mltw | awk 'FNR == 5 {print $2}')
swp_used=$(free -mltw | awk 'FNR == 5 {print $3}')
swp_free=$(free -mltw | awk 'FNR == 5 {print $4}')
echo -e 'total\t' $swp_total
echo -e 'used\t' $swp_used
echo -e 'free\t' $swp_free

cat << EOF
=======================================================================
PACKAGES
=======================================================================
EOF
[[ -f /usr/bin/dpkg ]] && pkgs_apt="$(dpkg --get-selections | wc -l)" && printf "apt\t${pkgs_apt}\n"
[[ -f /usr/bin/snap ]] && pkgs_snap="$(snap list | wc -l)" && printf "snap\t${pkgs_snap}\n"
[[ -f /usr/bin/flatpak ]] && pkgs_flatpak="$(flatpak list | wc -l)" && printf "flatpak\t${pkgs_flatpak}\n"

