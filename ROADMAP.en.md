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

### v6.1.0 "Echo" - Diagnostics & CI

Short-term improvements building on existing infrastructure.

- [x] `--history [N]` command: Parse log files and display update summary for the last N days
  - Default: N=7 (last 7 days)
  - Output: date, time, status (OK/HATA/DRY), details
  - Log format: `/var/log/bigfive-updater/update_YYYYMMDD_HHMMSS.log`
- [x] `--doctor` command: Config validation, dependency check, disk space, internet connectivity in one command
  - Config file syntax check
  - Required commands: curl/wget, package manager
  - Optional commands: jq, fwupd, flatpak, snap
  - Disk space: minimum 500MB free
  - Internet: GitHub raw URL ping
  - Lang files: existence check
- [ ] GitHub Actions CI matrix build: Automatic 5-distro testing on every PR (Docker base images ready)
- [ ] install.sh improvements: wget TLS flag modernize, grep portability, message clarity, variable cleanup
- [x] ~~Hook false positive fix~~ (completed in claude-code-skills repo, Fase 5)

### v6.2.0 "Fluent Edition - Foxtrot" - GPG Self-Update ✅

GPG signature verification for self-update.

- [x] **GPG signature verification:** `verify_gpg_signature()` function
  - SHA256SUMS.asc file validation
  - Public key auto-downloaded from GitHub
  - Graceful degradation: warns if GPG not installed
  - Invalid signature rejected with E032 error code
- [x] README Flatpak system-wide note added
- [x] Timeout parameters (curl/wget)
- [x] Arch Linux reboot detection (kernel module directory)
- [x] DNF5 compatibility (Fedora 41+)

### v6.3.0 "Fluent Edition - Chrom" - Server Automation

Automation features for server administrators.

- [ ] **Notification system:** Post `--auto` update notifications
  - Webhook (Slack, Discord, Teams, generic HTTP)
  - Email (SMTP)
  - Config file settings (`CONFIG_NOTIFY_*`)
- [ ] `--security-only` flag: Apply security updates only (APT/DNF/Zypper supported)
- [ ] **Pre/post update hooks:** `/etc/bigfive-updater/hooks.d/{pre,post}-update.sh` — user-defined scripts (backup, service restart, etc.)

### v7.0.0 "Zenith Edition" - Notification Templates & Setup

Fully integrated server automation experience.

- [ ] Notification template system (Slack Block Kit, Discord embed, Teams card formats)
- [ ] `guncel --setup` interactive first-run wizard (config + notification + cron)
- [ ] systemd timer generation (`guncel --timer create`)
- [ ] Notification config validation (`guncel --doctor --notify-test`)

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
| v6.3+ | Fluent | Chrom | Server automation |
| v7.0+ | Zenith | TBD | - |

---

## ❌ Out of Scope / Rejected

| Idea | Decision | Rationale |
|------|----------|-----------|
| GUI / Web UI | ❌ Rejected | BigFive is a CLI tool. External tools can integrate via JSON output |
| DEB/RPM packaging | ❌ Rejected | curl + GPG installation is sufficient, maintenance burden too high |
| Desktop notifications | ❌ Rejected | Server-focused tool, desktop notification is out of scope |
| Rust migration | ❌ Deferred | Bash is sufficient, POSIX compatibility is an advantage |
| Plugin system | ❌ Deferred | Low complexity/benefit ratio |
| Parallel updates | ❌ Deferred | Race condition risk, too complex |
| Snap/Flatpak package | ❌ Rejected | Requires root access and package manager, incompatible with sandbox |

---

## 📊 Test Status

| Component | Test Count | Status |
|-----------|------------|--------|
| guncel.bats | 131 | ✅ |
| install.bats | 39 | ✅ |
| **Total** | **170** | ✅ |

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
