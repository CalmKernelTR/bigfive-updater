# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [6.3.1] - 2026-02-05 "Fluent Edition - Golf"
### Fixed
- **Container detection critical fix:** `systemd-detect-virt` exit code issue
  - Returns exit 1 when running outside containers
  - Combined with `set -e` caused script to exit prematurely
  - Fixed by adding `|| true`

---

## [6.3.0] - 2026-02-05 "Fluent Edition - Golf"
### Added
- **Cron jitter support:** `--jitter N` parameter for server load distribution
  - Random delay (0-N seconds) for cron jobs
  - `BIGFIVE_JITTER` environment variable support
  - Prevents many servers updating at the same time
- **Container environment detection:** Warning for Docker/Podman/LXC environments
  - `/.dockerenv` file check (Docker)
  - `/run/.containerenv` file check (Podman)
  - `/proc/1/cgroup` content analysis (other containers)
  - `systemd-detect-virt --container` command (systemd-based)
  - Warning that updates in containers are not persistent

### Changed
- **Codename:** Foxtrot → Golf (v6.3.x minor series)

---

## [6.2.3] - 2026-02-05 "Fluent Edition - Foxtrot"
### Fixed
- **JSON mode print_error consistency:** `print_error()` function no longer writes to stdout in JSON mode
  - Now behaves the same as `print_error_with_hint()`
  - JSON output is now completely silent (only JSON + log)
  - Guarantees clean JSON output for monitoring systems

---

## [6.2.2] - 2026-02-03 "Fluent Edition - Foxtrot"
### Fixed
- **wget timeout improvement:** Added detailed timeout parameters
  - `--dns-timeout=10`: 10 seconds for DNS resolution
  - `--connect-timeout=10`: 10 seconds for connection establishment
  - `--read-timeout=30`: 30 seconds for each read operation
  - Reduced risk of hanging during large file downloads

---

## [6.2.1] - 2026-02-03 "Fluent Edition - Foxtrot"
### Fixed
- **GPG keyring isolation:** Added `GNUPGHOME` isolated temp keyring
  - System/root GPG keyring no longer polluted
  - Fresh temporary keyring created for each verification
  - Automatic cleanup after verification

---

## [6.2.0] - 2026-02-03 "Fluent Edition - Foxtrot"
### Added
- **GPG signature verification:** Added GPG signature verification for self-update
  - New function: `verify_gpg_signature()` - verifies SHA256SUMS.asc file
  - Public key automatically downloaded and imported from GitHub
  - Continues with warning if GPG is not installed (graceful degradation)
  - Invalid signature rejected with E032 error code
- **New URL constants:**
  - `GITHUB_SHA256_SIG_URL`: For signature file
  - `GITHUB_PUBKEY_URL`: For public key

### Changed
- **Codename:** Echo → Foxtrot (v6.2.x minor series)

---

## [6.1.1] - 2026-02-03 "Fluent Edition - Echo"
### Fixed
- **Timeout parameters:** Added timeouts to `download_file()` and connection checks
  - curl: `--connect-timeout 10 --max-time 300`
  - wget: `--timeout=30 --tries=2`
  - Prevents hanging on slow connections or firewall issues
- **Arch Linux reboot detection:** Added kernel module directory check
  - If `/usr/lib/modules/$(uname -r)` doesn't exist, reboot is required
- **DNF5 compatibility:** Added `dnf5` to `wait_for_dnf_lock()` pgrep check (Fedora 41+)
- **Code cleanup:** Removed unused `deleted_count` variable (logrotate handles cleanup)

---

## [6.1.0] - 2026-02-02 "Fluent Edition - Echo"
### Added
- **--doctor command:** System health check with 6 diagnostic tests
  - Config file syntax validation
  - Required commands check (curl/wget)
  - Optional commands check (flatpak, snap, fwupd, timeshift, snapper)
  - Disk space verification (500MB minimum)
  - Internet connectivity test (GitHub reachable)
  - Language files check
- **--history [N] command:** Update history viewer
  - Shows last N days of update logs (default: 7)
  - Displays date, time, status (OK/ERROR/DRY), and details
  - Parses log files from `/var/log/bigfive-updater/`
- **i18n for new commands:** Added ~50 MSG_ variables to both language files
  - `MSG_DOCTOR_*` messages for health check output
  - `MSG_HISTORY_*` messages for history display
  - `MSG_HELP_OPT_DOCTOR` and `MSG_HELP_OPT_HISTORY` for --help
