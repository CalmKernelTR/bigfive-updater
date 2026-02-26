# BigFive Updater - Yol Haritası

> Shell script olarak geliştirmeye devam ediyoruz. CLI-first, her zaman.

---

## ✅ Tamamlanan Sürümler

### v3.x Serisi - Stabilite & Altyapı
- [x] Renk ve karakter düzeltmeleri
- [x] DNF/APT lock mekanizması
- [x] `--dry-run` modu
- [x] `--skip` ve `--only` flag'leri
- [x] Config dosyası desteği
- [x] Logrotate entegrasyonu
- [x] Release automation (GitHub Actions)
- [x] BATS unit test altyapısı

### v4.x Serisi - Güvenlik & Kalite
- [x] CODENAME kurulum mesajında
- [x] GPG imzalı release'ler
- [x] TLS 1.2+ güçlendirmesi
- [x] `--uninstall` ve `--purge` seçenekleri
- [x] `updater` symlink (İngilizce alias)
- [x] 95 BATS testi (guncel + install.sh)

### v5.0.0 "BigFour" - Multi-Distro Desteği
- [x] **APT** - Debian/Ubuntu/Zorin
- [x] **DNF** - Fedora/RHEL
- [x] **Pacman** - Arch Linux/Manjaro/EndeavourOS
- [x] **Zypper** - openSUSE Leap/Tumbleweed
- [x] Multi-distro CI test matrisi
- [x] Docker test ortamı

### v5.2.x BigFive Edition - Alpine Desteği
- [x] **APK** - Alpine Linux
- [x] 5 paket yöneticisi desteği
- [x] Alpine CI testi (alpine:3.20)
- [x] EDITION/CODENAME ayrımı (Edition = seri adı, Codename = sürüm adı)
- [x] `bigfive` komut alias'ı (uluslararası kullanıcılar için)
- [x] 3 komut desteği: `guncel`, `updater`, `bigfive`
- [x] Dokümantasyon standardizasyonu (`*.en.md` / `*.tr.md`)

### v5.3 "Beacon" - JSON Output
- [x] `--json` çıktı formatı (monitoring için)
- [x] `--json-full` çıktı formatı (SIEM/audit için)
- [x] Monitoring araçları entegrasyonu (Zabbix, Nagios, Prometheus)
- [x] SIEM entegrasyonu (Wazuh, Splunk, ELK)

### v5.4 "Beacon" - Shell Entegrasyonu
- [x] Bash/Zsh/Fish tamamlama scriptleri
- [x] Man sayfası (`man guncel`)
- [x] `install.sh` ile otomatik kurulum
- [x] Toplam 138 BATS testi

### v5.5.0 "Dream" - Complete Rebranding
- [x] Proje adı değişikliği: `arcb-wider-updater` → `bigfive-updater`
- [x] Tüm referanslar güncellendi

### v5.5.1 "Dream" - Error UX
- [x] Hata kodları sistemi (E001-E040)
- [x] Kullanıcı dostu hata mesajları ve çözüm önerileri

### v5.5.2 "Dream" - Bug Fixes
- [x] pgrep bağımlılığı düzeltildi (Alpine uyumluluğu)
- [x] Zypper güncelleme sayacı düzeltildi

### v6.0.x "Echo" - Uluslararasılaştırma (i18n)
- [x] Dil dosyaları (`lang/tr.sh`, `lang/en.sh` — ~110 string)
- [x] `--lang` parametresi ve `BIGFIVE_LANG` env var desteği
- [x] Sistem LANG ayarına göre otomatik dil tespiti
- [x] printf hata düzeltmeleri (grep -c exit code)
- [x] Disk alanı kontrolü (`check_disk_space()`, E040)
- [x] Atomic self-update (install + mv pattern)
- [x] Türkçe man page kurulumu (install.sh Night-V1.4.1)
- [x] 151 BATS testi (13 yeni i18n testi)
- [x] **AUR Paketi:** `yay -S bigfive-updater`
- [x] **Alpine APKBUILD** ve kişisel Alpine repo
- [x] **Reboot detection** (kernel update sonrası uyarı)

---

## 🔜 Planlanan Özellikler

### v6.1.0 "Echo" - Diagnostics & CI

Kısa vadeli iyileştirmeler — mevcut altyapının üzerine.

- [x] `--history [N]` komutu: Log dosyalarını parse edip son N günün güncelleme özetini gösterir
  - Varsayılan: N=7 (son 7 gün)
  - Çıktı: tarih, saat, durum (OK/HATA/DRY), detay
  - Log format: `/var/log/bigfive-updater/update_YYYYMMDD_HHMMSS.log`
- [x] `--doctor` komutu: Config doğrulama, bağımlılık kontrolü, disk alanı, internet bağlantısı tek komutla
  - Config dosyası syntax kontrolü
  - Gerekli komutlar: curl/wget, paket yöneticisi
  - Opsiyonel komutlar: jq, fwupd, flatpak, snap
  - Disk alanı: minimum 500MB boş
  - İnternet: GitHub raw URL ping
  - Dil dosyaları: varlık kontrolü
- [x] GitHub Actions CI matrix build: Her PR'da 5 distro otomatik test (Docker base images hazır)
- [x] install.sh iyileştirmeleri: wget TLS flag modernize, grep portability, mesaj netliği, değişken cleanup
- [x] ~~Hook false positive fix~~ (claude-code-skills reposunda tamamlandı, Fase 5)

