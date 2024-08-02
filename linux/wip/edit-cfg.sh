#!/usr/bin/env bash

usage()
{
	cat << EOF
-----------------------------------------------------------------------
Syntax:
	${0##*/} <option>
Options:
-----------------------------------------------------------------------
	name			path
-----------------------------------------------------------------------
	sys-fstab		/etc/fstab
	sys-grub		/etc/default/grub
	sys-ssh			/etc/ssh/ssh_config
	sys-sshd		/etc/ssh/sshd_config
	root-bash		/root/.bashrc
	root-profile		/root/.profile
	user-bash		$HOME/.bashrc
	user-profile		$HOME/.profile
	user-ssh		$HOME/.ssh/config
-----------------------------------------------------------------------
Usage:
	${0##*/} sys-sshd
	${0##*/} root-profile
	${0##*/} rouser-bash
-----------------------------------------------------------------------
EOF
}

option="${1}"
shift

case "${option}" in
	sys-fstab)		sudoedit /etc/fstab ;;
	sys-grub)		sudoedit /etc/default/grub ;;
	sys-ssh)		sudoedit /etc/ssh/ssh_config ;;
	sys-sshd)		sudoedit /etc/ssh/sshd_config ;;
	user-bash)		"${EDITOR}" "${HOME}"/.bashrc ;;
	user-profile)	"${EDITOR}" "${HOME}"/.profile ;;
	root-bash)		sudoedit /root/.bashrc ;;
	root-profile)	sudoedit /root/.profile ;;
	*) usage ;;
esac
