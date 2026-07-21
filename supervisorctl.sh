#!/usr/bin/env bash
set -euo pipefail

# Bash wrapper to run supervisorctl with this project's config,
# independent of the PWD and whether this script is called through a symlink.

script_path="$(readlink -f -- "${BASH_SOURCE[0]}")"
project_dir="$(cd -- "$(dirname -- "$script_path")" && pwd -P)"
supervisorctl_path="$project_dir/.venv/bin/supervisorctl"
config_path="$project_dir/supervisord.conf"

if [[ ! -x "$supervisorctl_path" ]]; then
    echo "Cannot find executable supervisorctl: $supervisorctl_path" >&2
    echo "Run 'uv sync' in the supervisor project folder, then try again." >&2
    exit 1
fi

if [[ ! -f "$config_path" ]]; then
    echo "Cannot find config file: $config_path" >&2
    echo "Create supervisord.conf from the template, then try again." >&2
    exit 1
fi

exec "$supervisorctl_path" -c "$config_path" "$@"
