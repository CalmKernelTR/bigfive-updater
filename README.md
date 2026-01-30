# BigFive Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/bigfive-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/bigfive-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/ahm3t0t/bigfive-updater/actions/workflows/test.yml/badge.svg)](https://github.com/ahm3t0t/bigfive-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/bigfive-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/bigfive-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/bigfive-updater)](https://github.com/ahm3t0t/bigfive-updater/blob/main/LICENSE)
![GitHub last commit](https://img.shields.io/github/last-commit/ahm3t0t/bigfive-updater)
![GitHub code size](https://img.shields.io/github/languages/code-size/ahm3t0t/bigfive-updater)

**Linux sistemleri için Zırhlı, Akıllı ve Çoklu-Dağıtım (Multi-Distro) Güncelleme Aracı.**

**Armored, Smart, Multi-Distro Update Tool for Linux Systems.**

> *Tembel ama takıntılı adminin en yakın dostu.*
> **One command. One updater. Zero nonsense.**

---

## 🌐 Documentation / Dokümantasyon

| Language | Documentation | Roadmap | Changelog |
|----------|---------------|---------|-----------|
| 🇹🇷 Türkçe | [README.tr.md](README.tr.md) | [ROADMAP.tr.md](ROADMAP.tr.md) | [CHANGELOG.tr.md](CHANGELOG.tr.md) |
| 🇬🇧 English | [README.en.md](README.en.md) | [ROADMAP.en.md](ROADMAP.en.md) | [CHANGELOG.en.md](CHANGELOG.en.md) |

---

## 🚀 Quick Start / Hızlı Başlangıç

```bash
# Installation / Kurulum (Universal - All Distros)
curl -fsSL https://github.com/ahm3t0t/bigfive-updater/releases/latest/download/install.sh | sudo bash

# Arch Linux / Manjaro / EndeavourOS (AUR)
yay -S bigfive-updater   # veya: paru -S bigfive-updater

# Alpine Linux (APK) - See README.en.md or README.tr.md for full instructions
# Quick: Add key + repo, then: apk add bigfive-updater
```
```bash
# Usage / Kullanım (3 alias: guncel, updater, bigfive)
guncel              # Interactive mode / İnteraktif mod
updater --verbose   # Show details / Detayları göster
bigfive --quiet     # Quiet mode / Sessiz mod
guncel --auto       # Automatic mode / Otomatik mod
guncel --dry-run    # Preview updates / Güncellemeleri önizle
guncel --lang en    # English output / İngilizce çıktı (v6.0+)
guncel --help       # Help / Yardım
```

---

## 📦 Version System / Sürüm Sistemi

Bu proje iki ayrı versiyon sistemi kullanır:

This project uses two separate version systems:

| Component | Format | Current | Update Frequency |
|-----------|--------|---------|------------------|
| `guncel` (main script) | SemVer (x.x.x) | v6.0.2 (BigFive Edition - Echo) | Her özellik/fix'te / Every feature/fix |
| `install.sh` (installer) | Night-Vx.x.x | Night-V1.4.1 | Sadece kurulum değiştiğinde / Only when install logic changes |

**Neden ayrı? / Why separate?**
- Ana script sık güncellenir, installer nadiren değişir
- Main script updates frequently, installer rarely changes

---

## 📋 Features / Özellikler

### BigFive Edition - Multi-Distro Support (v5.x)

**v5.x = BigFive Edition** (5 paket yöneticisi desteği / 5 package managers supported)
- ✅ **APT** - Debian/Ubuntu/Zorin/Linux Mint
- ✅ **DNF** - Fedora/RHEL/CentOS
- ✅ **Pacman** - Arch Linux/Manjaro/EndeavourOS
- ✅ **Zypper** - openSUSE Leap/Tumbleweed
- ✅ **APK** - Alpine Linux

### Core Features / Temel Özellikler
- ✅ Full Coverage: System packages, Flatpak, Snap, Firmware
- ✅ Selective Updates: `--skip` and `--only` flags (including `--skip system`)
- ✅ Dry-Run Mode: Preview without applying
- ✅ JSON Output: `--json` for monitoring, `--json-full` for SIEM/audit (v5.3+)
- ✅ Shell Completion: Bash, Zsh, Fish tab completion (v5.4+)
- ✅ Man Page: `man guncel` for full documentation (v5.4+)
- ✅ Config File: `/etc/bigfive-updater.conf`
- ✅ GPG Signature Verification: Cryptographically signed releases
- ✅ SHA256 Verification: Secure self-updates
- ✅ Automatic Backup: Rollback capability
- ✅ TLS 1.2+ Hardening: Secure downloads
- ✅ Multi-Language (v6.0+): `--lang tr|en`, `BIGFIVE_LANG` env var

---

## 🧪 Testing / Test

Bu proje [BATS](https://github.com/bats-core/bats-core) (Bash Automated Testing System) kullanır.

This project uses [BATS](https://github.com/bats-core/bats-core) for testing.

```bash
# BATS kurulumu / Install BATS
sudo apt-get install bats  # Debian/Ubuntu
# veya / or
brew install bats-core     # macOS

# Testleri çalıştır / Run tests
bats tests/*.bats

# Verbose çıktı / Verbose output
bats --tap tests/*.bats
```

### Test Status / Test Durumu

| Component | Tests | Status |
|-----------|-------|--------|
| guncel.bats | 112 | ✅ |
| install.bats | 39 | ✅ |
| **Total** | **151** | ✅ |

---

## 🔐 Security / Güvenlik

- GPG signed releases / GPG imzalı sürümler
- TLS 1.2+ enforced / TLS 1.2+ zorunlu
- SHA256 verification / SHA256 doğrulama
- Strict mode (`set -Eeuo pipefail`)

Detaylar için / For details: [SECURITY.tr.md](SECURITY.tr.md) | [SECURITY.en.md](SECURITY.en.md)

---

## 🤝 Contributing / Katkıda Bulunma

Katkıda bulunmak için / For contribution guidelines: [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md) | [CONTRIBUTING.en.md](CONTRIBUTING.en.md)

Davranış kuralları / Code of conduct: [CODE_OF_CONDUCT.tr.md](CODE_OF_CONDUCT.tr.md) | [CODE_OF_CONDUCT.en.md](CODE_OF_CONDUCT.en.md)

---

## 📄 License / Lisans

[MIT License](LICENSE)
