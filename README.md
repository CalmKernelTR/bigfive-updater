# ARCB Wider Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/arcb-wider-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)](https://github.com/ahm3t0t/arcb-wider-updater/blob/main/LICENSE)

**Linux sistemleri için Zırhlı, Akıllı ve Çoklu-Dağıtım (Multi-Distro) Güncelleme Aracı.**

> *Tembel ama takıntılı adminin en yakın dostu.*
> **One command. One updater. Zero nonsense.**

Debian (Zorin OS, Ubuntu) ve RHEL (Fedora) tabanlı sistemlerde; Snapshot (Yedek), Repo Güncellemesi, Flatpak/Snap ve Firmware kontrolünü tek komutla, güvenli bir şekilde yapar.

## 🚀 Özellikler

* **Multi-Distro Desteği:**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` paket yöneticisi ve `Timeshift` yedekleme.
    * ✅ **Fedora/RHEL:** `DNF` paket yöneticisi ve `Snapper` yedekleme.
* **Tam Kapsam:**
    * Sistem paketleri, Flatpak, Snap ve `fwupdmgr` (Firmware) güncellemeleri.
* **Ironclad Güvenlik:**
    * "Strict Mode" (`set -Eeuo pipefail`) ile hata toleransı sıfır.
* **Bilgilendirici Özet (v3.4.4):**
    * Başlangıçta sistem bilgileri (host, kernel, RAM, disk).
    * Sonunda detaylı özet (kaç paket güncellendi, reboot gerekli mi).
* **Akıllı Installer:**
    * Pipe ile çalışırken (`curl | sudo bash`) güvenli yetki yönetimi.
    * Yerel dosya tespiti (Geliştirici dostu).
    * Her güncellemede eski sürümü otomatik yedekler.

## 📦 Kurulum (Tek Satır)

Aşağıdaki komutu terminale yapıştırın. Script gerekli yetkileri güvenli bir şekilde isteyecek ve kurulumu tamamlayacaktır:

```bash
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```

## 🛠️ Kullanım

Kurulumdan sonra terminalde `guncel` yazmanız yeterlidir.

```bash
# İnteraktif Mod (Önerilen - Detaylı çıktı verir)
guncel

# Otomatik Mod (Soru sormaz - Cron/Zamanlanmış görevler için)
guncel --auto

# Detaylı Mod (Tüm komut çıktılarını gösterir)
guncel --verbose

# Sessiz Mod (Sadece hata ve özet gösterir)
guncel --quiet
```

---

# ARCB Wider Updater 🛡️ (English)

**Armored, Smart, Multi-Distro Update Tool for Linux Systems.**

> *The lazy but obsessive admin's best friend.*
> **One command. One updater. Zero nonsense.**

Performs Snapshot (Backup), Repository Updates, Flatpak/Snap and Firmware checks with a single command on Debian (Zorin OS, Ubuntu) and RHEL (Fedora) based systems.

## 🚀 Features

* **Multi-Distro Support:**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` package manager and `Timeshift` backup.
    * ✅ **Fedora/RHEL:** `DNF` package manager and `Snapper` backup.
* **Full Coverage:**
    * System packages, Flatpak, Snap and `fwupdmgr` (Firmware) updates.
* **Ironclad Security:**
    * Zero error tolerance with "Strict Mode" (`set -Eeuo pipefail`).
* **Informative Summary (v3.4.4):**
    * System info at start (host, kernel, RAM, disk).
    * Detailed summary at end (packages updated, reboot required).
* **Smart Installer:**
    * Safe privilege management when running via pipe (`curl | sudo bash`).
    * Local file detection (Developer friendly).
    * Automatically backs up old version on each update.

## 📦 Installation (One-Liner)

Paste the following command into your terminal. The script will safely request necessary privileges and complete the installation:

```bash
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```

## 🛠️ Usage

After installation, simply type `guncel` in the terminal.

```bash
# Interactive Mode (Recommended - Provides detailed output)
guncel

# Automatic Mode (No prompts - For Cron/Scheduled tasks)
guncel --auto

# Verbose Mode (Shows all command outputs)
guncel --verbose

# Quiet Mode (Shows only errors and summary)
guncel --quiet
```

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `--auto` | Automatic mode - no prompts, ideal for cron jobs |
| `--verbose` | Verbose mode - shows all command outputs |
| `--quiet` | Quiet mode - shows only errors and final summary |
| `--help` | Display help message |
