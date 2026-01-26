# ARCB Wider Updater 🛡️

[![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Version)](https://github.com/ahm3t0t/arcb-wider-updater/releases)
[![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)](https://github.com/ahm3t0t/arcb-wider-updater/blob/main/LICENSE)

**Linux sistemleri için Zırhlı, Akıllı ve Çoklu-Dağıtım (Multi-Distro) Güncelleme Aracı.**

> *Tembel ama takıntılı adminin en yakın dostu.*
> **One command. One updater. Zero nonsense.**

Debian (Zorin OS, Ubuntu) ve RHEL (Fedora) tabanlı sistemlerde; Snapshot (Yedek), Repo Güncellemesi, Flatpak/Snap ve Firmware kontrolünü tek komutla, güvenli bir şekilde yapar.

---

## 🚀 Özellikler

* **Multi-Distro Desteği:**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` paket yöneticisi ve `Timeshift` yedekleme.
    * ✅ **Fedora/RHEL:** `DNF` paket yöneticisi ve `Snapper` yedekleme.
* **Tam Kapsam:**
    * Sistem paketleri, Flatpak, Snap ve `fwupdmgr` (Firmware) güncellemeleri.
* **Ironclad Güvenlik:**
    * "Strict Mode" (`set -Eeuo pipefail`) ile hata toleransı sıfır.
* **Seçici Güncelleme (v3.6.0+):**
    * `--skip` ile belirli backend'leri atlayın (`--skip system` dahil).
    * `--only` ile sadece istediğiniz backend'leri çalıştırın.
* **Kuru Çalıştırma (v3.8.0):**
    * `--dry-run` ile güncellemeleri önizleyin, uygulamadan.
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

---

## 📦 Sürüm Sistemi

Bu proje **iki ayrı versiyon sistemi** kullanır:

| Bileşen | Format | Güncel | Güncelleme Sıklığı |
|---------|--------|--------|--------------------|
| `guncel` (ana script) | SemVer (x.x.x) | v4.0.0 | Her özellik/fix'te |
| `install.sh` (kurulum) | Night-Vx.x.x | Night-V1.0.0 | Sadece kurulum mantığı değiştiğinde |

**Neden ayrı sistemler?**
- Ana script sık güncellenir (yeni özellikler, bug fix'ler)
- Kurulum scripti nadiren değişir (kurulum mantığı stabil)
- Kullanıcılar hangi bileşenin güncellendiğini net görebilir

---

## 📦 Kurulum (Tek Satır)

Aşağıdaki komutu terminale yapıştırın. Script gerekli yetkileri güvenli bir şekilde isteyecek ve kurulumu tamamlayacaktır:

```bash
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```

---

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

# Kuru Çalıştırma (v3.8.0) - Güncellemeleri listele, uygulama
guncel --dry-run

# Seçici Güncelleme (v3.6.0)
guncel --skip flatpak,snap      # Flatpak ve Snap'i atla
guncel --skip snapshot          # Snapshot oluşturmayı atla
guncel --only system            # Sadece sistem paketleri (APT/DNF)
guncel --only flatpak,fwupd     # Sadece Flatpak ve Firmware
```

---

## 📋 Komut Satırı Seçenekleri

| Seçenek | Açıklama |
|---------|----------|
| `--auto` | Otomatik mod - soru sormaz, cron için ideal |
| `--verbose` | Detaylı mod - tüm komut çıktılarını gösterir |
| `--quiet` | Sessiz mod - sadece hata ve özet gösterir |
| `--dry-run` | Kuru çalıştırma - güncellemeleri listeler, uygulamaz |
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

---

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
```

**Not:** Komut satırı argümanları config dosyasındaki ayarları override eder.

---

## 🔒 SHA256 Doğrulama (v3.6.0)

Self-update sırasında, indirilen dosyanın hash'i GitHub Release'deki `SHA256SUMS` dosyası ile karşılaştırılır. Hash eşleşmezse güncelleme iptal edilir.

---

## 🔄 Rollback (v3.6.0)

Her güncelleme öncesi eski sürüm `/usr/local/bin/guncel.bak` olarak yedeklenir. Sorun yaşarsanız:

```bash
sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel
```

---

## 📝 Log Yönetimi (v3.7.0)

Log dosyaları `/var/log/arcb-updater/` dizininde saklanır ve `logrotate` ile otomatik yönetilir.

### Logrotate Yapılandırması

Kurulum sırasında `/etc/logrotate.d/arcb-wider-updater` dosyası oluşturulur:

```
/var/log/arcb-updater/*.log {
    weekly          # Haftalık rotate
    rotate 4        # 4 hafta sakla
    compress        # Eski logları sıkıştır
    delaycompress   # Son rotate'u sıkıştırma
    missingok       # Log yoksa hata verme
    notifempty      # Boş log rotate etme
    create 0600 root root
}
```

### Manuel Log Kontrolü

```bash
# Log dosyalarını listele
ls -la /var/log/arcb-updater/

# Son log'u görüntüle
cat /var/log/arcb-updater/update_*.log | tail -50

# Logrotate'u manuel çalıştır
sudo logrotate -f /etc/logrotate.d/arcb-wider-updater
```

---

## 🤝 Katkıda Bulunma

Katkıda bulunmak için [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını inceleyin.

---

## 📄 Lisans

[MIT License](LICENSE)
