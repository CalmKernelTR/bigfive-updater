# ARCB Wider Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/arcb-wider-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)](https://github.com/ahm3t0t/arcb-wider-updater/blob/main/LICENSE)

**Armored, Smart, Multi-Distro Update Tool for Linux Systems.**

> *The lazy but obsessive admin's best friend.*
> **One command. One updater. Zero nonsense.**

Performs Snapshot (Backup), Repository Updates, Flatpak/Snap and Firmware checks with a single command on Debian (Zorin OS, Ubuntu) and RHEL (Fedora) based systems.

## 📑 Table of Contents

- Features
- Version System
- Installation
- Usage
- Command Line Options
- Config File
- SHA256 Verification
- Rollback
- Log Management
- Contributing
- License

---

## 🚀 Features

* **Multi-Distro Support:**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` package manager and `Timeshift` backup.
    * ✅ **Fedora/RHEL:** `DNF` package manager and `Snapper` backup.
* **Full Coverage:**
    * System packages, Flatpak, Snap and `fwupdmgr` (Firmware) updates.
* **Ironclad Security:**
    * Zero error tolerance with "Strict Mode" (`set -Eeuo pipefail`).
* **Selective Updates (v3.6.0+):**
    * `--skip` to skip specific backends (including `--skip system`).
    * `--only` to run only specified backends.
* **Dry-Run Mode (v3.8.0):**
    * `--dry-run` to preview updates without applying.
* **Config File Support (v3.6.0):**
    * Define default settings in `/etc/arcb-wider-updater.conf`.
* **SHA256 Verification (v3.6.0):**
    * Hash verification during self-update for secure updates.
* **Automatic Backup (v3.6.0):**
    * `.bak` file created before each update for rollback capability.
* **Informative Summary:**
    * System info at start (host, kernel, RAM, disk).
    * Detailed summary at end (packages updated, reboot required).
* **Concurrent Execution Lock:**
    * Prevents cron and manual execution conflicts using `flock`.
* **DNF Lock Retry:**
    * Smart waiting mechanism for DNF/YUM/RPM operations.
* **Smart Installer:**
    * Safe privilege management when running via pipe (`curl | sudo bash`).
    * Local file detection (Developer friendly).

---

## 📦 Version System

This project uses **two separate version systems**:

| Component | Format | Current | Update Frequency |
|-----------|--------|---------|------------------|
| `guncel` (main script) | SemVer (x.x.x) | v4.0.0 | Every feature/fix |
| `install.sh` (installer) | Night-Vx.x.x | Night-V1.0.0 | Only when install logic changes |

**Why separate systems?**
- Main script updates frequently (new features, bug fixes)
- Installer script rarely changes (installation logic is stable)
- Users can clearly see which component was updated

---

## 📦 Installation (One-Liner)

Paste the following command into your terminal. The script will safely request necessary privileges and complete the installation:

```bash
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```

---

## 🛠️ Usage

After installation, simply type `guncel` in the terminal.

```bash
# Interactive Mode (Recommended - Provides detailed output)
guncel

# Automatic Mode (No prompts - For Cron/Scheduled tasks)
guncel --auto

# Verbose Mode (Shows all command outputs)
guncel --verbose

# Quiet Mode (Shows only errors and summary)
guncel --quiet

# Dry-Run Mode (v3.8.0) - List updates without applying
guncel --dry-run

# Selective Updates (v3.6.0)
guncel --skip flatpak,snap      # Skip Flatpak and Snap
guncel --skip snapshot          # Skip snapshot creation
guncel --only system            # Only system packages (APT/DNF)
guncel --only flatpak,fwupd     # Only Flatpak and Firmware
```

---

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `--auto` | Automatic mode - no prompts, ideal for cron jobs |
| `--verbose` | Verbose mode - shows all command outputs |
| `--quiet` | Quiet mode - shows only errors and final summary |
| `--dry-run` | Dry run - lists updates without applying |
| `--skip <backend>` | Skip specified backends (comma-separated) |
| `--only <backend>` | Run only specified backends (comma-separated) |
| `--help` | Display help message |

### Skip/Only Values

| Value | Description |
|-------|-------------|
| `snapshot` | Timeshift/Snapper backup |
| `flatpak` | Flatpak updates |
| `snap` | Snap updates |
| `fwupd` | Firmware updates |
| `dnf` / `apt` / `system` | System package manager |

---

## ⚙️ Config File (v3.6.0)

Define default settings in `/etc/arcb-wider-updater.conf`:

```bash
# /etc/arcb-wider-updater.conf
# ARCB Wider Updater Configuration File

# Default modes (true/false)
CONFIG_VERBOSE=false
CONFIG_QUIET=false
CONFIG_AUTO=false

# Skip backends by default (true/false)
CONFIG_SKIP_SNAPSHOT=false
CONFIG_SKIP_FLATPAK=false
CONFIG_SKIP_SNAP=false
CONFIG_SKIP_FWUPD=false
CONFIG_SKIP_DNF=false
```

**Note:** Command line arguments override config file settings.

---

## 🔒 SHA256 Verification (v3.6.0)

During self-update, the downloaded file's hash is compared against the `SHA256SUMS` file from GitHub Releases. If hashes don't match, the update is cancelled.

---

## 🔄 Rollback (v3.6.0)

Before each update, the old version is backed up to `/usr/local/bin/guncel.bak`. If you experience issues:

```bash
sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel
```

---

## 📝 Log Management (v3.7.0)

Log files are stored in `/var/log/arcb-updater/` and automatically managed by `logrotate`.

### Logrotate Configuration

During installation, `/etc/logrotate.d/arcb-wider-updater` is created:

```
/var/log/arcb-updater/*.log {
    weekly          # Rotate weekly
    rotate 4        # Keep 4 weeks
    compress        # Compress old logs
    delaycompress   # Don't compress last rotation
    missingok       # Don't error if log missing
    notifempty      # Don't rotate empty logs
    create 0600 root root
}
```

### Manual Log Control

```bash
# List log files
ls -la /var/log/arcb-updater/

# View latest log
cat /var/log/arcb-updater/update_*.log | tail -50

# Manually run logrotate
sudo logrotate -f /etc/logrotate.d/arcb-wider-updater
```

---

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## 📄 License

[MIT License](LICENSE)
