#!/usr/bin/env bash
set -euo pipefail

# Bash script to run supervisord,
# independent of the PWD this script is run from.

# command to run
cmd="./.venv/bin/supervisord"
cmd_args=("-n" "-c" "./supervisord.conf")

# move working directory to the project folder
echo ">>> cd to the project directory..."
project_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
cd "$project_dir"
echo "<<< Working directory set to: $PWD"
echo

# check the files that systemd will launch
if [[ ! -x "$cmd" ]]; then
    echo "Cannot find executable supervisord: $project_dir/${cmd#./}" >&2
    exit 1
fi

if [[ ! -f "./supervisord.conf" ]]; then
    echo "Cannot find config file: $project_dir/supervisord.conf" >&2
    exit 1
fi

# run supervisord in the foreground and hand process ownership to systemd
printf -v cmd_string '%q ' "$cmd" "${cmd_args[@]}"
cmd_string="${cmd_string% }"
echo ">>> Starting app: $cmd_string"
echo

exec "$cmd" "${cmd_args[@]}"
