#!/usr/bin/env bash
set -euo pipefail

# Bash script to run the specified Python script,
# independent of the PWD this script is run from.

# script to run
py_path="./main.py"

# move working directory to the project folder
echo ">>> cd to the project directory..."
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$script_dir"
echo "<<< Working directory set to: $PWD"
echo

# load .env if any
if [[ -f "./.env" ]]; then
    echo ">>> Loading .env file..."
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%$'\r'}"
        trimmed="${line#"${line%%[![:space:]]*}"}"
        trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"

        [[ -z "$trimmed" || "${trimmed:0:1}" == "#" ]] && continue

        if [[ "$trimmed" != *=* ]]; then
            continue
        fi

        name="${trimmed%%=*}"
        value="${trimmed#*=}"
        name="${name#"${name%%[![:space:]]*}"}"
        name="${name%"${name##*[![:space:]]}"}"
        value="${value#"${value%%[![:space:]]*}"}"
        value="${value%"${value##*[![:space:]]}"}"

        if [[ ! "$name" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
            echo "Invalid environment variable name in .env: $name" >&2
            exit 1
        fi

        export "$name=$value"
    done < "./.env"
    echo "<<< .env file loaded"
fi

# use the app project's virtual environment directly
echo ">>> venv checking..."
venv_python="./.venv/bin/python"
if [[ ! -x "$venv_python" ]]; then
    echo "Cannot find venv python: $script_dir/${venv_python#./}" >&2
    exit 1
fi
echo "<<< venv ready: $venv_python"
echo
echo

# run the main script and hand process ownership to supervisor
echo ">>> Starting app: $py_path ..."
echo

exec "$venv_python" "$py_path"
