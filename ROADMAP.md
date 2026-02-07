# BigFive Updater - Roadmap

> We continue developing as a shell script. CLI-first, always.

---

## ✅ Completed Releases

### v3.x Series - Stability & Infrastructure
- [x] Color and character fixes
- [x] DNF/APT lock mechanism
- [x] `--dry-run` mode
- [x] `--skip` and `--only` flags
- [x] Configuration file support
- [x] Logrotate integration
- [x] Release automation (GitHub Actions)
- [x] BATS unit test infrastructure

### v4.x Series - Security & Quality
- [x] CODENAME in install messages
- [x] GPG signed releases
- [x] TLS 1.2+ hardening
- [x] `--uninstall` and `--purge` options
- [x] `updater` symlink (English alias)
- [x] 95 BATS tests (guncel + install.sh)

### v5.0.0 "BigFour" - Multi-Distro Support
- [x] **APT** - Debian/Ubuntu/Zorin
- [x] **DNF** - Fedora/RHEL
- [x] **Pacman** - Arch Linux/Manjaro/EndeavourOS
- [x] **Zypper** - openSUSE Leap/Tumbleweed
- [x] Multi-distro CI test matrix
- [x] Docker test environment

### v5.2.x BigFive Edition - Alpine Support
- [x] **APK** - Alpine Linux
- [x] 5 package manager support
- [x] Alpine CI test (alpine:3.20)
- [x] EDITION/CODENAME separation (Edition = series, Codename = release)
- [x] `bigfive` command alias (for international users)
- [x] 3 command aliases: `guncel`, `updater`, `bigfive`
- [x] Documentation standardization (`*.en.md` / `*.tr.md`)

### v5.3 "Beacon" - JSON Output
- [x] `--json` output format (for monitoring)
- [x] `--json-full` output format (for SIEM/audit)
- [x] Monitoring tools integration (Zabbix, Nagios, Prometheus)
- [x] SIEM integration (Wazuh, Splunk, ELK)

### v5.4 "Beacon" - Shell Integration
- [x] Bash/Zsh/Fish completion scripts
- [x] Man page (`man guncel`)
- [x] Automatic installation via `install.sh`
- [x] Total 138 BATS tests

### v5.5.0 "Dream" - Complete Rebranding
- [x] Project rename: `arcb-wider-updater` → `bigfive-updater`
- [x] All references updated

### v5.5.1 "Dream" - Error UX
- [x] Error code system (E001-E040)
- [x] User-friendly error messages with solution hints

### v5.5.2 "Dream" - Bug Fixes
- [x] pgrep dependency fix (Alpine compatibility)
- [x] Zypper update counter fix

### v6.0.x "Echo" - Internationalization (i18n)
- [x] Language files (`lang/tr.sh`, `lang/en.sh` — ~110 strings)
- [x] `--lang` parameter and `BIGFIVE_LANG` env var support
- [x] Automatic language detection from system LANG
- [x] printf bug fixes (grep -c exit code)
- [x] Disk space check (`check_disk_space()`, E040)
- [x] Atomic self-update (install + mv pattern)
- [x] Turkish man page installation (install.sh Night-V1.4.1)
- [x] 151 BATS tests (13 new i18n tests)
- [x] **AUR Package:** `yay -S bigfive-updater`
- [x] **Alpine APKBUILD** and personal Alpine repository
- [x] **Reboot detection** (post kernel-update warning)

---

## 🔜 Planned Features

### v6.1.0 "Fluent Edition - Echo" - Diagnostics & CI ✅

Short-term improvements building on existing infrastructure.

- [x] `--history [N]` command: Parse log files and display update summary for the last N days
- [x] `--doctor` command: Config validation, dependency check, disk space, internet connectivity
- [x] GitHub Actions CI matrix build: Automatic 5-distro testing on every PR
- [x] 170 BATS tests

### v6.2.0 "Fluent Edition - Foxtrot" - GPG Self-Update ✅

GPG signature verification for self-update.

- [x] **GPG signature verification:** `verify_gpg_signature()` function
- [x] README Flatpak system-wide note added
- [x] Timeout parameters (curl/wget)
- [x] Arch Linux reboot detection (kernel module directory)
- [x] DNF5 compatibility (Fedora 41+)

### v6.3.0 "Fluent Edition - Golf" - Cron & Container ✅

Server environment improvements.

- [x] **Cron jitter:** `--jitter` parameter for random delay (0-300s)
- [x] **Container detection:** Docker/Podman/LXC/systemd-nspawn environment awareness
- [x] JSON print_error fix (v6.2.3)

### v6.4.0 "Fluent Edition - Hotel" - Server Automation ✅

Full server automation features.

