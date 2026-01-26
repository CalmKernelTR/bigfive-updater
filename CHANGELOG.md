# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2026-01-26
### Changed
- **Header Simplified:** Removed version info from script header comment, keeping only project name and GitHub URL
- **VERSION:** 3.9.1 → 4.0.0
- **CODENAME:** "Tested" → "Polished"
- **Help Text Updated:** `--skip` option now shows `system` as a value alongside `dnf` and `apt`
  - New format: `Değerler: snapshot, flatpak, snap, fwupd, system (veya dnf, apt)`

### Improved
- **install.sh:** Now displays CODENAME alongside version after successful installation
  - New format: `✅ Kurulum Başarılı! (v4.0.0 - Polished)`

### Documentation
- Updated all README files (README.md, README.tr.md, README.en.md) with v4.0.0 version info
- Updated BATS tests to expect v4.0.0 and "Polished" codename

## [3.9.1] - 2026-01-26
### Fixed
- **DNF Lock Check:** Fixed broken `pgrep -x "dnf|yum|rpm"` pattern that was searching for literal string instead of alternatives
  - Now correctly uses: `! pgrep -x dnf && ! pgrep -x yum && ! pgrep -x rpm`

### Changed
- **SKIP_DNF → SKIP_PKG_MANAGER:** Renamed flag for semantic clarity
  - Old `SKIP_DNF` was misleading as it affected both APT and DNF
  - New `SKIP_PKG_MANAGER` clearly indicates it skips all package managers
  - Updated `--skip dnf|apt|system` option documentation
- VERSION: 3.9.0 → 3.9.1

## [3.9.0] - 2026-01-26
### Added
- **BATS Test Infrastructure:** Comprehensive unit test suite using Bash Automated Testing System
  - `tests/test_helper.bash`: Common helper functions for tests
  - `tests/guncel.bats`: Main test file with 30+ test cases
  - Tests cover: --help, --version, --dry-run, --skip/--only flags, color variables, critical functions
- **Enhanced CI Workflow:** Updated `.github/workflows/test.yml`
  - Added BATS installation and test execution
  - Separate jobs for shellcheck, syntax-check, bats-tests, help-output, version-output
- **README Test Section:** Added documentation for running tests locally
  - BATS installation instructions (apt, brew)
  - Test execution commands

### Changed
- VERSION: 3.8.2 → 3.9.0
- CODENAME: "Documented" → "Tested"

## [3.8.2] - 2026-01-26
### Fixed
- **Color Variable Fix:** Corrected ANSI escape sequences for terminal colors

## [3.8.1] - 2026-01-26
### Added
- **Test Automation:** New GitHub Actions workflow `.github/workflows/test.yml`
  - ShellCheck lint for `guncel` and `install.sh`
  - Bash syntax validation (`bash -n`)
  - `--help` output verification
  - Triggered on push and pull_request
- **README Split:** Separated documentation into language-specific files
  - `README.md` → Short overview with links to both languages
  - `README.tr.md` → Full Turkish documentation
  - `README.en.md` → Full English documentation
- **Version System Documentation:** Added explanation of dual versioning
  - `guncel`: SemVer (3.x.x) - Updated with every feature/fix
  - `install.sh`: Night-Vx.x.x - Updated only when install logic changes

### Fixed
- **fwupd Exit Code Handling:** `fwupdmgr get-updates` returns exit code 2 for "No updatable devices"
  - This is now treated as success (not an error)
  - Prevents false error messages on systems without updatable firmware
  - Both dry-run and actual update modes handle this correctly

### Changed
- VERSION: 3.8.0 → 3.8.1
- CODENAME: "Automated" → "Documented"
- **CONTRIBUTING.md:** Expanded with comprehensive guidelines
  - Code style: ShellCheck rules, 4-space indent, POSIX compatibility
  - Commit message format: `type(scope): description`
  - Version management: SemVer explanation, dual version system
  - Test scenarios: shellcheck, bash -n, --dry-run, --help
  - PR process: branch naming, review checklist

## [Night-V1.0.0] - 2026-01-26 (install.sh)
### Changed
- **install.sh artık ayrı versiyon sistemi kullanıyor**
  - Format: Night-Vx.x.x
  - Ana script (guncel) versiyonundan bağımsız
  - Kurulum banner: ">>> ARCB Wider Updater Kurulum (Night-V1.0.0)"


## [3.8.0] - 2026-01-26
### Added
- **GitHub Actions Release Automation:** Automatic release creation on tag push
  - New workflow: `.github/workflows/release.yml`
  - Trigger: `push tags v*`
  - Automatically generates `SHA256SUMS` for `guncel` and `install.sh`
  - Creates GitHub Release with checksums attached
- **--dry-run mode:** Preview updates without applying them
  - Shows available updates for APT, DNF, Flatpak, Snap, and Firmware
  - Uses native list commands: `apt list --upgradable`, `flatpak remote-ls --updates`, etc.
  - No changes made to system - safe for testing

### Changed
- VERSION: 3.7.2 → 3.8.0
- CODENAME: "Rotated" → "Automated"
- Updated --help with --dry-run option and examples
- Self-update skipped in dry-run mode

### Notes
- Release automation requires no additional setup - uses built-in GITHUB_TOKEN
- To create a release: `git tag v3.8.0 && git push origin v3.8.0`

## [3.7.2] - 2026-01-26
### Fixed
- **Hotfix:** Fixed Flatpak counter newline bug causing syntax error on Zorin OS 18
  - `wc -l` output sometimes contains newline characters that break arithmetic expressions
  - Added `tr -cd '0-9'` sanitization to all counter variables (flatpak, snap, fwupd)
  - Fixes: `[[: 0\n0: syntax error in expression` on line 666

## [3.7.1] - 2026-01-25
### Fixed
- Fixed install.sh color codes and first character display issue
- Changed echo -e to printf with ANSI-C quoting for reliable output

## [v3.7.0] - 2026-01-25

### Added
- **Logrotate support:** Automatic log rotation and cleanup
  - New config file: `/etc/logrotate.d/arcb-wider-updater`
  - Weekly rotation, keeps 4 weeks of logs
  - Compresses old logs automatically
  - Installed automatically via install.sh
- **Log management documentation:** Added to README (TR/EN)

### Changed
- VERSION: 3.6.1 → 3.7.0
- CODENAME: "Configurable" → "Rotated"
- Manual log cleanup in guncel disabled (logrotate handles it now)
- install.sh updated to install logrotate config

### Removed
- Manual 30-day log deletion (replaced by logrotate)

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
