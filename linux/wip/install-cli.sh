#!/usr/bin/env bash

# directories
mkdir -pv "${HOME}"/Applications
mkdir -pv "${HOME}"/.local/bin
mkdir -pv "${HOME}"/.local/share/applications

cli_golang()
{
	permalink="https://go.dev/dl"
	latest="$(command curl -s https://go.dev/dl/ | grep -E 'download downloadBox.*linux-amd64.tar.gz' | grep -o -P '(go.*gz)')"
	go_dir="${HOME}/.go"
	rm -frv /tmp/golang.tar.gz /tmp/go "${go_dir}"
	wget -4O /tmp/golang.tar.gz "${permalink}"/"${latest}"
	tar --file /tmp/golang.tar.gz -vvv --extract --gzip --directory /tmp
	mv -fv /tmp/go "${go_dir}"
	chown -cR "${USER}":"${USER}" "${go_dir}"
}

cli_micro()
{
	wget -4O /tmp/micro.sh 'https://getmic.ro'
	pushd "${HOME}"/.local/bin || exit
	sh /tmp/micro.sh
	popd || exit
}

cli_ncdu()
{
	wget -4O /tmp/ncdu.tar.gz 'https://dev.yorhel.nl/download/ncdu-2.3-linux-x86_64.tar.gz'
	tar --file /tmp/ncdu.tar.gz -vvv --extract --gzip --directory "${HOME}"/.local/bin
}


cli_ytdlp()
{
	wget -4O "${HOME}"/.local/bin/yt-dlp 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp'
}

# begin script from here
cli_golang
cli_micro
cli_ncdu
cli_ytdlp

# set permissions
chmod -fvR 0755 "${HOME}"/.local/bin/

# list apps
ls -al "${HOME}"/.local/bin/
