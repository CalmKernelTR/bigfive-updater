# BigFive Updater 🛡️

[![CI Status](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/test.yml/badge.svg)](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/CalmKernelTR/bigfive-updater?sort=semver&label=Version)](https://github.com/CalmKernelTR/bigfive-updater/releases)
[![License](https://img.shields.io/github/license/CalmKernelTR/bigfive-updater)](https://github.com/CalmKernelTR/bigfive-updater/blob/main/LICENSE)

**Armored, Smart, Multi-Distro Update Tool for Linux Systems.**

> *The lazy but obsessive admin's best friend.*
> **One command. One updater. Zero nonsense.**

Performs Snapshot (Backup), Repository Updates, Flatpak/Snap and Firmware checks with a single command.

**v5.x = BigFive Edition** - Supports 5 package managers: APT (Debian/Ubuntu), DNF (Fedora/RHEL), Pacman (Arch/Manjaro), Zypper (openSUSE), and APK (Alpine).

**Available commands:** `guncel` (Turkish) | `updater` (English) | `bigfive` (Brand/International)

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

* **Multi-Distro Support (v5.1 BigFive):**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` package manager and `Timeshift` backup.
    * ✅ **Fedora/RHEL:** `DNF` package manager and `Snapper` backup.
    * ✅ **Arch/Manjaro/EndeavourOS:** `Pacman` package manager (v5.0+).
    * ✅ **openSUSE Leap/Tumbleweed:** `Zypper` package manager (v5.0+).
    * ✅ **Alpine Linux:** `APK` package manager (v5.1+).
* **Full Coverage:**
    * System packages, Flatpak, Snap and `fwupdmgr` (Firmware) updates.
* **Ironclad Security:**
    * Zero error tolerance with "Strict Mode" (`set -Eeuo pipefail`).
* **Selective Updates (v3.6.0+):**
    * `--skip` to skip specific backends (including `--skip system`).
    * `--only` to run only specified backends.
* **Dry-Run Mode (v3.8.0):**
    * `--dry-run` to preview updates without applying.
* **JSON Output (v5.3+):**
    * `--json`: Lightweight JSON for monitoring systems (Zabbix, Nagios, Prometheus).
    * `--json-full`: Detailed JSON for SIEM/audit systems (Wazuh, Splunk, ELK).
* **Shell Completion (v5.4+):**
    * Tab completion for all options and backends.
    * **Bash:** `/usr/share/bash-completion/completions/`
    * **Zsh:** `/usr/share/zsh/site-functions/` (v5.4.8+)
    * **Fish:** `/usr/share/fish/vendor_completions.d/` (v5.4.8+)
* **Man Page (v5.4+):**
    * Full documentation via `man guncel`.
* **Multi-Language Support (v6.0+ Echo):**
    * Full Turkish and English support.
    * `--lang tr` or `--lang en` for language selection.
    * `BIGFIVE_LANG` environment variable support.
    * Automatic language detection based on system LANG.
* **Disk Space Check (v6.0.2):**
    * Pre-update check for minimum 500MB free disk space.
    * E040 error code warning when space is insufficient.
* **Config File Support (v3.6.0):**
    * Define default settings in `/etc/bigfive-updater.conf`.
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
| `guncel` (main script) | SemVer (x.x.x) | v6.0.2 (BigFive Edition - Echo) | Every feature/fix |
| `install.sh` (installer) | Night-Vx.x.x | Night-V1.4.1 | Only when install logic changes |

**Naming Convention:**
- **Edition** = Major series name (e.g., "BigFive" for v5.x = 5 package managers)
- **Codename** = Minor release name (e.g., "Alpine" for v5.2.0 = APK support added)

**Why separate systems?**
- Main script updates frequently (new features, bug fixes)
- Installer script rarely changes (installation logic is stable)
- Users can clearly see which component was updated

---

## 📦 Installation

### Universal (All Distributions)

```bash
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash
```

### Arch Linux / Manjaro / EndeavourOS (AUR)

```bash
yay -S bigfive-updater   # or: paru -S bigfive-updater
```

### Alpine Linux (APK)

```bash
# 1. Add public key
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# 2. Add repository
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | \
    sudo tee -a /etc/apk/repositories

# 3. Install
sudo apk update && sudo apk add bigfive-updater
```

> **Package Repositories:**
> - AUR: https://aur.archlinux.org/packages/bigfive-updater
> - Alpine: https://ahm3t0t.github.io/bigfive-updater/

---

## 🛠️ Usage

After installation, use any of the three available commands: `guncel`, `updater`, or `bigfive`.

```bash
# Interactive Mode (Recommended - Provides detailed output)
guncel
updater
bigfive

# Automatic Mode (No prompts - For Cron/Scheduled tasks)
guncel --auto

# Verbose Mode (Shows all command outputs)
updater --verbose

# Quiet Mode (Shows only errors and summary)
bigfive --quiet

# Dry-Run Mode (v3.8.0) - List updates without applying
guncel --dry-run

# Selective Updates (v3.6.0)
guncel --skip flatpak,snap      # Skip Flatpak and Snap
guncel --skip snapshot          # Skip snapshot creation
guncel --only system            # Only system packages (APT/DNF/Pacman/Zypper/APK)
guncel --only flatpak,fwupd     # Only Flatpak and Firmware

# Language Selection (v6.0+ Echo)
guncel --lang en                # English output
guncel --lang tr                # Turkish output
BIGFIVE_LANG=en guncel          # Via environment variable
```

---

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `--auto` | Automatic mode - no prompts, ideal for cron jobs |
| `--verbose` | Verbose mode - shows all command outputs |
| `--quiet` | Quiet mode - shows only errors and final summary |
| `--dry-run` | Dry run - lists updates without applying |
| `--json` | JSON output - for monitoring systems (Zabbix, Nagios) |
| `--json-full` | Detailed JSON output - for SIEM/audit (Wazuh, Splunk) |
| `--skip <backend>` | Skip specified backends (comma-separated) |
| `--only <backend>` | Run only specified backends (comma-separated) |
| `--lang <tr\|en>` | Select output language (v6.0+) |
| `--uninstall` | Remove BigFive Updater (config/logs preserved) |
| `--uninstall --purge` | Completely remove including config and logs |
| `--help` | Display help message |

### Skip/Only Values

| Value | Description |
|-------|-------------|
| `snapshot` | Timeshift/Snapper backup |
| `flatpak` | Flatpak updates |
| `snap` | Snap updates |
| `fwupd` | Firmware updates |
| `system` | All system package managers (APT/DNF/Pacman/Zypper/APK) |
| `apt` | APT only (Debian/Ubuntu) |
| `dnf` | DNF only (Fedora/RHEL) |
| `pacman` | Pacman only (Arch Linux) |
| `zypper` | Zypper only (openSUSE) |
| `apk` | APK only (Alpine Linux) |

---

## ⚙️ Config File (v3.6.0)

Define default settings in `/etc/bigfive-updater.conf`:

```bash
# /etc/bigfive-updater.conf
# BigFive Updater Configuration File

# Default modes (true/false)
CONFIG_VERBOSE=false
CONFIG_QUIET=false
CONFIG_AUTO=false

# Skip backends by default (true/false)
CONFIG_SKIP_SNAPSHOT=false
CONFIG_SKIP_FLATPAK=false
CONFIG_SKIP_SNAP=false
CONFIG_SKIP_FWUPD=false
CONFIG_SKIP_PKG_MANAGER=false  # All system package managers (APT/DNF/Pacman/Zypper/APK)

# Snapshot timeout (seconds) - default 300 (5 minutes)
CONFIG_SNAPSHOT_TIMEOUT=300

# JSON output mode: none, json, json-full (v5.3+)
CONFIG_JSON_MODE=none
```

**Note:** Command line arguments override config file settings.

---

## 📊 JSON Output (v5.3.0+)

JSON output modes for monitoring and SIEM integration:

### Lightweight JSON (--json) - For Monitoring

```bash
sudo guncel --json
```

```json
{
  "version": "5.3.0",
  "status": "success",
  "exit_code": 0,
  "timestamp": "2026-01-29T13:30:00+03:00",
  "hostname": "srv-web-01",
  "duration_seconds": 45,
  "dry_run": false,
  "updated_count": 12,
  "reboot_required": false
}
```

### Detailed JSON (--json-full) - For SIEM/Audit

```bash
sudo guncel --json-full
```

```json
{
  "version": "5.3.0",
  "status": "success",
  "exit_code": 0,
  "timestamp": "2026-01-29T13:30:00+03:00",
  "hostname": "srv-web-01",
  "duration_seconds": 45,
  "dry_run": false,
  "reboot_required": false,
  "system": {
    "distro": "ubuntu",
    "distro_version": "24.04",
    "kernel": "6.8.0-45-generic"
  },
  "package_managers": [
    {"name": "apt", "status": "ran", "updated_count": 10},
    {"name": "flatpak", "status": "ran", "updated_count": 2}
  ],
  "packages": [],
  "snapshot": {
    "created": true,
    "name": "BigFive-Update-2026-01-29",
    "tool": "timeshift"
  },
  "warnings": [],
  "errors": []
}
```

### Usage Examples

```bash
# Use with Zabbix/Nagios
sudo guncel --json | jq '.status'

# Log for Wazuh/Splunk
sudo guncel --json-full >> /var/log/bigfive-updates.json

# Dry-run with JSON
sudo guncel --dry-run --json
```

---

## 🔐 GPG Signature Verification (v4.1.0+)

From **v4.1.0 onwards**, all releases are cryptographically signed with GPG.

### Verification During Installation

The `install.sh` script automatically:
1. Downloads and imports the public key (`pubkey.asc`)
2. Verifies the `SHA256SUMS.asc` signature
3. Validates the downloaded file's hash
4. Aborts installation if verification fails

```bash
# Example installation output:
🔐 GPG imza doğrulaması başlatılıyor...
   ✓ Public key import edildi
   ✓ GPG imzası doğrulandı
   ✓ SHA256 checksum doğrulandı
✅ Kurulum Başarılı! (v5.5.2 - Signed)
```

### Manual Verification

```bash
# Import public key
curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc | gpg --import

# Verify signature
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
gpg --verify SHA256SUMS.asc SHA256SUMS
```

---

## 💡 Error Codes and Hints (v5.5.1+)

From v5.5.1, errors are displayed with error codes and solution hints:

```
[X] ERROR [E010]: APT locks could not be released.
    💡 Solution: Another update may be running. Check with 'sudo lsof /var/lib/dpkg/lock-frontend'.
```

### Error Codes Table

| Code | Meaning | Solution Hint |
|------|---------|---------------|
| E001 | curl/wget not found | `apt install curl` or `dnf install curl` |
| E002 | Not root, no sudo | `su -c 'dnf install sudo'` or run as root |
| E010 | APT lock timeout | Wait for other update or check with `lsof` |
| E011 | DNF lock timeout | Close GNOME Software, check with `pgrep -a dnf` |
| E020 | Another bigfive running | `pgrep -a guncel` or remove lock file |
| E021 | No internet connection | Test with `ping google.com` |
| E030 | SHA256 verification failed | File corrupted, try again later |
| E031 | Update copy failed | Disk full or no write permission |
| E040 | Insufficient disk space | At least 500MB free space required, check with `df -h` |

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

Log files are stored in `/var/log/bigfive-updater/` and automatically managed by `logrotate`.

### Logrotate Configuration

During installation, `/etc/logrotate.d/bigfive-updater` is created:

```
/var/log/bigfive-updater/*.log {
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
ls -la /var/log/bigfive-updater/

# View latest log
cat /var/log/bigfive-updater/update_*.log | tail -50

# Manually run logrotate
sudo logrotate -f /etc/logrotate.d/bigfive-updater
```

---

## 🚀 Creating Releases (For Developers)

Use the `release.sh` script to create new releases:

```bash
./release.sh patch     # 4.1.4 → 4.1.5 (bug fix)
./release.sh minor     # 4.1.4 → 4.2.0 (new feature)
./release.sh major     # 4.1.4 → 5.0.0 (breaking change)
./release.sh 4.2.0     # manual version
```

The script automatically:
1. Updates VERSION in `guncel` file
2. Creates a commit
3. Creates and pushes a tag
4. Triggers GitHub Actions release workflow (including GPG signing)

---

## 🤝 Contributing

See [CONTRIBUTING.en.md](CONTRIBUTING.en.md) for contribution guidelines.

---

## 📄 License

[MIT License](LICENSE)
