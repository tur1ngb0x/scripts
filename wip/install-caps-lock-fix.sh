#!/usr/bin/env bash

RPL='key <CAPS> \{ repeat=no, type\[group1\]=\"ALPHABETIC\", symbols\[group1\]=\[ Caps_Lock, Caps_Lock \],actions\[group1\]=\[LockMods\(modifiers=Lock\),Private\(type=3,data\[0\]=1,data\[1\]=3,data\[2\]=3\) \] \}'
rm -fv /tmp/keyboardmap
xkbcomp -xkb "${DISPLAY}" /tmp/keyboardmap
sed -i "s/key <CAPS>[^;]*/${RPL}/" /tmp/keyboardmap
xkbcomp /tmp/keyboardmap "${DISPLAY}"
rm -fv /tmp/keyboardmap
