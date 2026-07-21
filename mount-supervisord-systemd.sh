#!/usr/bin/env bash
set -euo pipefail

# Register the systemd part of the Linux setup and optionally start it.
# Run this after `uv sync` and after creating supervisord.conf.
#
# The unit is named `supervisor` by default. It starts at boot, runs
# supervisord as the non-root deployment user, and launches
# `Startup_supervisord.sh` from this repository.
#
# Startup flow:
#
# systemd
#   -> Startup_supervisord.sh
#      -> .venv/bin/supervisord -n -c ./supervisord.conf
#         -> app processes from conf.d/*.conf

repo_root=""
service_name="supervisor"
service_user=""
run_now=false
force=false

while (($# > 0)); do
    case "$1" in
        --repo-root)
            [[ $# -ge 2 ]] || { echo "--repo-root requires a path" >&2; exit 2; }
            repo_root="$2"
            shift 2
            ;;
        --service-name)
            [[ $# -ge 2 ]] || { echo "--service-name requires a name" >&2; exit 2; }
            service_name="$2"
            shift 2
            ;;
        --service-user)
            [[ $# -ge 2 ]] || { echo "--service-user requires a user" >&2; exit 2; }
            service_user="$2"
            shift 2
            ;;
        --run-now)
            run_now=true
            shift
            ;;
        --force)
            force=true
            shift
            ;;
        -h|--help)
            echo "Usage: sudo bash ./mount-supervisord-systemd.sh [options]"
            echo ""
            echo "Options:"
            echo "  --repo-root PATH       Supervisor repository root"
            echo "  --service-name NAME    systemd service name (default: supervisor)"
            echo "  --service-user USER    Non-root account that runs supervisord"
            echo "  --run-now              Start the service after registration"
            echo "  --force                Replace a unit not created by this helper"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 2
            ;;
    esac
done

# Step 1. Confirm this shell is running as root.
if [[ $EUID -ne 0 ]]; then
    echo "Run this script with sudo, then try again." >&2
    exit 1
fi

# Step 2. Resolve the repository and deployment user.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="${repo_root:-$script_dir}"

if [[ ! -d "$repo_root" ]]; then
    echo "Supervisor folder does not exist: $repo_root" >&2
    exit 1
fi

repo_root="$(cd -- "$repo_root" && pwd -P)"
service_name="${service_name%.service}"

if [[ "$repo_root" == *$'\n'* || "$repo_root" == *$'\r'* ]]; then
    echo "Repository paths containing line breaks are not supported." >&2
    exit 1
fi

if [[ -z "$service_user" ]]; then
    service_user="${SUDO_USER:-$(stat -c '%U' "$repo_root")}"
fi

if [[ ! "$service_name" =~ ^[A-Za-z0-9_.@-]+$ ]]; then
    echo "Invalid systemd service name: $service_name" >&2
    exit 1
fi

if [[ ! "$service_user" =~ ^[A-Za-z0-9_.-]+$ ]] || ! id "$service_user" >/dev/null 2>&1; then
    echo "Linux user does not exist: $service_user" >&2
    exit 1
fi

service_uid="$(id -u "$service_user")"
if [[ "$service_uid" -eq 0 ]]; then
    echo "Refusing to run supervisord as root. Pass --service-user with the deployment user." >&2
    exit 1
fi

service_home="$(getent passwd "$service_user" | cut -d: -f6)"
if [[ -z "$service_home" || "$service_home" == *$'\n'* || "$service_home" == *$'\r'* || ! -d "$service_home" ]]; then
    echo "Cannot find the home folder for user: $service_user" >&2
    exit 1
fi

launcher_path="$repo_root/Startup_supervisord.sh"
if [[ ! -f "$launcher_path" ]]; then
    echo "Missing launcher script: $launcher_path" >&2
    exit 1
fi

supervisord_path="$repo_root/.venv/bin/supervisord"
if [[ ! -x "$supervisord_path" ]]; then
    echo "Missing supervisord executable: $supervisord_path" >&2
    echo "Run 'uv sync' as the deployment user before registering the service." >&2
    exit 1
fi

config_path="$repo_root/supervisord.conf"
if [[ ! -f "$config_path" ]]; then
    echo "Missing runtime config: $config_path" >&2
    echo "Copy supervisord.conf.template and set its password before registering the service." >&2
    exit 1
fi

if [[ -L "$config_path" ]]; then
    echo "Runtime config must be a regular file, not a symbolic link: $config_path" >&2
    exit 1
fi

config_uid="$(stat -c '%u' "$config_path")"
config_mode="$(stat -c '%a' "$config_path")"
if [[ "$config_uid" != "$service_uid" ]]; then
    echo "Runtime config must be owned by the deployment user: $service_user" >&2
    exit 1
fi

if (( (8#$config_mode & 077) != 0 )); then
    echo "Runtime config contains credentials and must not be accessible by group or other users." >&2
    printf 'Run: chmod 600 %q\n' "$config_path" >&2
    exit 1
fi

echo ">>> Setting up supervisord system service"
echo "Repo root: $repo_root"
echo "Service name: $service_name"
echo "Service user: $service_user"
echo

# Step 3. Refuse to hide a distribution or manually managed unit by default.
unit_name="$service_name.service"
unit_path="/etc/systemd/system/$unit_name"
managed_marker="# Managed by supervisor-linux mount-supervisord-systemd.sh"
existing_fragment="$(systemctl show -p FragmentPath --value "$unit_name" 2>/dev/null || true)"

if [[ -f "$unit_path" ]] && ! grep -Fqx "$managed_marker" "$unit_path" && [[ "$force" != true ]]; then
    echo "Refusing to replace an existing unit not created by this helper: $unit_path" >&2
    echo "Inspect it first, then rerun with --force only if replacement is intended." >&2
    exit 1
fi

if [[ -n "$existing_fragment" && "$existing_fragment" != "$unit_path" && "$force" != true ]]; then
    echo "A different $unit_name already exists at: $existing_fragment" >&2
    echo "Remove the old package/unit, or rerun with --force only if replacement is intended." >&2
    exit 1
fi

# Step 4. Escape values that systemd interprets inside quoted directives.
repo_unit_value="${repo_root//\\/\\\\}"
repo_unit_value="${repo_unit_value//\"/\\\"}"
repo_unit_value="${repo_unit_value//%/%%}"
home_unit_value="${service_home//\\/\\\\}"
home_unit_value="${home_unit_value//\"/\\\"}"
home_unit_value="${home_unit_value//%/%%}"
launcher_unit_value="${launcher_path//\\/\\\\}"
launcher_unit_value="${launcher_unit_value//\"/\\\"}"
launcher_unit_value="${launcher_unit_value//%/%%}"

# Step 5. Write the unit and enable it at boot.
temporary_unit="$(mktemp)"
trap 'rm -f "$temporary_unit"' EXIT

cat >"$temporary_unit" <<EOF
$managed_marker
[Unit]
Description=Supervisor process control system for UNIX
Documentation=https://supervisord.org/
After=network.target

[Service]
Type=simple
User=$service_user
Environment="HOME=$home_unit_value"
WorkingDirectory="$repo_unit_value"
ExecStart=/bin/bash "$launcher_unit_value"
Restart=on-failure
RestartSec=60s
KillMode=mixed

[Install]
WantedBy=multi-user.target
EOF

install -o root -g root -m 0644 "$temporary_unit" "$unit_path"
systemctl daemon-reload
systemctl enable "$unit_name"

echo "<<< Registered service: $unit_name"
echo

# Step 6. Optionally start the service now.
if [[ "$run_now" == true ]]; then
    echo ">>> Starting service now..."
    systemctl start "$unit_name"
fi

# Step 7. Print the registration state and next user command.
echo "Unit file: $unit_path"
echo "Enabled: $(systemctl is-enabled "$unit_name")"
echo
echo "Start and check supervisor with:"
echo "  sudo systemctl start $service_name"
echo "  supervisorctl status"
