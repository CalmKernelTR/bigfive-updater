# ARCB Wider Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/arcb-wider-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)](https://github.com/ahm3t0t/arcb-wider-updater/blob/main/LICENSE)
![GitHub last commit](https://img.shields.io/github/last-commit/ahm3t0t/arcb-wider-updater)
![GitHub code size](https://img.shields.io/github/languages/code-size/ahm3t0t/arcb-wider-updater)

**Linux sistemleri için Zırhlı, Akıllı ve Çoklu-Dağıtım (Multi-Distro) Güncelleme Aracı.**

**Armored, Smart, Multi-Distro Update Tool for Linux Systems.**

> *Tembel ama takıntılı adminin en yakın dostu.*
> **One command. One updater. Zero nonsense.**

---

## 🌐 Documentation / Dokümantasyon

| Language | Documentation | Roadmap |
|----------|---------------|---------|
| 🇹🇷 Türkçe | [README.tr.md](README.tr.md) | [ROADMAP.tr.md](ROADMAP.tr.md) |
| 🇬🇧 English | [README.en.md](README.en.md) | [ROADMAP.en.md](ROADMAP.en.md) |

---

## 🚀 Quick Start / Hızlı Başlangıç

```bash
# Installation / Kurulum
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```
```bash
# Usage / Kullanım
guncel              # Interactive mode / İnteraktif mod
guncel --verbose    # Show details / Detayları göster
guncel --quiet      # Quiet mode / Sessiz mod
guncel --auto       # Automatic mode / Otomatik mod
guncel --dry-run    # Preview updates / Güncellemeleri önizle
guncel --help       # Help / Yardım
```

---

## 📦 Version System / Sürüm Sistemi

Bu proje iki ayrı versiyon sistemi kullanır:

This project uses two separate version systems:

| Component | Format | Current | Update Frequency |
|-----------|--------|---------|------------------|
| `guncel` (main script) | SemVer (x.x.x) | v4.0.0 | Her özellik/fix'te / Every feature/fix |
| `install.sh` (installer) | Night-Vx.x.x | Night-V1.0.0 | Sadece kurulum değiştiğinde / Only when install logic changes |

**Neden ayrı? / Why separate?**
- Ana script sık güncellenir, installer nadiren değişir
- Main script updates frequently, installer rarely changes

---

## 📋 Features / Özellikler

- ✅ Multi-Distro: Debian/Ubuntu/Zorin (APT) + Fedora/RHEL (DNF)
- ✅ Full Coverage: System packages, Flatpak, Snap, Firmware
- ✅ Selective Updates: `--skip` and `--only` flags (including `--skip system`)
- ✅ Dry-Run Mode: Preview without applying
- ✅ Config File: `/etc/arcb-wider-updater.conf`
- ✅ SHA256 Verification: Secure self-updates
- ✅ Automatic Backup: Rollback capability

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

---

## 🤝 Contributing / Katkıda Bulunma

Katkıda bulunmak için [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını inceleyin.

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## 📄 License / Lisans

[MIT License](LICENSE)
