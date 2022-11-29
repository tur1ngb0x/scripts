if [[ $(grep "^DEBIAN_CODENAME=" /etc/os-release) ]]; then
	release="$(grep "^DEBIAN_CODENAME=" /etc/os-release | awk -F= '{print $NF}')"
elif [[ $(grep "^UBUNTU_CODENAME=" /etc/os-release) ]]; then
	release="$(grep "^UBUNTU_CODENAME=" /etc/os-release | awk -F= '{print $NF}')"
else
	echo 'release cannot be determined, exiting...' && exit
fi

echo "${release}"
