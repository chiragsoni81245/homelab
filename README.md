# homelab

> Turn a fresh Ubuntu Server installation into a fully configured homelab — with one command.

`homelab` is a bash-based provisioning script that takes a bare Ubuntu Server box and turns it into a ready-to-use self-hosted media/dev/network server: dev tools, Docker, Samba shares, a firewall, and a curated set of self-hosted applications, all driven by a single YAML config file.

<img width="1662" height="1035" alt="Screenshot 2026-07-08 at 12 47 25 AM" src="https://github.com/user-attachments/assets/53278ce7-c389-4904-8cf2-ef735a96cdb1" />

---

## What it sets up

**Terminal & dev tools**
- Neovim, tmux, common CLI utilities
- `yt-dlp`
- Docker & Docker Compose
- Samba (for network file shares)
- A sync tool for backing up data (GitHub / Google Drive)
- UFW (firewall), preconfigured for your LAN

**Applications (via Docker), each toggleable in config**

| Application | What it's for |
|---|---|
| [homelab-dashboard](https://github.com/chiragsoni81245/homelab-dashboard) | Central web UI showing system stats and links to every enabled app |
| `dns-server` | Local DNS server |
| `netbird-client` | WireGuard-based mesh VPN client |
| `ntopng` | Network traffic monitoring |
| `jellyfin-server` | Media server (movies/shows) |
| `navidrome` | Music streaming server (with `beets` for library tagging) |
| `metube` | Web UI for downloading video/audio via yt-dlp |
| `portainer` | Docker container management UI |
| `transmission` | Torrent client |
| `nginx-proxy-manager` | Reverse proxy + SSL termination for all your services |
| `web-nvim` | Neovim in the browser |
| `planka` | Trello-style kanban board |

Every application is optional — enable only what you need in your config file.

---

## Requirements

- A fresh install of **Ubuntu Server** (recommended: run this on a clean machine/VM — the script installs packages, configures the firewall, and reboots the system)
- A user with `sudo` access
- Internet access on the machine

---

## How to run it

### 1. Boot straight from GitHub (recommended)

On your fresh Ubuntu Server install, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/chiragsoni81245/homelab/main/boot.sh)
```

This will:
1. Update apt and install `git`, `curl`, and `pipx`
2. Clone this repo into `~/.local/share/homelab`
3. Kick off `install.sh`, which installs everything and reboots at the end

**Using a fork or a specific branch:** if you've forked this repo or want to customize the config in your own copy, point the bootstrap script at it with environment variables:

```bash
HOMELAB_REPO="your-username/homelab" HOMELAB_REF="main" \
  bash <(curl -fsSL https://raw.githubusercontent.com/chiragsoni81245/homelab/main/boot.sh)
```

### 2. Or clone and run it manually

```bash
git clone https://github.com/chiragsoni81245/homelab.git ~/.local/share/homelab
cd ~/.local/share/homelab
bash install.sh
```

### 3. Configure before you run it (optional but recommended)

The installer reads its settings from `~/.local/share/homelab/config.yaml`. If that file doesn't exist, it falls back to the repo's `default-config.yaml`.

Before installing, copy the default config and edit it to match your setup:

```bash
cp ~/.local/share/homelab/default-config.yaml ~/.local/share/homelab/config.yaml
nano ~/.local/share/homelab/config.yaml
```

At minimum, review:
- `profile` — your username/email
- `server.lan_cidr` — your local network's CIDR range (used by UFW rules)
- `samba.shares` — the folders you want to expose as network shares, and who can access them
- `applications.*` — set `enable: true`/`false` per app, and update paths, ports, usernames, and passwords to your own values (the defaults use placeholder passwords — **do not leave these unchanged**)
- `sync-tool` — uncomment and fill in if you want scheduled backups to GitHub/Google Drive

### 4. What happens during install

`install.sh` runs through four stages:

1. **Configuration** — becomes root/sudo, loads your config, sets the system timezone
2. **Terminal tools** — installs Neovim, tmux, yt-dlp, Docker, Samba, the sync tool, and UFW
3. **Applications** — brings up the enabled applications as Docker containers, based on your config
4. **Updates** — runs `apt update && apt upgrade`, then reboots

The whole process is unattended after you start it — grab a coffee and let it finish. The machine will reboot automatically at the end.

### 5. After install

- Visit the **homelab-dashboard** (if enabled) to see all your running services and system stats in one place.
- Re-run `bash ~/.local/share/homelab/install.sh` any time to re-apply your config (e.g. after enabling a new application or changing a setting) — the script is designed to be safely re-run.
- If installation fails partway through, the script will tell you how to retry.

---

## Repository structure

```
homelab/
├── applications/         # Per-application Docker configs/compose files
├── bin/                  # Helper scripts/executables
├── config/               # Config-related install scripts (sudo, config parsing, timezone)
├── default/              # Default files used by the installer
├── install/               # Modular install scripts sourced by install.sh
├── boot.sh               # One-liner entry point: clones the repo and starts install.sh
├── install.sh            # Main installer, orchestrates the whole setup
├── default-config.yaml   # Template/example configuration — copy to config.yaml and customize
└── logo.txt              # ASCII art shown during install
```

---

## Customizing

Since everything is driven by `config.yaml`, the easiest way to adapt this to your own hardware is to:

1. Fork the repo (optional, but useful if you want to track your own config in git)
2. Edit `default-config.yaml` (or your own `config.yaml`) with your paths, ports, and credentials
3. Add/remove applications under `applications:` as needed
4. Re-run `install.sh`

## Related projects

- [homelab-dashboard](https://github.com/chiragsoni81245/homelab-dashboard) — the dashboard UI used by this project (also usable standalone)

## Contributing

Issues and pull requests are welcome — this is very much a personal setup shared for others building their own homelab.
