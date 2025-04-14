#!/usr/bin/env bash

# directories
mkdir -pv "${HOME}"/.local/bin

cli_adb() {
	pushd /tmp || return
	mv -fv '/tmp/adb-linux.zip' "/tmp/adb-linux-$(date +%Y%m%d%H%M%S).zip"
	wget -4O '/tmp/adb-linux.zip' https://dl.google.com/android/repository/platform-tools-latest-linux.zip
	mv -fv '/tmp/platform-tools' "/tmp/platform-tools-$(date +%Y%m%d%H%M%S)"
	unzip '/tmp/adb-linux.zip'
	mkdir -pv "${HOME}"/src
	mv -fv "${HOME}"/src/adb "${HOME}/src/adb-$(date +%Y%m%d%H%M%S)"
	mv -fv /tmp/platform-tools "${HOME}"/src/adb
	if ! grep -q '# adb-latest' "${HOME}"/.bashrc; then
		echo '# adb-latest' | tee -a "${HOME}/.bashrc"
		echo 'alias adb="${HOME}/src/adb/adb"' | tee -a "${HOME}/.bashrc"
	fi
	popd || return
}

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

# begin script from here
#cli_golang
cli_micro
cli_ncdu

# set permissions
chmod -fvR 0755 "${HOME}"/.local/bin/

# list apps
ls -al "${HOME}"/.local/bin/
