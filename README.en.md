# ARCB Wider Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/arcb-wider-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)](https://github.com/ahm3t0t/arcb-wider-updater/blob/main/LICENSE)

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
| `guncel` (main script) | SemVer (x.x.x) | v5.2.1 (BigFive Edition - Alpine) | Every feature/fix |
| `install.sh` (installer) | Night-Vx.x.x | Night-V1.2.0 | Only when install logic changes |

**Naming Convention:**
- **Edition** = Major series name (e.g., "BigFive" for v5.x = 5 package managers)
- **Codename** = Minor release name (e.g., "Alpine" for v5.2.0 = APK support added)

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
✅ Kurulum Başarılı! (v4.1.4 - Signed)
```

### Manual Verification

```bash
# Import public key
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/pubkey.asc | gpg --import

# Verify signature
curl -fsSL https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
gpg --verify SHA256SUMS.asc SHA256SUMS
```

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
