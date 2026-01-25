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
* **Seçici Güncelleme (v3.6.0):**
    * `--skip` ile belirli backend'leri atlayın.
    * `--only` ile sadece istediğiniz backend'leri çalıştırın.
* **Config Dosyası Desteği (v3.6.0):**
    * `/etc/arcb-wider-updater.conf` ile varsayılan ayarları tanımlayın.
* **SHA256 Doğrulama (v3.6.0):**
    * Self-update sırasında hash kontrolü ile güvenli güncelleme.
* **Otomatik Yedekleme (v3.6.0):**
    * Her güncellemede `.bak` dosyası ile rollback imkanı.
* **Bilgilendirici Özet:**
    * Başlangıçta sistem bilgileri (host, kernel, RAM, disk).
    * Sonunda detaylı özet (kaç paket güncellendi, reboot gerekli mi).
* **Eşzamanlı Çalışma Kilidi:**
    * `flock` ile cron ve manuel çalıştırma çakışmasını önler.
* **DNF Kilit Bekleme:**
    * DNF/YUM/RPM işlemleri için akıllı bekleme mekanizması.
* **Akıllı Installer:**
    * Pipe ile çalışırken (`curl | sudo bash`) güvenli yetki yönetimi.
    * Yerel dosya tespiti (Geliştirici dostu).

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

# Seçici Güncelleme (v3.6.0)
guncel --skip flatpak,snap      # Flatpak ve Snap'i atla
guncel --skip snapshot          # Snapshot oluşturmayı atla
guncel --only system            # Sadece sistem paketleri (APT/DNF)
guncel --only flatpak,fwupd     # Sadece Flatpak ve Firmware
```

## 📋 Komut Satırı Seçenekleri

| Seçenek | Açıklama |
|---------|----------|
| `--auto` | Otomatik mod - soru sormaz, cron için ideal |
| `--verbose` | Detaylı mod - tüm komut çıktılarını gösterir |
| `--quiet` | Sessiz mod - sadece hata ve özet gösterir |
| `--skip <backend>` | Belirtilen backend'leri atla (virgülle ayır) |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır |
| `--help` | Yardım mesajını gösterir |

### Skip/Only Değerleri

| Değer | Açıklama |
|-------|----------|
| `snapshot` | Timeshift/Snapper yedekleme |
| `flatpak` | Flatpak güncellemeleri |
| `snap` | Snap güncellemeleri |
| `fwupd` | Firmware güncellemeleri |
| `dnf` / `apt` / `system` | Sistem paket yöneticisi |

## ⚙️ Config Dosyası (v3.6.0)

Varsayılan ayarları `/etc/arcb-wider-updater.conf` dosyasında tanımlayabilirsiniz:

```bash
# /etc/arcb-wider-updater.conf
# ARCB Wider Updater Yapılandırma Dosyası

# Varsayılan modlar (true/false)
CONFIG_VERBOSE=false
CONFIG_QUIET=false
CONFIG_AUTO=false

# Backend'leri varsayılan olarak atla (true/false)
CONFIG_SKIP_SNAPSHOT=false
CONFIG_SKIP_FLATPAK=false
CONFIG_SKIP_SNAP=false
CONFIG_SKIP_FWUPD=false
CONFIG_SKIP_DNF=false

# Özel renkler (opsiyonel - ANSI escape kodları)
# CONFIG_COLOR_RED='\033[0;31m'
# CONFIG_COLOR_GREEN='\033[0;32m'
# CONFIG_COLOR_YELLOW='\033[0;33m'
# CONFIG_COLOR_BLUE='\033[0;34m'
```

**Not:** Komut satırı argümanları config dosyasındaki ayarları override eder.

## 🔒 SHA256 Doğrulama (v3.6.0)

Self-update sırasında, indirilen dosyanın hash'i GitHub Release'deki `SHA256SUMS` dosyası ile karşılaştırılır. Hash eşleşmezse güncelleme iptal edilir.

## 🔄 Rollback (v3.6.0)

Her güncelleme öncesi eski sürüm `/usr/local/bin/guncel.bak` olarak yedeklenir. Sorun yaşarsanız:

```bash
sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel
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
* **Selective Updates (v3.6.0):**
    * `--skip` to skip specific backends.
    * `--only` to run only specified backends.
* **Config File Support (v3.6.0):**
    * Define default settings in `/etc/arcb-wider-updater.conf`.
* **SHA256 Verification (v3.6.0):**
    * Hash verification during self-update for secure updates.
* **Automatic Backup (v3.6.0):**
    * `.bak` file created before each update for rollback capability.
* **Informative Summary:**
    * System info at start (host, kernel, RAM, disk).
    * Detailed summary at end (packages updated, reboot required).
* **Concurrent Execution Lock:**
    * Prevents cron and manual execution conflicts using `flock`.
* **DNF Lock Retry:**
    * Smart waiting mechanism for DNF/YUM/RPM operations.
* **Smart Installer:**
    * Safe privilege management when running via pipe (`curl | sudo bash`).
    * Local file detection (Developer friendly).

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

# Selective Updates (v3.6.0)
guncel --skip flatpak,snap      # Skip Flatpak and Snap
guncel --skip snapshot          # Skip snapshot creation
guncel --only system            # Only system packages (APT/DNF)
guncel --only flatpak,fwupd     # Only Flatpak and Firmware
```

## 📋 Command Line Options

| Option | Description |
|--------|-------------|
| `--auto` | Automatic mode - no prompts, ideal for cron jobs |
| `--verbose` | Verbose mode - shows all command outputs |
| `--quiet` | Quiet mode - shows only errors and final summary |
| `--skip <backend>` | Skip specified backends (comma-separated) |
| `--only <backend>` | Run only specified backends (comma-separated) |
| `--help` | Display help message |

### Skip/Only Values

| Value | Description |
|-------|-------------|
| `snapshot` | Timeshift/Snapper backup |
| `flatpak` | Flatpak updates |
| `snap` | Snap updates |
| `fwupd` | Firmware updates |
| `dnf` / `apt` / `system` | System package manager |

## ⚙️ Config File (v3.6.0)

Define default settings in `/etc/arcb-wider-updater.conf`:

```bash
# /etc/arcb-wider-updater.conf
# ARCB Wider Updater Configuration File

# Default modes (true/false)
CONFIG_VERBOSE=false
CONFIG_QUIET=false
CONFIG_AUTO=false

# Skip backends by default (true/false)
CONFIG_SKIP_SNAPSHOT=false
CONFIG_SKIP_FLATPAK=false
CONFIG_SKIP_SNAP=false
CONFIG_SKIP_FWUPD=false
CONFIG_SKIP_DNF=false
```

**Note:** Command line arguments override config file settings.

## 🔒 SHA256 Verification (v3.6.0)

During self-update, the downloaded file's hash is compared against the `SHA256SUMS` file from GitHub Releases. If hashes don't match, the update is cancelled.

## 🔄 Rollback (v3.6.0)

Before each update, the old version is backed up to `/usr/local/bin/guncel.bak`. If you experience issues:

```bash
sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel
```
