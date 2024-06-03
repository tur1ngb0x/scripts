#!/usr/bin/env bash

usage()
{
	cat << EOF
Fonts:
	https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts
Syntax:
	${0##*/} 'font-name'
Usage:
	${0##*/} 'IBMPlexMono'
	${0##*/} 'Terminus'
EOF
}

if [[ "${#}" -eq 0 ]]; then
	usage
	exit
fi

set -x

rm -fr /tmp/nerd-fonts

rm -fv "${HOME}"/.local/share/fonts/"${1}"

mkdir -p /tmp/

mkdir -p "${HOME}"/.local/share/fonts/"${1}"

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts /tmp/nerd-fonts

pushd /tmp/nerd-fonts || exit

git sparse-checkout add patched-fonts/"${1}"

cd patched-fonts/"${1}" || exit

find . -type f -iname "*.ttf" -exec cp -fv {} "${HOME}"/.local/share/fonts/"${1}"/ \;

echo 'updating font cache...'; fc-cache -r

popd || exit

set +x
