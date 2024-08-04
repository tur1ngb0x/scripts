#!/usr/bin/env bash

function fix-endings {
	# dotfiles
	find "${HOME}"/src/dotfiles/          -mindepth 1 -type f -exec dos2unix --follow-symlink --allow-chown --verbose {} \;
	find "${HOME}"/src/dotfiles/windows/  -mindepth 1 -type f -exec unix2dos --follow-symlink --allow-chown --verbose {} \;
	# scripts
	find "${HOME}"/src/scripts/           -mindepth 1 -type f -exec dos2unix --follow-symlink --allow-chown --verbose {} \;
	find "${HOME}"/src/scripts/windows/   -mindepth 1 -type f -exec unix2dos --follow-symlink --allow-chown --verbose {} \;
	# notes
	find "${HOME}"/src/notes/             -mindepth 1 -type f -exec dos2unix --follow-symlink --allow-chown --verbose {} \;
}

function fix-permissions {
	# dotfiles
	find -L "${HOME}"/src/dotfiles/       -type d -exec chmod --verbose --changes 0755 {} \;
	find -L "${HOME}"/src/dotfiles/       -type f -exec chmod --verbose --changes 0644 {} \;
	# scripts
	find -L "${HOME}"/src/scripts/        -type d -exec chmod --verbose --changes 0755 {} \;
	find -L "${HOME}"/src/scripts/        -type f -exec chmod --verbose --changes 0644 {} \;
	# scripts (executable)
	find "${HOME}"/src/scripts/linux/     -mindepth 1 -type f -exec chmod --recursive --changes a+x {} \;
	find "${HOME}"/src/scripts/windows/   -mindepth 1 -type f -exec chmod --recursive --changes a+x {} \;
}

# begin script from here
fix-endings
fix-permissions