- **Shell completion updates:** Added --doctor, --history, --lang to all shells
  - Bash: `completions/guncel.bash`
  - Zsh: `completions/_guncel`
  - Fish: `completions/guncel.fish`

### Fixed
- **Security improvements:**
  - `safe_source()`: Validates config file ownership and permissions before sourcing
  - `safe_mktemp()`: Secure temporary file creation with proper permissions
  - NOPASSWD check for --auto mode (E041 error code)
  - Relaxed ownership check for non-root users (allows user-owned configs)
- **ShellCheck fixes:** Removed unused variables (SC2034)
  - `pkg_count` in history function
  - `bad_commits` in release.sh

### Changed
- **release.sh:** Updated to Dev-V1.3.1
  - Added `get_current_version()` error handling
  - GPG signing for commits and tags
  - `escape_for_sed()` for injection prevention
  - `validate_version()` for X.Y.Z format
  - `cleanup_on_error()` trap for rollback
- **install.sh:** Updated to Night-V1.4.2
  - wget fallback for older systems without TLS 1.3
- **Man pages:** Updated to version 6.1.0
  - Added --doctor and --history documentation
  - Added examples for new commands

---

## [6.0.2] - 2026-01-30 "Fluent Edition - Echo"
### Added
- **Disk Space Check:** Pre-update disk space verification
  - Added `check_disk_space()` function
  - Default 500MB minimum requirement
  - User-friendly message with E040 error code
- **Turkish Man Page Installation (install.sh):**
  - `docs/guncel.8.tr` now installs to `/usr/share/man/tr/man8/guncel.8`
  - Access via `LANG=tr_TR.UTF-8 man guncel`
- **i18n BATS Tests:** 13 new tests added (total 151 tests)
  - `--lang tr/en` flag tests
  - `BIGFIVE_LANG` env var tests
  - Fallback and language file parity checks
- **AUR Package:** Official AUR package for Arch Linux users
  - Install via `yay -S bigfive-updater`
  - https://aur.archlinux.org/packages/bigfive-updater
- **Alpine APKBUILD:** Alpine Linux package support
  - Added `packaging/alpine/APKBUILD`
  - Subpackages: doc, bash-completion, zsh-completion, fish-completion
- **GitHub Actions Package Workflow:** Automatic package builds
  - `.github/workflows/packages.yml`
  - Arch and Alpine packages built automatically on release

### Changed
- **Atomic Self-Update:** Self-update mechanism now uses atomic replace pattern
  - Old: `install -m 0755 "$REMOTE_FILE" "$0"` (could corrupt on interruption)
  - New: `install -m 0755 "$REMOTE_FILE" "${0}.tmp" && mv "${0}.tmp" "$0"` (atomic)
  - `mv` is atomic on same filesystem - original preserved on interruption
- VERSION: 6.0.1 → 6.0.2
- install.sh VERSION: Night-V1.4.0 → Night-V1.4.1

---

## [6.0.1] - 2026-01-30 "Fluent Edition - Echo"
### Fixed
- **printf invalid number error:** `grep -c` was returning exit code 1 when no match,
  causing `|| echo "0"` to also run and produce double output (`0\n0`).
  This resulted in "invalid number" error for `printf %d`.
  - Affected: APT, DNF, Pacman, Zypper, APK, fwupd count parsing
  - Solution: `COUNT=$(... | grep -c ... 2>/dev/null) || COUNT=0`

### Changed
- VERSION: 6.0.0 → 6.0.1

---

## [6.0.0] - 2026-01-30 "Fluent Edition - Echo"
### Added
- **i18n (Multi-Language Support):** Full Turkish and English support
  - `lang/tr.sh`: Turkish language file (~110 strings)
  - `lang/en.sh`: English language file (~110 strings)
  - `--lang <code>` parameter for language selection (tr, en)
  - `BIGFIVE_LANG` environment variable support
  - Automatic language detection based on system LANG
- **Language File Locations:**
  - Installed: `/usr/share/bigfive-updater/lang/`
  - Development: `lang/` directory next to script

### Changed
- VERSION: 5.5.2 → 6.0.0
- CODENAME: Dream → Echo
- All user-facing messages moved to MSG_* variables

---

## [5.5.2] - 2026-01-30 "BigFive Edition - Dream"
### Fixed
- **pgrep dependency:** `wait_for_dnf_lock()` now skips DNF lock check when pgrep
  is not available (fixes issues on Alpine and minimal containers)
