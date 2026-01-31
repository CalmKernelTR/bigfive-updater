# BigFive Updater - Roadmap

> Continuing development as a shell script.

---

## ✅ Completed Versions

### v3.x Series - Stability & Infrastructure
- [x] Color and character fixes
- [x] DNF/APT lock mechanism
- [x] `--dry-run` mode
- [x] `--skip` and `--only` flags
- [x] Config file support
- [x] Logrotate integration
- [x] Release automation (GitHub Actions)
- [x] BATS unit test infrastructure

### v4.x Series - Security & Quality
- [x] CODENAME in installation message
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
- [x] Alpine CI testing (alpine:3.20)
- [x] EDITION/CODENAME separation (Edition = series name, Codename = release name)
- [x] `bigfive` command alias (for international users)
- [x] 3 command support: `guncel`, `updater`, `bigfive`
- [x] Documentation standardization (`*.en.md` / `*.tr.md`)

---

## 🔜 Planned Features

### v5.3 "Beacon" - JSON Output ✅ COMPLETED
- [x] `--json` output format (for monitoring)
- [x] `--json-full` output format (for SIEM/audit)
- [x] Monitoring tools integration (Zabbix, Nagios, Prometheus)
- [x] SIEM integration (Wazuh, Splunk, ELK)
- [x] Machine-readable output

### v5.4 "Beacon" - Shell Integration ✅ COMPLETED
- [x] Bash completion (`completions/guncel.bash`)
- [x] Man page (`docs/guncel.8`)
- [x] Tab completion for options and backends
- [x] Full documentation via `man guncel`
- [x] Auto-install via `install.sh`
- [x] Total 138 BATS tests

### v5.5.0 "Dream" - Complete Rebranding ✅ COMPLETED
- [x] Project rename: `arcb-wider-updater` → `bigfive-updater`
- [x] GitHub repository renamed
- [x] All script and config references updated
- [x] Log/config/lock file paths updated
- [x] Docker test files updated

### v5.5.1 "Dream" - Error UX ✅ COMPLETED
- [x] Error code system (E001-E031)
- [x] User-friendly error messages
- [x] Solution suggestions (shown with 💡)
- [x] Better error explanations

### v5.5.2 "Dream" - Bug Fixes ✅ COMPLETED
- [x] Fixed pgrep dependency (Alpine/minimal container compatibility)
- [x] Fixed Zypper update counter
- [x] Complete documentation sync

### v6.0 "Echo" - Internationalization (i18n) ✅ COMPLETED
- [x] Move strings to separate file (`lang/tr.sh`, `lang/en.sh`)
- [x] Translation framework (`--lang` parameter, `BIGFIVE_LANG` env var)
- [x] Full English/Turkish support (~110 strings)
- [x] Automatic language detection based on system LANG

### v6.0.1 "Echo" - Bug Fixes ✅ COMPLETED
- [x] Fixed printf invalid number error (grep -c exit code issue)
- [x] Fixed all package manager counters

### v6.0.2 "Echo" - Packaging & Improvements ✅ COMPLETED
- [x] Disk space check (`check_disk_space()`, E040 error code)
- [x] Atomic self-update (install + mv pattern)
- [x] Turkish man page installation (install.sh Night-V1.4.1)
- [x] 13 new i18n BATS tests (total 151 tests)
- [x] **AUR Package:** https://aur.archlinux.org/packages/bigfive-updater
  - Install with `yay -S bigfive-updater`
- [x] **Alpine APKBUILD:** `packaging/alpine/APKBUILD`
  - Subpackages: doc, bash-completion, zsh-completion, fish-completion
- [x] **GitHub Actions Package Workflow:** `.github/workflows/packages.yml`
  - Automatic Arch and Alpine package build on each release

### v6.x+ "Chrom" - Notifications & GUI (Planned)
- [ ] Email notifications (SMTP)
- [ ] Webhook notifications (Slack, Discord)
- [ ] Systemd timer template
- [ ] Graphical user interface
- [ ] Desktop notifications

---

## 🏷️ Codename System (Thematic)

| Version | Edition | Codename | Feature | Metaphor |
|---------|---------|----------|---------|----------|
| v5.1-5.2 | BigFive | Alpine | APK support | Mountain/Distro |
| v5.3-5.4 | BigFive | Beacon | JSON + Shell integration | Signal/Monitoring |
| v5.5 | BigFive | Dream | Complete rebranding | Goal/Dream |
| v6.x | BigFive | Echo | Multi-language (i18n) | Echo/Voice |
| v6.x+ | BigFive | Chrom | GUI | Visual/Color |

---

## 💡 Ideas Under Consideration

| Idea | Status | Note |
|------|--------|------|
| AUR package | ✅ Completed | v6.0.2 - `yay -S bigfive-updater` |
| Alpine APKBUILD | ✅ Completed | v6.0.2 - Repo setup in progress |
| Desktop notifications | 🤔 Uncertain | Evaluating for v6.x |
| Parallel updates | ❌ Deferred | Risky, complex |
| Rust migration | ❌ Deferred | Bash is sufficient |
| Web UI | ❌ Out of scope | Staying CLI-focused |
| Plugin system | ❌ Deferred | Complexity |
| DEB/RPM packaging | ❌ Deferred | curl-pipe-bash is sufficient, high maintenance burden |

---

## 📊 Test Status

| Component | Test Count | Status |
|-----------|------------|--------|
| guncel.bats | 112 | ✅ |
| install.bats | 39 | ✅ |
| **Total** | **151** | ✅ |

### CI Test Matrix

| Distro | Package Manager | Status |
|--------|-----------------|--------|
| Ubuntu 24.04 | APT | ✅ |
| Fedora 40 | DNF | ✅ |
| Arch Linux | Pacman | ✅ |
| openSUSE Tumbleweed | Zypper | ✅ |
| Alpine 3.20 | APK | ✅ |

---

## 🤝 Contributing

Feel free to open an [Issue](https://github.com/CalmKernelTR/bigfive-updater/issues) for suggestions.

Detailed contribution guide: [CONTRIBUTING.en.md](CONTRIBUTING.en.md)