- [x] **`--security-only` flag:** Apply security updates only (APT/DNF/Zypper)
- [x] **Pre/post update hooks:** `/etc/bigfive-updater.d/{pre,post}.d/` directories
- [x] **Notification system:** ntfy, gotify, generic webhook support
- [x] **COPR Repository:** `dnf copr enable tahmet/bigfive-updater`
- [x] RPM packaging (Fedora/RHEL/CentOS)

### v6.5.0 "Fluent Edition - India" - Quality & Security ✅

- [x] **Expanded --doctor:** 6 → 9 health checks (permissions, GPG, lock file)
- [x] **Security hardening:** rm -rf protection, timeout mechanisms
- [x] **i18n:** New TR/EN translations for doctor checks
- [ ] Vulnerability scanning integration (--doctor --security) → v6.6.0
- [ ] GitHub Wiki documentation → v6.6.0

### v6.5.1 "Fluent Edition - India" - Audit Fixes ✅

- [x] **Security hardening:** chmod 777 fix, trufflehog SHA pinning, world-writable hook protection
- [x] **Code quality:** Array quoting, json_escape, BIGFIVE_REEXEC guard
- [x] **Shell completions:** --security-only, --jitter options added
- [x] **i18n:** 21 new MSG_* keys
- [x] **Tests:** 20 new BATS tests (193 total)
- [x] **CI:** Path-based filtering for docs-only PRs
- [x] **Packaging:** RPM, AUR, Alpine synced, do_doctor path fix

### v6.6.0 "Fluent Edition - Juliet" - Documentation & Vuln Scanning

- [ ] Vulnerability scanning integration (--doctor --security)
- [ ] GitHub Wiki documentation
- [ ] Gentoo (emerge) support consideration

### v7.0.0 "Zenith Edition" - Advanced Setup

Fully integrated server automation experience.

- [ ] `guncel --setup` interactive first-run wizard (config + notification + cron)
- [ ] systemd timer generation (`guncel --timer create`)
- [ ] Notification template system (Slack Block Kit, Discord embed)

---

## 🏷️ Codename System

**Methodology:**
- **Edition** = Major series name (v5.x, v6.x, v7.x)
- **Codename** = Minor version name (x.Y.z)
- **Repo name** = bigfive-updater (fixed)

### Edition Table

| Major | Edition | Theme |
|-------|---------|-------|
| v5.x | BigFive | 5 distro support |
| v6.x | Fluent | Smooth experience |
| v7.x | Zenith | Peak |

### Codename Table

| Version | Edition | Codename | Theme |
|---------|---------|----------|-------|
| v5.0 | BigFive | ~~BigFour~~ | 4 distro (transition) |
| v5.1-5.2 | BigFive | Alpine | APK support |
| v5.3-5.4 | BigFive | Beacon | JSON + Shell |
| v5.5 | BigFive | Dream | Rebranding |
| v6.0-6.1 | Fluent | Echo | i18n, diagnostics |
| v6.2 | Fluent | Foxtrot | GPG self-update |
| v6.3 | Fluent | Golf | Cron jitter, container |
| v6.4 | Fluent | Hotel | Server automation |
| v6.5 | Fluent | India | Quality & Security |
| v7.0+ | Zenith | TBD | - |

---

## ❌ Out of Scope / Rejected

| Idea | Decision | Rationale |
|------|----------|-----------|
| GUI / Web UI | ❌ Rejected | BigFive is a CLI tool. External tools can integrate via JSON output |
| DEB packaging | ⏳ Deferred | PPA requires separate effort, COPR is priority |
| Desktop notifications | ❌ Rejected | Server-focused tool, desktop notification is out of scope |
| Rust migration | ❌ Deferred | Bash is sufficient, POSIX compatibility is an advantage |
| Plugin system | ❌ Rejected | Maintenance nightmare, low benefit |
| Parallel updates | ❌ Rejected | Race condition risk, too complex |
| Snap/Flatpak package | ❌ Rejected | Requires root access and package manager, incompatible with sandbox |
| Telemetry | ❌ Rejected | Privacy concerns |

---

## 📊 Test Status

| Component | Test Count | Status |
|-----------|------------|--------|
| guncel.bats | 134 | ✅ |
| install.bats | 39 | ✅ |
| **Total** | **173** | ✅ |

### CI Test Matrix

| Distro | Package Manager | Docker Quick Test |
|--------|-----------------|-------------------|
| Ubuntu 24.04 | APT | ✅ 3/3 |
| Fedora 40 | DNF | ✅ 3/3 |
| Arch Linux | Pacman | ✅ 3/3 |
| openSUSE Leap 15.6 | Zypper | ✅ 3/3 |
| Alpine 3.20 | APK | ✅ 3/3 |

---

## 🤝 Contributing

Feel free to open an [Issue](https://github.com/CalmKernelTR/bigfive-updater/issues) with your suggestions.

Detailed contribution guide: [CONTRIBUTING.en.md](CONTRIBUTING.en.md)