- **Zypper count parsing:** `update_zypper()` now correctly counts actual updates
  from output (counts Installing/Upgrading lines)

### Changed
- VERSION: 5.5.1 → 5.5.2

---

## [5.5.1] - 2026-01-30 "BigFive Edition - Dream"
### Added
- **Enhanced Error Messages (Error UX):** User-friendly error messages
  - `print_error_with_hint()`: Error + solution suggestion
  - `print_warning_with_hint()`: Warning + recommendation
  - Error code system (E001, E002, E010, E011, E020, E021, E030, E031)
- **Improved Error Messages:**
  - E001: curl/wget not found → installation suggestion
  - E002: sudo unavailable → alternative solution
  - E010: APT lock → check command
  - E011: DNF lock → process check
  - E020: Another update running → lock file info
  - E021: No internet connection → test command
  - E030: SHA256 verification failed → solution suggestion
  - E031: Update copy failed → disk/permission check

### Changed
- VERSION: 5.5.0 → 5.5.1

---

## [5.5.0] - 2026-01-30 "BigFive Edition - Dream"
### Added
- **Complete Rebranding:** Project renamed from `arcb-wider-updater` → `bigfive-updater`
  - GitHub repository renamed
  - All references updated (README, CHANGELOG, scripts, Docker)
  - Log directory: `/var/log/arcb-updater/` → `/var/log/bigfive-updater/`
  - Config file: `/etc/arcb-updater.conf` → `/etc/bigfive-updater.conf`
  - Lock file: `/var/lock/arcb-updater.lock` → `/var/lock/bigfive-updater.lock`
- **CODENAME:** "Dream" - full brand transition completed

### Changed
- VERSION: 5.4.8 → 5.5.0
- CODENAME: "Beacon" → "Dream"
- Banner: `ARCB-WIDER-UPDATER` → `BIGFIVE-UPDATER`
- GitHub URLs updated

---

## [5.4.8] - 2026-01-29 "BigFive Edition - Beacon"
### Added
- **Zsh completion:** Tab completion for Zsh shells (`completions/_guncel`)
  - Completion for all options and backends
  - Installs to `/usr/share/zsh/site-functions/`
- **Fish completion:** Tab completion for Fish shells (`completions/guncel.fish`)
  - Completion for all options and backends
  - Installs to `/usr/share/fish/vendor_completions.d/`
- **JSON package details:** List of updated packages in `--json-full` mode
  - Package info for APT, DNF, Pacman, Zypper, APK, Flatpak, Snap
  - Package name, old version, new version information
- **Snapshot timeout:** Timeout support for Timeshift/Snapper
  - `CONFIG_SNAPSHOT_TIMEOUT=300` (default 5 minutes)
  - JSON warning added on timeout
- **10 new BATS tests:** Zsh and Fish completion validation tests

### Changed
- install.sh version: Night-V1.3.1 → Night-V1.3.2
- Total BATS tests: 128 → 138

---

## [5.4.7] - 2026-01-29 "BigFive Edition - Beacon"
### Fixed
- **DNF5 counter parsing:** Parses "Upgrading: X packages" from Transaction Summary
  - DNF5 output format differs from DNF4, old patterns didn't work
  - Fixed "DNF: 0" display issue on Fedora 43+ systems
- **Zypper counter parsing:** Correctly parses package count from `zypper lu` output
  - Old `grep -c "^v"` pattern was incorrect
- **install.sh temp file cleanup:** Added TEMP_COMPLETION and TEMP_MAN to trap
  - Temp files are now cleaned up when script is interrupted

### Changed
- install.sh version: Night-V1.3.0 → Night-V1.3.1

---

## [5.4.6] - 2026-01-29 "BigFive Edition - Beacon"
### Fixed
- **Self-update download URL:** Changed `GITHUB_RAW_URL` from raw.githubusercontent.com to releases URL
  - raw.githubusercontent.com CDN cache could return stale file
  - SHA256SUMS comes from releases, causing hash mismatch
  - Now both file and SHA256 come from same source (releases)

---

## [5.4.5] - 2026-01-29 "BigFive Edition - Beacon"
### Fixed
- **Self-update SHA256 verification:** Fixed grep pattern in `check_self_update()` function
  - Old: `grep "guncel"` → matched `guncel`, `guncel.bash`, `guncel.8` (returned 3 hashes)
  - New: `grep -E "  guncel$"` → matches only `guncel` (single hash)
  - This bug completely blocked self-updates ("SHA256 verification failed" error)