### v6.2.0 "Fluent Edition - Foxtrot" - GPG Self-Update ✅

Self-update için GPG imza doğrulaması.

- [x] **GPG imza doğrulaması:** `verify_gpg_signature()` fonksiyonu
  - SHA256SUMS.asc dosyası doğrulaması
  - Public key GitHub'dan otomatik indirilir
  - Graceful degradation: GPG yoksa uyarı ile devam
  - Geçersiz imza E032 hata kodu ile reddedilir
- [x] README'lere Flatpak system-wide notu eklendi
- [x] Timeout parametreleri (curl/wget)
- [x] Arch Linux reboot kontrolü (kernel modül dizini)
- [x] DNF5 uyumluluğu (Fedora 41+)

### v6.3.0 "Fluent Edition - Chrom" - Server Automation

Sunucu yöneticileri için otomasyon özellikleri.

- [x] **Notification sistemi:** `--auto` sonrası bildirim gönderimi
  - Webhook (Slack, Discord, Teams, generic HTTP)
  - Email (SMTP)
  - Config dosyasından ayarlama (`CONFIG_NOTIFY_*`)
- [x] `--security-only` flag: Sadece güvenlik güncellemelerini uygula (APT/DNF/Zypper destekli)
- [x] **Pre/post update hooks:** `/etc/bigfive-updater/hooks.d/{pre,post}-update.sh` — kullanıcı tanımlı scriptler (backup, servis restart vb.)

> **Not:** Bu özellikler v6.4.0 "Hotel" ve v6.3.0 "Golf" sürümlerinde tamamlanıp yayınlandı.

### v7.0.0 "Zenith Edition" - Notification Templates & Setup

Tam entegre server automation deneyimi.

- [ ] Notification template sistemi (Slack Block Kit, Discord embed, Teams card formatları)
- [ ] `guncel --setup` interaktif ilk kurulum wizard'ı (config + notification + cron)
- [ ] systemd timer generate (`guncel --timer create`)
- [ ] Notification config doğrulama (`guncel --doctor --notify-test`)

---

## 🏷️ Codename Sistemi

**Metodoloji:**
- **Edition** = Major seri adı (v5.x, v6.x, v7.x)
- **Codename** = Minor sürüm adı (x.Y.z)
- **Repo adı** = bigfive-updater (sabit)

### Edition Tablosu

| Major | Edition | Tema |
|-------|---------|------|
| v5.x | BigFive | 5 distro desteği |
| v6.x | Fluent | Akıcı deneyim |
| v7.x | Zenith | Zirve |

### Codename Tablosu

| Versiyon | Edition | Codename | Tema |
|----------|---------|----------|------|
| v5.0 | BigFive | ~~BigFour~~ | 4 distro (geçiş) |
| v5.1-5.2 | BigFive | Alpine | APK desteği |
| v5.3-5.4 | BigFive | Beacon | JSON + Shell |
| v5.5 | BigFive | Dream | Rebranding |
| v6.0-6.1 | Fluent | Echo | i18n, diagnostics |
| v6.2 | Fluent | Foxtrot | GPG self-update |
| v6.3 | Fluent | Golf | Cron jitter, container |
| v6.4 | Fluent | Hotel | Server automation |
| v6.5 | Fluent | India | Quality & Security |
| v7.0+ | Zenith | TBD | - |

---

## ❌ Kapsam Dışı / Reddedilen

| Fikir | Karar | Gerekçe |
|-------|-------|---------|
| GUI / Web UI | ❌ Reddedildi | BigFive CLI aracıdır. JSON output ile harici araçlar entegre olabilir |
| DEB/RPM paketleme | ❌ Reddedildi | curl + GPG kurulum yeterli, bakım yükü çok yüksek |
| Masaüstü bildirimleri | ❌ Reddedildi | Server odaklı araç, desktop notification kapsam dışı |
| Rust migration | ❌ Ertelendi | Bash yeterli, POSIX uyumluluk avantajı |
| Plugin sistemi | ❌ Ertelendi | Karmaşıklık/fayda oranı düşük |
| Paralel güncellemeler | ❌ Ertelendi | Race condition riski, karmaşık |
| Snap/Flatpak paketi | ❌ Reddedildi | Root erişim ve paket yöneticisi gerektirir, sandbox uyumsuz |

---

## 📊 Test Durumu

| Bileşen | Test Sayısı | Durum |
|---------|-------------|-------|
| guncel.bats | 153 | ✅ |
| install.bats | 39 | ✅ |
| **Toplam** | **192** | ✅ |

### CI Test Matrisi

| Distro | Paket Yöneticisi | Docker Quick Test |
|--------|------------------|-------------------|
| Ubuntu 24.04 | APT | ✅ 3/3 |
| Fedora 40 | DNF | ✅ 3/3 |
| Arch Linux | Pacman | ✅ 3/3 |
| openSUSE Leap 15.6 | Zypper | ✅ 3/3 |
| Alpine 3.20 | APK | ✅ 3/3 |

---

## 🤝 Katkıda Bulunma

Önerileriniz için [Issue](https://github.com/CalmKernelTR/bigfive-updater/issues) açabilirsiniz.

Detaylı katkı kılavuzu: [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md)
