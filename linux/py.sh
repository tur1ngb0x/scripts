#!/usr/bin/env bash

if command -v python &> /dev/null; then
    PYTHON="python"
elif command -v python3 &> /dev/null; then
    PYTHON="python3"
else
    echo 'python not found'
    exit
fi

${PYTHON} -m venv "${1}"
chmod +x "${1}"/bin/activate*
eval "${1}/bin/activate"