---

## [5.4.3] - 2026-01-29 "BigFive Edition - Beacon"
### Fixed
- **Installation URL:** Changed from raw.githubusercontent.com to releases URL (avoids CDN cache issues)
- **SHA256 checksum verification:** Fixed grep pattern to match exact filename `guncel` (not `guncel.bash` or `guncel.8`)

### Changed
- **bigfive-updater.conf.example:** Updated to v5.4.x, added `CONFIG_JSON_MODE` option
- **guncel:** Added `CONFIG_JSON_MODE` support in `load_config()`

---

## [5.4.1] - 2026-01-29 "BigFive Edition - Beacon"
### Added
- **Man page:** Full manual page in troff format (`docs/guncel.8`)
  - Covers all options, backends, configuration, and examples
  - Symlinks for `man updater` and `man bigfive`
  - Auto-installed via `install.sh`
- **7 new BATS tests:** Man page validation tests

### Documentation
- Man page available via `man guncel`

---

## [5.4.0] - 2026-01-29 "BigFive Edition - Beacon"
### Added
- **Bash completion:** Tab completion for all options and backends
  - File: `completions/guncel.bash`
  - Supports `guncel`, `updater`, and `bigfive` commands
  - Completes `--skip` and `--only` with backend names
  - Auto-installed to `/usr/share/bash-completion/completions/`
- **8 new BATS tests:** Bash completion validation tests
- **install.sh:** Now installs bash completion and man page automatically

### Changed
- install.sh version: Night-V1.2.1 → Night-V1.3.0
- release.yml: Includes `guncel.bash` and `guncel.8` in release assets
- Total BATS tests: 70 → 85

---

## [5.3.0] - 2026-01-29 "BigFive Edition - Beacon"
### Added
- **JSON Output Mode:** New `--json` and `--json-full` flags for machine-readable output
  - `--json`: Lightweight JSON for monitoring systems (Zabbix, Nagios, Prometheus)
  - `--json-full`: Detailed JSON for SIEM/audit systems (Wazuh, Splunk, ELK)
- **JSON helper functions:** `json_escape()`, `add_pkg_manager_status()`, `get_distro_info()`
- **Package manager status tracking:** Each backend reports status to JSON output
- **New BATS tests:** 10 new JSON-related tests

### JSON Output Fields
- Lightweight (`--json`): version, status, exit_code, timestamp, hostname, duration_seconds, dry_run, updated_count, reboot_required
- Full (`--json-full`): All lightweight fields plus system info, package_managers array, packages array, snapshot info, warnings, errors

### Changed
- VERSION: 5.2.1 → 5.3.0
- JSON mode automatically enables quiet mode (no terminal output)

### Documentation
- Updated all README files with JSON output documentation
- Added JSON examples for monitoring integrations

---

## [5.2.1] - 2026-01-29 "BigFive Edition - Alpine"
### Added
- **EDITION variable:** Separate Edition name from Codename
  - Edition = Major series name (e.g., "BigFive" for v5.x)
  - Codename = Minor release name (e.g., "Alpine" for v5.2.x)
- **`bigfive` command alias:** International/brand name command
  - Now 3 commands available: `guncel` (Turkish), `updater` (English), `bigfive` (Brand)
- **Symlink cleanup in uninstall:** `do_uninstall()` now removes `updater` and `bigfive` symlinks

### Changed
- VERSION: 5.2.0 → 5.2.1
- Version display format: `v5.2.1 (BigFive Edition - Alpine)`
- `show_help()` now shows all three command aliases
- install.sh version: Night-V1.1.0 → Night-V1.2.0
- install.sh now creates `bigfive` symlink alongside `updater`

### Documentation
- Standardized all docs to `*.en.md` / `*.tr.md` naming convention
- Updated README files with Edition/Codename explanation
- Updated all version references

---

## [5.2.0] - 2026-01-28 "BigFive"
### Added
- **Alpine Linux Support:** New `update_apk()` function for Alpine Linux package management
  - `apk update && apk upgrade` for system updates
  - `apk cache clean` for cache cleanup
- **APK_COUNT variable:** Track Alpine package updates in summary
- **Alpine CI Testing:** Added Alpine 3.20 to multi-distro test matrix
- **New BATS tests:** 4 new APK-specific tests (60 total for guncel.bats)

