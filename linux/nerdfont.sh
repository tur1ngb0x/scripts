#!/usr/bin/env bash

usage()
{
	cat << EOF
Fonts:

Syntax:
	${0##*/} 'font-name'
Usage:
	${0##*/} 'IBMPlexMono'
	${0##*/} 'Terminus'
EOF
}

usage()
{
	cat << EOF

Description:
Install any nerd font in ${HOME}/.local/share/fonts/

Syntax:
$ ${0##*/} 'font-name'

Fonts:
https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts

Usage:
$ ${0##*/} 'LiberationMono'

EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi


{ set -x ; } &> /dev/null

rm -fr "${HOME}"/src/tmp/nerd-fonts/

rm -fr "${HOME}"/.local/share/fonts/"${1}"/

mkdir -p "${HOME}"/src/tmp/nerd-fonts/

mkdir -p "${HOME}"/.local/share/fonts/"${1}"/

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts "${HOME}"/src/tmp/nerd-fonts/

pushd "${HOME}"/src/tmp/nerd-fonts || exit

git sparse-checkout add patched-fonts/"${1}"/

pushd "${HOME}"/src/tmp/nerd-fonts/patched-fonts || exit

find "${HOME}"/src/tmp/nerd-fonts/patched-fonts  -type f -iname "*.ttf" -exec mv -f {} "${HOME}"/.local/share/fonts/"${1}"/ \;

echo 'updating font cache...'

fc-cache -r

popd || exit

popd || exit

{ set +x ; } &> /dev/null
