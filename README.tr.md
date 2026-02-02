# BigFive Updater 🛡️

[![CI Status](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml)
[![Tests](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/test.yml/badge.svg)](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/test.yml)
[![Latest Release](https://img.shields.io/github/v/release/CalmKernelTR/bigfive-updater?sort=semver&label=Version)](https://github.com/CalmKernelTR/bigfive-updater/releases)
[![License](https://img.shields.io/github/license/CalmKernelTR/bigfive-updater)](https://github.com/CalmKernelTR/bigfive-updater/blob/main/LICENSE)

**Linux sistemleri için Zırhlı, Akıllı ve Çoklu-Dağıtım (Multi-Distro) Güncelleme Aracı.**

> *Tembel ama takıntılı adminin en yakın dostu.*

---

## 🤔 BigFive Ne Demek?

**Big Five** = 5 büyük paket yöneticisi desteği: APT, DNF, Pacman, Zypper, APK.
Tek komutla tüm Linux dağıtımlarını güncelleyen evrensel araç.

---

## 💡 Neden Bu Araç?

### Problem
Tipik bir Linux masaüstünde güncelleme yapmak için:

```bash
sudo apt update && sudo apt upgrade -y      # Sistem paketleri
flatpak update -y                            # Flatpak uygulamaları
sudo snap refresh                            # Snap paketleri
sudo fwupdmgr refresh && sudo fwupdmgr update # Firmware
```

4 ayrı komut, farklı sözdizimi, hata kontrolü yok, log yok, yedek yok.

### Çözüm

```bash
guncel
```

Tek komut. Hepsi bir arada. Güvenli ve izlenebilir.

### Bu Araç Size Ne Kazandırır?

| Özellik | Manuel Güncelleme | guncel |
|---------|-------------------|--------|
| Tek komut | ❌ 4+ komut | ✅ `guncel` |
| Hata kontrolü | ❌ Yok | ✅ Strict mode |
| Log kaydı | ❌ Yok | ✅ Detaylı log |
| Yedekleme | ❌ Manuel | ✅ Otomatik |
| Cron desteği | ❌ Karmaşık | ✅ `--auto` |
| Flatpak/Snap/Firmware | ❌ Ayrı ayrı | ✅ Hepsi dahil |
| Rollback | ❌ Yok | ✅ `.bak` dosyası |

---

## 📑 İçindekiler

- [Özellikler](#-özellikler)
- [Hızlı Başlangıç](#-hızlı-başlangıç)
- [Kullanım Senaryoları](#-kullanım-senaryoları)
- [Komut Satırı Seçenekleri](#-komut-satırı-seçenekleri)
- [Config Dosyası](#️-config-dosyası-v360)
- [Otomatik Güncelleme (Cron/Systemd)](#-otomatik-güncelleme-cronsystemd)
- [GPG İmza Doğrulama](#-gpg-i̇mza-doğrulama-v410)
- [Sorun Giderme](#-sorun-giderme-troubleshooting)
- [Sıkça Sorulan Sorular](#-sıkça-sorulan-sorular-faq)
- [Katkıda Bulunma](#-katkıda-bulunma)

---

## 🚀 Özellikler

* **Multi-Distro Desteği (v5.x BigFive Edition):**
    * ✅ **Debian/Ubuntu/Zorin:** `APT` paket yöneticisi ve `Timeshift` yedekleme.
    * ✅ **Fedora/RHEL:** `DNF` paket yöneticisi ve `Snapper` yedekleme.
    * ✅ **Arch/Manjaro/EndeavourOS:** `Pacman` paket yöneticisi (v5.0+).
    * ✅ **openSUSE Leap/Tumbleweed:** `Zypper` paket yöneticisi (v5.0+).
    * ✅ **Alpine Linux:** `APK` paket yöneticisi (v5.1+).
* **Tam Kapsam:**
    * Sistem paketleri, Flatpak, Snap ve `fwupdmgr` (Firmware) güncellemeleri.
* **Ironclad Güvenlik:**
    * "Strict Mode" (`set -Eeuo pipefail`) ile hata toleransı sıfır.
* **Seçici Güncelleme (v3.6.0+):**
    * `--skip` ile belirli backend'leri atlayın (`--skip system` dahil).
    * `--only` ile sadece istediğiniz backend'leri çalıştırın.
* **Kuru Çalıştırma (v3.8.0):**
    * `--dry-run` ile güncellemeleri önizleyin, uygulamadan.
* **JSON Çıktı (v5.3+):**
    * `--json`: Monitoring sistemleri için hafif JSON (Zabbix, Nagios, Prometheus).
    * `--json-full`: SIEM/audit sistemleri için detaylı JSON (Wazuh, Splunk, ELK).
* **Shell Tamamlama (v5.4+):**
    * Tab tuşu ile seçenek ve backend tamamlama.
    * **Bash:** `/usr/share/bash-completion/completions/`
    * **Zsh:** `/usr/share/zsh/site-functions/` (v5.4.8+)
    * **Fish:** `/usr/share/fish/vendor_completions.d/` (v5.4.8+)
* **Man Sayfası (v5.4+):**
    * `man guncel` ile detaylı dokümantasyon.
* **Çoklu Dil Desteği (v6.0+ Echo):**
    * Türkçe ve İngilizce tam destek.
    * `--lang tr` veya `--lang en` ile dil seçimi.
    * `BIGFIVE_LANG` environment variable desteği.
    * Sistem LANG ayarına göre otomatik dil tespiti.
* **Disk Alanı Kontrolü (v6.0.2):**
    * Güncelleme öncesi minimum 500MB disk alanı kontrolü.
    * Yetersiz alan durumunda E040 hata kodu ile uyarı.
* **Sistem Sağlık Kontrolü (v6.1.0):**
    * `--doctor` komutu ile sistem tanılama.
    * Config, gerekli/opsiyonel komutlar, disk, ağ, dil dosyalarını kontrol eder.
* **Güncelleme Geçmişi (v6.1.0):**
    * `--history [N]` ile son N günün güncelleme loglarını görüntüleme (varsayılan: 7).
    * Her çalıştırmanın tarih, saat, durum ve detaylarını gösterir.
* **Config Dosyası Desteği (v3.6.0):**
    * `/etc/bigfive-updater.conf` ile varsayılan ayarları tanımlayın.
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
| `guncel` (ana script) | SemVer (x.x.x) | v6.1.0 (BigFive Edition - Echo) | Her özellik/fix'te |
| `install.sh` (kurulum) | Night-Vx.x.x | Night-V1.4.2 | Sadece kurulum mantığı değiştiğinde |

**İsimlendirme Kuralı:**
- **Edition** = Major seri adı (örn: "BigFive" v5.x için = 5 paket yöneticisi)
- **Codename** = Minor sürüm adı (örn: "Alpine" v5.2.0 için = APK desteği eklendi)

**Neden ayrı sistemler?**
- Ana script sık güncellenir (yeni özellikler, bug fix'ler)
- Kurulum scripti nadiren değişir (kurulum mantığı stabil)
- Kullanıcılar hangi bileşenin güncellendiğini net görebilir

**Kullanılabilir Komutlar:** `guncel` (Türkçe) | `updater` (İngilizce) | `bigfive` (Marka/Uluslararası)

---

## ⚡ Hızlı Başlangıç

### Kurulum

```bash
# Evrensel Kurulum (Tüm dağıtımlar)
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash

# Arch Linux / Manjaro / EndeavourOS (AUR)
yay -S bigfive-updater   # veya: paru -S bigfive-updater

# Alpine Linux (APK)
# 1. Public key ekle
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# 2. Repo ekle
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | \
    sudo tee -a /etc/apk/repositories

# 3. Kur
sudo apk update && sudo apk add bigfive-updater
```

> **Paket Repoları:**
> - AUR: https://aur.archlinux.org/packages/bigfive-updater
> - Alpine: https://ahm3t0t.github.io/bigfive-updater/

### İlk Çalıştırma

```bash
# Önce ne yapacağını gör (dry-run)
sudo guncel --dry-run

# Memnunsan çalıştır
sudo guncel
```

### Örnek Çıktı

```
========================================
  BIGFIVE-UPDATER v5.5.2
  Host: my-laptop | User: root
  Kernel: 6.14.0-37-generic
  RAM: 16Gi | Disk: 45% used
========================================

>>> APT: Güncelleme Başlıyor
...
>>> Flatpak: Güncelleme
...
>>> Snap: Güncelleme
...
>>> Firmware: Kontrol
...

========================================
  [+] GÜNCELLEME TAMAMLANDI
----------------------------------------
  APT: 12 paket güncellendi
  Flatpak: 3 uygulama güncellendi
  Snap: Güncel
  Firmware: Güncel
----------------------------------------
  Snapshot: BigFive-Update-2026-01-28
  Reboot: Gerekli değil
  Log: /var/log/bigfive-updater/update_20260128_103045.log
========================================
```

---

## 🎯 Kullanım Senaryoları

### Senaryo 1: Günlük Kullanım (Masaüstü)

```bash
# Sabah kahvenizi alın, terminali açın
sudo guncel --verbose

# Veya sadece bakmak istiyorsanız
sudo guncel --dry-run
```

### Senaryo 2: Sunucu (Headless)

```bash
# SSH ile bağlanıp sessizce güncelle
sudo guncel --auto --quiet
```

### Senaryo 3: Sadece Güvenlik Güncellemeleri

```bash
# Flatpak ve Snap'i atla, sadece sistem paketleri
sudo guncel --only system
```

### Senaryo 4: Firmware Hariç Her Şey

```bash
sudo guncel --skip fwupd
```

---

## 🛠️ Kullanım

Kurulumdan sonra terminalde `guncel`, `updater` veya `bigfive` yazmanız yeterlidir.

```bash
# İnteraktif Mod (Önerilen - Detaylı çıktı verir)
guncel
updater
bigfive

# Otomatik Mod (Soru sormaz - Cron/Zamanlanmış görevler için)
guncel --auto

# Detaylı Mod (Tüm komut çıktılarını gösterir)
updater --verbose

# Sessiz Mod (Sadece hata ve özet gösterir)
bigfive --quiet

# Kuru Çalıştırma (v3.8.0) - Güncellemeleri listele, uygulama
guncel --dry-run

# Seçici Güncelleme (v3.6.0)
guncel --skip flatpak,snap      # Flatpak ve Snap'i atla
guncel --skip snapshot          # Snapshot oluşturmayı atla
guncel --only system            # Sadece sistem paketleri (APT/DNF/Pacman/Zypper/APK)
guncel --only pacman            # Sadece Pacman (Arch Linux)
guncel --only zypper            # Sadece Zypper (openSUSE)
guncel --only apk               # Sadece APK (Alpine Linux)
guncel --only flatpak,fwupd     # Sadece Flatpak ve Firmware

# Dil Seçimi (v6.0+ Echo)
guncel --lang en                # İngilizce çıktı
guncel --lang tr                # Türkçe çıktı (varsayılan)
BIGFIVE_LANG=en guncel          # Environment variable ile
```

---

## 📋 Komut Satırı Seçenekleri

| Seçenek | Açıklama |
|---------|----------|
| `--auto` | Otomatik mod - soru sormaz, cron için ideal |
| `--verbose` | Detaylı mod - tüm komut çıktılarını gösterir |
| `--quiet` | Sessiz mod - sadece hata ve özet gösterir |
| `--dry-run` | Kuru çalıştırma - güncellemeleri listeler, uygulamaz |
| `--json` | JSON çıktı - monitoring sistemleri için (Zabbix, Nagios) |
| `--json-full` | Detaylı JSON çıktı - SIEM/audit için (Wazuh, Splunk) |
| `--skip <backend>` | Belirtilen backend'leri atla (virgülle ayır) |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır |
| `--lang <tr\|en>` | Çıktı dilini seçer (v6.0+) |
| `--uninstall` | BigFive Updater'ı kaldır (config/log korunur) |
| `--uninstall --purge` | Config ve loglar dahil tamamen kaldır |
| `--help` | Yardım mesajını gösterir |

### Skip/Only Değerleri

| Değer | Açıklama |
|-------|----------|
| `snapshot` | Timeshift/Snapper yedekleme |
| `flatpak` | Flatpak güncellemeleri |
| `snap` | Snap güncellemeleri |
| `fwupd` | Firmware güncellemeleri |
| `system` | Tüm sistem paket yöneticileri (APT/DNF/Pacman/Zypper/APK) |
| `apt` | Sadece APT (Debian/Ubuntu) |
| `dnf` | Sadece DNF (Fedora/RHEL) |
| `pacman` | Sadece Pacman (Arch Linux) |
| `zypper` | Sadece Zypper (openSUSE) |
| `apk` | Sadece APK (Alpine Linux) |

---

## ⚙️ Config Dosyası (v3.6.0)

Varsayılan ayarları `/etc/bigfive-updater.conf` dosyasında tanımlayabilirsiniz:

```bash
# /etc/bigfive-updater.conf
# BigFive Updater Yapılandırma Dosyası

# Varsayılan modlar (true/false)
CONFIG_VERBOSE=false
CONFIG_QUIET=false
CONFIG_AUTO=false

# Backend'leri varsayılan olarak atla (true/false)
CONFIG_SKIP_SNAPSHOT=false
CONFIG_SKIP_FLATPAK=false
CONFIG_SKIP_SNAP=false
CONFIG_SKIP_FWUPD=false
CONFIG_SKIP_PKG_MANAGER=false  # Tüm sistem paket yöneticileri (APT/DNF/Pacman/Zypper/APK)

# Snapshot timeout (saniye) - varsayılan 300 (5 dakika)
CONFIG_SNAPSHOT_TIMEOUT=300

# JSON çıktı modu: none, json, json-full (v5.3+)
CONFIG_JSON_MODE=none
```

**Not:** Komut satırı argümanları config dosyasındaki ayarları override eder.

---

## ⏰ Otomatik Güncelleme (Cron/Systemd)

### Cron ile Haftalık Güncelleme

```bash
# Crontab'ı düzenle
sudo crontab -e

# Her Pazar gece 03:00'te çalıştır
0 3 * * 0 /usr/local/bin/guncel --auto --quiet >> /var/log/bigfive-updater/cron.log 2>&1
```

### Systemd Timer ile (Önerilen)

**1. Service dosyası oluştur:**

```bash
sudo tee /etc/systemd/system/bigfive-updater.service << 'EOF'
[Unit]
Description=BigFive Updater
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/guncel --auto --quiet
Nice=19
IOSchedulingClass=idle
EOF
```

**2. Timer dosyası oluştur:**

```bash
sudo tee /etc/systemd/system/bigfive-updater.timer << 'EOF'
[Unit]
Description=BigFive Updater Timer

[Timer]
OnCalendar=Sun 03:00
Persistent=true
RandomizedDelaySec=1800

[Install]
WantedBy=timers.target
EOF
```

**3. Timer'ı etkinleştir:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now bigfive-updater.timer

# Durumu kontrol et
sudo systemctl status bigfive-updater.timer
```

---

## 📊 JSON Çıktı (v5.3.0+)

Monitoring ve SIEM sistemleriyle entegrasyon için JSON çıktı modları:

### Hafif JSON (--json) - Monitoring için

```bash
sudo guncel --json
```

```json
{
  "version": "5.3.0",
  "status": "success",
  "exit_code": 0,
  "timestamp": "2026-01-29T13:30:00+03:00",
  "hostname": "srv-web-01",
  "duration_seconds": 45,
  "dry_run": false,
  "updated_count": 12,
  "reboot_required": false
}
```

### Detaylı JSON (--json-full) - SIEM/Audit için

```bash
sudo guncel --json-full
```

```json
{
  "version": "5.3.0",
  "status": "success",
  "exit_code": 0,
  "timestamp": "2026-01-29T13:30:00+03:00",
  "hostname": "srv-web-01",
  "duration_seconds": 45,
  "dry_run": false,
  "reboot_required": false,
  "system": {
    "distro": "ubuntu",
    "distro_version": "24.04",
    "kernel": "6.8.0-45-generic"
  },
  "package_managers": [
    {"name": "apt", "status": "ran", "updated_count": 10},
    {"name": "flatpak", "status": "ran", "updated_count": 2}
  ],
  "packages": [],
  "snapshot": {
    "created": true,
    "name": "BigFive-Update-2026-01-29",
    "tool": "timeshift"
  },
  "warnings": [],
  "errors": []
}
```

### Kullanım Örnekleri

```bash
# Zabbix/Nagios ile kullanım
sudo guncel --json | jq '.status'

# Wazuh/Splunk için log
sudo guncel --json-full >> /var/log/bigfive-updates.json

# Dry-run ile JSON
sudo guncel --dry-run --json
```

---

## 🔐 GPG İmza Doğrulama (v4.1.0+)

**v4.1.0'dan itibaren** tüm release'ler GPG ile kriptografik olarak imzalanmaktadır.

### Kurulum Sırasında Doğrulama

`install.sh` scripti otomatik olarak:
1. Public key'i indirir ve import eder (`pubkey.asc`)
2. `SHA256SUMS.asc` imzasını doğrular
3. İndirilen dosyanın hash'ini kontrol eder
4. Doğrulama başarısız olursa kurulumu iptal eder

```bash
# Kurulum çıktısı örneği:
🔐 GPG imza doğrulaması başlatılıyor...
   ✓ Public key import edildi
   ✓ GPG imzası doğrulandı
   ✓ SHA256 checksum doğrulandı
✅ Kurulum Başarılı! (v5.5.2 - Signed)
```

### Manuel Doğrulama

```bash
# Public key'i import et
curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc | gpg --import

# İmzayı doğrula
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
gpg --verify SHA256SUMS.asc SHA256SUMS
```

---

## 💡 Hata Kodları ve Çözüm Önerileri (v5.5.1+)

v5.5.1'den itibaren hatalar kod numarası ve çözüm önerisi ile gösterilir:

```
[X] HATA [E010]: APT kilitleri kaldırılamadı.
    💡 Çözüm: Başka bir güncelleme çalışıyor olabilir. 'sudo lsof /var/lib/dpkg/lock-frontend' ile kontrol edin.
```

### Hata Kodları Tablosu

| Kod | Anlamı | Çözüm Önerisi |
|-----|--------|---------------|
| E001 | curl/wget bulunamadı | `apt install curl` veya `dnf install curl` |
| E002 | Root yetkisi yok, sudo yok | `su -c 'dnf install sudo'` veya root olarak çalıştırın |
| E010 | APT kilidi açılamadı | Başka güncelleme işlemi bekleyin veya `lsof` ile kontrol edin |
| E011 | DNF kilidi zaman aşımı | GNOME Software kapalıysa `pgrep -a dnf` ile kontrol edin |
| E020 | Başka bigfive çalışıyor | `pgrep -a guncel` veya kilit dosyasını silin |
| E021 | İnternet bağlantısı yok | `ping google.com` ile test edin |
| E030 | SHA256 doğrulama başarısız | Dosya bozuk, daha sonra tekrar deneyin |
| E031 | Güncelleme kopyalanamadı | Disk dolu veya yazma izni yok |
| E040 | Yetersiz disk alanı | En az 500MB boş alan gerekli, `df -h` ile kontrol edin |

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

Log dosyaları `/var/log/bigfive-updater/` dizininde saklanır ve `logrotate` ile otomatik yönetilir.

### Logrotate Yapılandırması

Kurulum sırasında `/etc/logrotate.d/bigfive-updater` dosyası oluşturulur:

```
/var/log/bigfive-updater/*.log {
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
ls -la /var/log/bigfive-updater/

# Son log'u görüntüle
cat /var/log/bigfive-updater/update_*.log | tail -50

# Logrotate'u manuel çalıştır
sudo logrotate -f /etc/logrotate.d/bigfive-updater
```

---

## 🔧 Sorun Giderme (Troubleshooting)

### "APT kilidi" Hatası

```
[~] APT kilitli (fuser), bekleniyor... (1/15)
```

**Sebep:** Başka bir paket yöneticisi çalışıyor (apt, dpkg, Software Center).

**Çözüm:** Diğer işlemin bitmesini bekleyin veya:
```bash
# Kilidi kontrol et
sudo lsof /var/lib/dpkg/lock-frontend

# Zorla kaldır (dikkatli olun!)
sudo rm /var/lib/dpkg/lock-frontend
sudo dpkg --configure -a
```

### "Başka bir güncelleme işlemi çalışıyor" Hatası

```
[X] HATA: Başka bir güncelleme işlemi zaten çalışıyor.
```

**Sebep:** Önceki `guncel` komutu hala çalışıyor veya düzgün kapanmadı.

**Çözüm:**
```bash
# Kilit dosyasını kontrol et
sudo ls -la /var/lock/bigfive-updater.lock

# Gerekirse sil
sudo rm /var/lock/bigfive-updater.lock
```

### GPG Doğrulama Başarısız

```
❌ GPG imza doğrulaması başarısız!
```

**Sebep:** İndirilen dosya değiştirilmiş veya bozuk olabilir.

**Çözüm:**
```bash
# Manuel olarak doğrula
curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc | gpg --import
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS -o /tmp/SHA256SUMS
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc -o /tmp/SHA256SUMS.asc
gpg --verify /tmp/SHA256SUMS.asc /tmp/SHA256SUMS
```

### Güncelleme Sonrası Sorun

```bash
# Eski sürüme geri dön
sudo cp /usr/local/bin/guncel.bak /usr/local/bin/guncel

# Veya arşivden belirli bir tarihe
sudo cp /usr/local/bin/guncel.bak_20260128_103045 /usr/local/bin/guncel
```

### Log Dosyasını İnceleme

```bash
# Son güncelleme logunu görüntüle
sudo cat /var/log/bigfive-updater/update_*.log | tail -100

# Hataları filtrele
sudo grep -i "error\|hata\|failed" /var/log/bigfive-updater/update_*.log
```

---

## ❓ Sıkça Sorulan Sorular (FAQ)

### Sistemime zarar verir mi?

**Hayır.** Script sadece resmi paket yöneticilerini (`apt`, `dnf`, `flatpak`, `snap`, `fwupdmgr`) kullanır. Ek olarak:
- Her güncellemeden önce yedek alınır (`.bak` dosyası)
- Timeshift/Snapper varsa snapshot oluşturulur
- Strict mode ile herhangi bir hata anında durur
- `--dry-run` ile önce ne yapacağını görebilirsiniz

### Root yetkisi neden gerekli?

Sistem paketlerini güncellemek (`apt upgrade`, `dnf upgrade`) root yetkisi gerektirir. Script otomatik olarak `sudo` ister.

### Cron'da neden `--auto` kullanmalıyım?

`--auto` modu:
- Kullanıcı onayı istemez
- Self-update'i otomatik kabul eder
- Cron/systemd için idealdir

### Flatpak'i neden atlayamıyorum?

Atlayabilirsiniz:
```bash
sudo guncel --skip flatpak
```

### Sadece ne güncellenecek görmek istiyorum

```bash
sudo guncel --dry-run
```

### Config dosyası nerede?

```bash
# Örnek config'i kopyala
sudo cp /usr/local/share/bigfive-updater.conf.example /etc/bigfive-updater.conf

# Düzenle
sudo nano /etc/bigfive-updater.conf
```

### Eski logları nasıl silerim?

Loglar `logrotate` ile otomatik yönetilir (haftalık, 4 hafta saklanır). Manuel silmek için:
```bash
sudo rm /var/log/bigfive-updater/update_*.log
```

### Güncelleme ne kadar sürer?

Sisteminize ve internet hızınıza bağlı. Tipik olarak:
- Güncel sistem: 30 saniye - 1 dakika
- Birkaç güncelleme: 2-5 dakika
- Büyük güncelleme: 10-30 dakika

### Reboot gerekli mi?

Script size söyler:
```
Reboot: Gerekli  ← Kernel veya kritik paket güncellendiyse
Reboot: Gerekli değil  ← Güvenle devam edebilirsiniz
```

---

## 🚀 Release Oluşturma (Geliştiriciler İçin)

Yeni release oluşturmak için `release.sh` scripti kullanılır:

```bash
./release.sh patch     # 4.1.4 → 4.1.5 (bug fix)
./release.sh minor     # 4.1.4 → 4.2.0 (yeni özellik)
./release.sh major     # 4.1.4 → 5.0.0 (breaking change)
./release.sh 4.2.0     # manuel versiyon
```

Script otomatik olarak:
1. `guncel` dosyasındaki VERSION'u günceller
2. Commit oluşturur
3. Tag oluşturur ve push eder
4. GitHub Actions release workflow'unu tetikler (GPG imzalama dahil)

---

## 🤝 Katkıda Bulunma

Katkıda bulunmak için [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md) dosyasını inceleyin.

---

## 📄 Lisans

[MIT License](LICENSE)