### Changed
- VERSION: 5.0.0 → 5.2.0
- CODENAME: "BigFour" → "BigFive"
- `should_run_backend()` now recognizes `apk` as a valid backend
- Execution chain: `update_apt || update_dnf || update_pacman || update_zypper || update_apk`
- Help text updated with `--skip apk` and `--only apk` options
- `print_summary()` now displays APK update count

### Documentation
- Updated README.tr.md and README.en.md for BigFive
- Updated CI workflow comments

## [5.0.0] - 2026-01-28 "BigFour"
### Added
- **Arch Linux Support:** New `update_pacman()` function
  - `pacman -Sy && pacman -Su --noconfirm` for system updates
  - Orphan package cleanup with `pacman -Rns`
  - Cache cleanup with `paccache` (if available)
- **openSUSE Support:** New `update_zypper()` function
  - `zypper refresh && zypper --non-interactive update`
  - Orphan package detection
- **PACMAN_COUNT and ZYPPER_COUNT variables:** Track updates per backend
- **Multi-distro CI matrix:** Ubuntu, Fedora, Arch Linux, openSUSE Tumbleweed
- **New BATS tests:** 9 new BigFour tests (56 total)

### Changed
- VERSION: 4.1.4 → 5.0.0
- CODENAME: "Signed" → "BigFour"
- `should_run_backend()` now recognizes `pacman` and `zypper`
- Execution chain updated for 4 package managers
- Help text updated with BigFour options

### Documentation
- Comprehensive README updates for Arch and openSUSE users
- Docker test environment documentation

## [4.1.5] - 2026-01-28
### Added
- **`updater` symlink:** English alias for `guncel` command
- **TLS 1.2+ hardening:** All curl/wget calls now enforce modern TLS
  - curl: `--proto '=https' --tlsv1.2`
  - wget: `--secure-protocol=TLSv1_2`
- **PATH export:** Ensures Cron compatibility with standard system directories
- **`--uninstall` option:** Remove ARCB Wider Updater from system
- **`--uninstall --purge`:** Remove including config and logs

### Changed
- VERSION: 4.1.4 → 4.1.5
- install.sh creates `updater` symlink alongside `guncel`

### Security
- TLS hardening prevents downgrade attacks during downloads

## [4.1.4] - 2026-01-28
### Changed
- VERSION: 4.1.3 → 4.1.4
- Release automation test with `release.sh` script

## [4.1.3] - 2026-01-28
### Changed
- VERSION: 4.1.2 → 4.1.3
- Synchronized version number between code and GitHub release

## [4.1.2] - 2026-01-28
### Fixed
- **GitHub Actions GPG Signing:** Added `--batch --yes` flags for CI environment
  - Fixes "cannot open '/dev/tty'" error in non-interactive environment

### Changed
- VERSION: 4.1.0 → 4.1.2
- CODENAME: "Signed"

## [4.1.0] - 2026-01-28
### Added
- **Modular Update Functions:** Each backend (APT, DNF, Flatpak, Snap, Firmware) now has its own dedicated function
  - `update_apt()`, `update_dnf()`, `update_flatpak()`, `update_snap()`, `update_firmware()`
  - Cleaner code structure, easier to maintain and extend

### Changed
- VERSION: 4.0.0 → 4.1.0
- CODENAME: "Polished" → "Signed"
- Refactored `perform_updates()` to use modular functions

## [Night-V1.1.0] - 2026-01-28 (install.sh)
### Added
- **GPG Signature Verification:** Full cryptographic verification during installation
  - Downloads and imports public key from `pubkey.asc`
  - Verifies `SHA256SUMS.asc` signature against public key
  - Validates downloaded file hash against signed checksums
  - Installation aborted if verification fails
- **`updater` symlink:** English alias created during installation
- **TLS 1.2+ hardening:** Secure downloads with modern TLS
- New variables: `GPG_PUBKEY_URL`, `GPG_SHA256SUMS_URL`, `GPG_SHA256SUMS_SIG_URL`
- `verify_gpg_signature()` function with graceful fallback if GPG not installed

### Security
- **Supply Chain Security:** Prevents installation of tampered scripts
- GPG verification skipped for local file installations (developer workflow)

### Changed
- install.sh version: Night-V1.0.0 → Night-V1.1.0
- Banner updated: ">>> ARCB Wider Updater Kurulum (Night-V1.1.0)"

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
  - New config file: `/etc/logrotate.d/bigfive-updater`
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
- **Config file support:** `/etc/bigfive-updater.conf`
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
