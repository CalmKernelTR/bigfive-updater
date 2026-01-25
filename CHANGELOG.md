# Changelog

## [v3.6.0] - 2026-01-25

### Added
- **--skip/--only flags:** Selective backend execution
  - `--skip snapshot,flatpak,snap,fwupd,dnf` to skip specific backends
  - `--only system,flatpak,fwupd` to run only specified backends
  - Example: `guncel --skip flatpak,snap` or `guncel --only dnf`
- **Config file support:** `/etc/arcb-wider-updater.conf`
  - Define default modes, skip settings, and colors
  - Command line arguments override config settings
- **SHA256 verification during self-update:**
  - Downloads `SHA256SUMS` from GitHub Releases
  - Cancels update if hash doesn't match
  - Provides security against tampered downloads
- **.bak backup mechanism:**
  - Creates `/usr/local/bin/guncel.bak` before self-update
  - Enables easy rollback: `sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel`
  - install.sh also creates .bak backup

### Changed
- VERSION: 3.5.0 → 3.6.0
- CODENAME: "Locked & Loaded" → "Configurable"
- Argument parsing now uses while loop with shift for proper --skip/--only handling
- Updated --help output with new options and examples

### Security
- SHA256 hash verification prevents installation of tampered scripts
- Automatic rollback on failed updates

## [v3.5.0] - 2026-01-25

### Added
- Concurrent execution lock using `flock` (prevents cron + manual conflicts)
- DNF lock retry mechanism with `wait_for_dnf_lock()` function
  - Uses `pgrep` to check for running dnf/yum/rpm processes
  - Max 30 attempts with 10 second intervals
  - Gracefully skips DNF update if lock cannot be acquired

### Changed
- CODENAME: "Colorful" → "Locked & Loaded"

### Notes
- `flock` is typically included with `util-linux` package (pre-installed on most systems)

## [v3.4.6] - 2026-01-25

### Fixed
- Fixed missing first character in header display (echo -e issue)
- Fixed ANSI color codes that were broken (escape sequences restored)
- Fixed arithmetic syntax error on line 157 (counters now sanitized with tr -cd)
- Removed vertical bars (|) from header and summary boxes per user feedback

### Changed
- Header and summary now use horizontal lines only (=== and ---)
- Colorful output restored (green, blue, yellow ANSI colors)
- Codename changed from "Stable Output" to "Colorful"

## [v3.4.5] - 2026-01-25

### Fixed
- Fixed arithmetic syntax error on line 150 (strict mode compatibility)
- Fixed Unicode box drawing characters for terminal compatibility
- Replaced emoji characters with ASCII symbols for SSH/minimal systems


All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.4.4] - 2026-01-25

### Added
- Pre-update system header showing version, host, user, kernel, RAM, and disk usage.
- Post-update summary showing packages updated per backend, snapshot info, reboot status, and log path.
- `--verbose` mode: Shows all command outputs (like previous behavior).
- `--quiet` mode: Shows only errors and final summary.
- Reboot required detection for Debian (`/var/run/reboot-required`) and Fedora (`needs-restarting -r`).
- Update counters for APT, DNF, Flatpak, Snap, and Firmware.

### Changed
- Default mode now shows informative summaries without verbose command output.
- Codename changed from "Security Hardened" to "Informative".

## [3.4.3] - 2026-01-25

### Security
- Fixed a symbolic link vulnerability in the temporary file creation process.

## [3.4.2] - 2026-01-24

### Added
- Smart local file detection in the installer for easier development.
- Version synchronization between the installer and the main script.

### Fixed
- Full compatibility for Fedora (RHEL-based) systems.

## [3.4.0] - 2026-01-20

### Added
- "Ironclad" mode with `set -Eeuo pipefail` for robust error handling.
- Secure environment variable handling (`sudo -E`).
- Safe temporary file usage.

## [3.3.0] - 2026-01-15

### Added
- Initial support for Fedora/RHEL systems.
- DNF package manager and Snapper snapshot integration.
