# `supervisor` in Linux

This repo contains a `uv` project and templates to run [`supervisor`](https://pypi.org/project/supervisor/) on Linux.


## Table of Contents

1. [How to use `supervisor`](#how-to-use-supervisor)
2. [Adding an app to `supervisor`](#adding-an-app-to-supervisor)
3. [Quick installation with `uv`](#quick-installation-with-uv)
4. [One-shot setup script](#one-shot-setup-script)
5. [Manual `systemd` setup](#manual-systemd-setup)
6. [Uninstalling `supervisor`](#uninstalling-supervisor)
7. [Remove an old package-manager install](#remove-an-old-package-manager-install)
8. [Developer's note](#developers-note)

## How to use `supervisor`

### Startup `supervisor`

The `supervisor` service in `systemd` should run automatically after starting up the computer.

To start the `supervisor` service manually, run the command below in a Bash terminal to start `supervisord` installed as a service in `systemd`:

   ```bash
   sudo systemctl start supervisor
   ```

### Monitoring & Managing processes

There are Web UI and CLI to monitor and manage the processes registered in `supervisor`.
The Web UI requires logging in; use the `username` and `password` set in the `[inet_http_server]` section in the `supervisord.conf` file.
The CLI connects through a user-only Unix socket and does not require those credentials.

#### Web UI

Open `http://localhost:9001` in a browser to use the Supervisor web UI, and it will show the statuses of the registered processes and let you control them.

[`multivisor`](https://github.com/SinclairQuantumLab/multivisor-web.git) provides a nice centralized monitoring and control Web dashboard if the `supervisor` is set up for it (see the relevant step in the [Quick installation with uv](#quick-installation-with-uv) section) and registered with a `multivisor` server.

#### CLI

In a Bash terminal, run:

```bash
supervisorctl
```

One can either establish a supervisor control session with a `supervisor>` prompt or directly call the `supervisorctl` commands below without entering the `supervisor` session, as in the example below:

```bash
supervisorctl status
```

##### `supervisorctl` commands

Check the statuses of registered processes:

```bash
supervisor> status
```

Start, stop, or restart one app:

```bash
supervisor> start myapp
supervisor> stop myapp
supervisor> restart myapp
```

### Shutdown `supervisor`

   ```bash
   sudo systemctl stop supervisor
   ```

## Adding an app to `supervisor`

1. Copy the app config template in `$HOME/Projects/supervisor/conf.d/` folder:

   ```bash
   cd "$HOME/Projects/supervisor"
   cp './conf.d/[APPNAME].conf.template' './conf.d/<APPNAME>.conf'
   ```

   Replace: `<APPNAME>` with the name of the app in `supervisor`.

2. Edit the `.conf` above.

   Replace:

   - `<APPNAME>` with the Supervisor app name
   - `command=` with the real app startup command

      For a Python app,

      1. Copy `python/Startup.sh` into the app project folder and configure it; especially, update the location of the Python script to run in the `py_path` variable.
      2. In the `.conf` file, set the following:

         ```ini
         command=/usr/bin/env bash "%(ENV_HOME)s/Projects/%(program_name)s/Startup.sh"
         ```

      In `supervisor`, `%(ENV_HOME)s` and `%(program_name)s` refer to `$HOME` and the app's name set in the `.conf` file.

   Add further configuration items found in https://supervisord.org/configuration.html#program-x-section-settings or https://supervisord.org/configuration.html#group-x-section-settings as needed.

3. Update `supervisor` with the new `.conf` file (see the [CLI](#cli) section above):

   ```bash
   supervisorctl update
   ```

   Check if the new app appears in the `supervisor` interface; see [Monitoring & Managing processes](#monitoring--managing-processes).

## Quick installation with `uv`

If this computer already has an old `supervisor` installed through a Linux package manager, remove it first. See the [Remove an old package-manager install](#remove-an-old-package-manager-install) section.

1. If `uv` has not been installed, install it by following [the official installation guide](https://docs.astral.sh/uv/getting-started/installation/).
   **Close and reopen Bash after installing `uv`**.

2. Open Bash and clone this repo in the `$HOME/Projects/` folder:

   ```bash
   mkdir -p "$HOME/Projects"
   cd "$HOME/Projects"
   git clone https://github.com/SinclairQuantumLab/supervisor-linux.git supervisor
   ```

3. Go to the created folder and run `uv sync`:

   ```bash
   cd supervisor
   uv sync
   ```

4. Make `supervisorctl` available from Bash.

   ```bash
   chmod +x ./supervisorctl.sh
   mkdir -p "$HOME/.local/bin"
   ln -sf "$(pwd -P)/supervisorctl.sh" "$HOME/.local/bin/supervisorctl"
   ```

   The wrapper always loads this project's `supervisord.conf`, so `supervisorctl` can find the Linux Unix socket from any folder. `~/.local/bin` must be in `PATH`. If the shell cannot find `supervisorctl`, add that folder to the user's shell configuration and open a new terminal.

5. Create the `supervisord` config file from the template:

   ```bash
   cp ./supervisord.conf.template ./supervisord.conf
   chmod 600 ./supervisord.conf
   ```

6. Open the `supervisord.conf` file and replace the `<PASSWORD>` placeholder with our usual password.

7. Register `supervisord` as a system-level `systemd` service that runs as the deployment user. Run this command from the deployment user's normal Bash terminal:

   ```bash
   sudo bash ./mount-supervisord-systemd.sh
   ```

   This creates a `systemd` service named `supervisor`.

   The helper uses the current repo and `SUDO_USER` to identify the deployment user. Before writing the unit, it checks the Linux virtual environment and requires `supervisord.conf` to be owned by that user without group or other access. It reloads `systemd`, enables the service at boot, and configures it to run `Startup_supervisord.sh` as the deployment user. It starts the service immediately only when `--run-now` is passed.

8. Start the `systemd` service and check that `supervisord` responds:

   ```bash
   sudo systemctl start supervisor
   ```

9. Test if `supervisor` runs successfully.

   - In terminal:

     ```bash
     supervisorctl
     ```

     `supervisor` is running if the `supervisor>` prompt shows up.
     Get out of the prompt by entering `exit`.

   - Web UI: go to `http://localhost:9001` in a web browser and `supervisor` is running if it shows the control UI.

   The following commands are useful for checking the service and troubleshooting startup:

   ```bash
   systemctl status supervisor
   sudo journalctl -u supervisor.service -n 50
   sudo journalctl -u supervisor.service -f
   systemctl cat supervisor
   ```

10. (Optional) register the installed `supervisor` with `multivisor`.

    ```bash
    uv run python -c "from multivisor.rpc import make_rpc_interface; print('RPC import OK')"
    ```

    If using Multivisor, confirm the `[rpcinterface:multivisor]` section in `supervisord.conf` and open the required firewall port for the environment.

    Replace `<TRUSTED_INTERFACE_IP>` with a loopback or private-interface address reachable by the trusted Multivisor server before uncommenting that section. Allow TCP port 9002 only from that server; do not expose this unauthenticated RPC endpoint to an untrusted network. Restart the service after editing the config:

    ```bash
    sudo systemctl restart supervisor
    ```

That's it. `supervisord` should now start automatically when this Linux computer boots.

## One-shot setup script

Copy and paste the script below into a Bash terminal opened as the deployment user.

```bash
(
set -euo pipefail

install_dir="$HOME/Projects/supervisor"
if [[ -e "$install_dir" ]]; then
    printf 'Refusing to overwrite existing path: %s\n' "$install_dir" >&2
    exit 1
fi

# install supervisor-linux in ~/Projects/supervisor
mkdir -p "$HOME/Projects"
cd "$HOME/Projects"
git clone https://github.com/SinclairQuantumLab/supervisor-linux.git supervisor
cd supervisor
uv sync
# create symbolic link for supervisorctl in user `bin` folder
chmod +x ./supervisorctl.sh
mkdir -p "$HOME/.local/bin"
ln -sf "$(pwd -P)/supervisorctl.sh" "$HOME/.local/bin/supervisorctl"
# create `supervisord.conf` file from the template
cp ./supervisord.conf.template ./supervisord.conf
chmod 600 ./supervisord.conf
)
```

**Make sure to replace the `<PASSWORD>` placeholder with our usual password in `$HOME/Projects/supervisor/supervisord.conf`.**

Then register and start the service:

```bash
# create `supervisor` service in systemd to run supervisord
sudo bash "$HOME/Projects/supervisor/mount-supervisord-systemd.sh"
# start `supervisor` service
sudo systemctl start supervisor
```

## Manual `systemd` setup

While the Bash script in [Quick installation with uv](#quick-installation-with-uv) provides a quick way to set up the `supervisor` service, manual `systemd` setup is also useful because it shows the Linux settings directly.

1. Open `/etc/systemd/system/supervisor.service` as root and use the following content:

   ```ini
   [Unit]
   Description=Supervisor process control system for UNIX
   Documentation=https://supervisord.org/
   After=network.target

   [Service]
   Type=simple
   User=<LINUX_USERNAME>
   Environment="HOME=<LINUX_HOME>"
   WorkingDirectory="<REPO_ROOT>"
   ExecStart=/bin/bash "<REPO_ROOT>/Startup_supervisord.sh"
   Restart=on-failure
   RestartSec=60s
   KillMode=mixed

   [Install]
   WantedBy=multi-user.target
   ```

2. Replace `<LINUX_USERNAME>` with the deployment user's Linux account name, `<LINUX_HOME>` with that account's home directory, and `<REPO_ROOT>` with the absolute checkout path. For the normal layout these paths are `/home/<LINUX_USERNAME>` and `/home/<LINUX_USERNAME>/Projects/supervisor`.

3. Reload `systemd`, enable the service, and start it:

   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable supervisor
   sudo systemctl start supervisor
   ```

4. Verify the service:

   ```bash
   systemctl is-active supervisor
   systemctl is-enabled supervisor
   ```

Custom system-level unit files belong in `/etc/systemd/system/`. Files there override distribution-provided units with the same service name.

## Uninstalling `supervisor`

You may need to open a Bash terminal with `sudo` access for some of the steps below.

1. [Shut down the running `supervisor` instance](#shutdown-supervisor), if any.

2. Delete the `supervisor` service created in `systemd` by running:

   ```bash
   sudo systemctl disable supervisor
   sudo rm -f /etc/systemd/system/supervisor.service
   sudo systemctl daemon-reload
   sudo systemctl reset-failed supervisor
   ```

3. Remove the `supervisor` project folder:

   This also removes its runtime config and logs, so save anything needed first.

   ```bash
   rm -r "$HOME/Projects/supervisor"
   ```

4. Remove the symlink to `supervisorctl` in the user bin folder:

   ```bash
   rm -f "$HOME/.local/bin/supervisorctl"
   ```

This does not remove the app projects that were managed by `supervisor`.

## Remove an old package-manager install

Use this only if the computer already has `supervisor` installed through a Linux distribution package manager.

Open a Bash terminal with `sudo` access for this section.

An existing package installation can use the same service name, port, or runtime paths as this repo.

On Debian or Ubuntu, check whether the package is installed:

```bash
apt list --installed supervisor 2>/dev/null
```

If it is installed, stop its service and remove the package before following the quick installation:

```bash
sudo systemctl disable --now supervisor
sudo apt remove supervisor
```

For another Linux distribution, use its package manager to remove the equivalent `supervisor` package. Back up any app configs that are still needed before removing `/etc/supervisor/`; this repo uses `~/Projects/supervisor/` instead.

## Developer's note

- This repository was split from [supervisor-setting](https://github.com/SinclairQuantumLab/supervisor-setting.git) GitHub repo at commit d1f44233a3bccc7364d7ea797976f2e0ddf3d9c7.

- The high-level flow of launching `supervisor` and registered apps:

   > systemd -> Startup_supervisord.sh -> supervisord -> apps in conf.d/*.conf

- Why use a system-level `systemd` service to run `supervisord`?

   A system-level `systemd` service starts `supervisord` at boot while running it as the deployment user.
   `Startup_supervisord.sh` uses `-n` to keep `supervisord` in the foreground so `systemd` can track and restart the process correctly.
