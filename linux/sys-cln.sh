#!/usr/bin/env bash

# pre cleaning
df -h | grep -vE "tmpfs|loop|efi|recovery" | (sed -u 1q;sort) > /tmp/preclean.txt

set -x

# package manager
if command -v apt-get; then sudo apt-get clean; fi
if command -v dnf; then sudo dnf clean all; fi
if command -v pacman; then sudo pacman -Scc; fi
if command -v yay; then yay -Scc; fi
if command -v pip; then pip cache purge; fi
if command -v flatpak; then flatpak uninstall --unused --delete-data; fi

# system logs
if command -v journalctl; then sudo journalctl --rotate; fi
if command -v journalctl; then sudo journalctl --vaccum-size=1M; fi

# cache native
if test -d ${HOME}/.cache/thumbnails; then rm -frv ${HOME}/.cache/thumbnails; fi
if test -d ${HOME}/.cache/BraveSoftware; then rm -frv ${HOME}/.cache/BraveSoftware; fi
if test -d ${HOME}/.cache/google-chrome; then rm -frv ${HOME}/.cache/google-chrome; fi
if test -d ${HOME}/.cache/microsoft-edge; then rm -frv ${HOME}/.cache/microsoft-edge; fi
if test -d ${HOME}/.cache/mozilla; then rm -frv ${HOME}/.cache/mozilla; fi
if test -d ${HOME}/.cache/fontconfig; then rm -frv ${HOME}/.cache/fontconfig; fi
if test -d ${HOME}/.cache/mesa_shader_cache; then rm -frv ${HOME}/.cache/mesa_shader_cache; fi

# cache flatpak
if test -d ${HOME}/.var/app/com.brave.Browser/cache/BraveSoftware; then rm -frv ${HOME}/.var/app/com.brave.Browser/cache/BraveSoftware; fi
if test -d ${HOME}/.var/app/com.google.Chrome/cache/google-chrome; then rm -frv ${HOME}/.var/app/com.google.Chrome/cache/google-chrome; fi
if test -d ${HOME}/.var/app/com.microsoft.Edge/cache/microsoft-edge; then rm -frv ${HOME}/.var/app/com.microsoft.Edge/cache/microsoft-edge; fi
if test -d "${HOME}/.var/app/com.microsoft.Edge/config/microsoft-edge/Default/Service Worker"; then rm -frv "${HOME}/.var/app/com.microsoft.Edge/config/microsoft-edge/Default/Service Worker"; fi
if test -d ${HOME}/.var/app/org.mozilla.firefox/cache/mozilla; then rm -frv ${HOME}/.var/app/org.mozilla.firefox/cache/mozilla; fi
if test -d ${HOME}/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/user_data; then rm -frv ${HOME}/.var/app/org.telegram.desktop/data/TelegramDesktop/tdata/user_data; fi

# trash
if test -d ${HOME}/.local/share/Trash ; then rm -frv ${HOME}/.local/share/Trash ; fi

# docker
if command -v docker; then docker system prune --all --volumes --force; fi

# ssd trim
if command -v fstrim; then sudo fstrim -av; fi

set +x

# post cleaning
df -h | grep -vE "tmpfs|efivarfs|/dev/loop" | (sed -u 1q;sort) > /tmp/postclean.txt

# print results
tput rev; tput blink; tput bold; echo ' pre cleaning '; tput sgr0; cat /tmp/preclean.txt
tput rev; tput blink; tput bold; echo ' post cleaning '; tput sgr0; cat /tmp/postclean.txt
