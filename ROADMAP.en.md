# ARCB Wider Updater - Roadmap

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
- [x] 85 BATS tests total

### v5.5+ - User Experience (Planned)
- [ ] Graceful error messages
- [ ] Better error explanations
- [ ] Solution suggestions

### v5.6+ - Advanced Configuration (Planned)
- [ ] Email notifications (SMTP)
- [ ] Webhook notifications (Slack, Discord)
- [ ] Systemd timer template

### v6.0 "Echo" - Internationalization (i18n) (Planned)
- [ ] Move strings to separate file
- [ ] Translation framework
- [ ] Full English/Turkish support

### v6.x+ "Chrom" - GUI (Planned)
- [ ] Graphical user interface
- [ ] Desktop notifications

---

## 🏷️ Codename System (Thematic)

| Version | Edition | Codename | Feature | Metaphor |
|---------|---------|----------|---------|----------|
| v5.1-5.2 | BigFive | Alpine | APK support | Mountain/Distro |
| v5.3 | BigFive | Beacon | JSON output | Signal/Monitoring |
| v6.x | BigFive | Echo | Multi-language (i18n) | Echo/Voice |
| v6.x+ | BigFive | Chrom | GUI | Visual/Color |

---

## 💡 Ideas Under Consideration

| Idea | Status | Note |
|------|--------|------|
| Desktop notifications | 🤔 Uncertain | Evaluating for v6.x |
| Parallel updates | ❌ Deferred | Risky, complex |
| Rust migration | ❌ Deferred | Bash is sufficient |
| Web UI | ❌ Out of scope | Staying CLI-focused |
| Plugin system | ❌ Deferred | Complexity |
| DEB/RPM packaging | ❌ Deferred | curl-pipe-bash is sufficient |

---

## 📊 Test Status

| Component | Test Count | Status |
|-----------|------------|--------|
| guncel.bats | 70 | ✅ |
| install.bats | 35 | ✅ |
| **Total** | **105** | ✅ |

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

Feel free to open an [Issue](https://github.com/ahm3t0t/arcb-wider-updater/issues) for suggestions.

Detailed contribution guide: [CONTRIBUTING.en.md](CONTRIBUTING.en.md)
