#!/usr/bin/env bash

LC_ALL=C
builtin set -euo pipefail

command atool --verbose --explain --extract --force --subdir "${1}"
