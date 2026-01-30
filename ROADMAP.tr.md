# BigFive Updater - Yol Haritası

> Shell script olarak geliştirmeye devam ediyoruz.

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

---

## 🔜 Planlanan Özellikler

### v5.3 "Beacon" - JSON Output ✅ TAMAMLANDI
- [x] `--json` çıktı formatı (monitoring için)
- [x] `--json-full` çıktı formatı (SIEM/audit için)
- [x] Monitoring araçları entegrasyonu (Zabbix, Nagios, Prometheus)
- [x] SIEM entegrasyonu (Wazuh, Splunk, ELK)
- [x] Makine tarafından okunabilir çıktı

### v5.4 "Beacon" - Shell Entegrasyonu ✅ TAMAMLANDI
- [x] Bash tamamlama (`completions/guncel.bash`)
- [x] Man sayfası (`docs/guncel.8`)
- [x] Seçenekler ve backend'ler için Tab tamamlama
- [x] `man guncel` ile tam dokümantasyon
- [x] `install.sh` ile otomatik kurulum
- [x] Toplam 138 BATS testi

### v5.5.0 "Dream" - Complete Rebranding ✅ TAMAMLANDI
- [x] Proje adı değişikliği: `arcb-wider-updater` → `bigfive-updater`
- [x] GitHub repository rename
- [x] Tüm script ve config referansları güncellendi
- [x] Log/config/lock dosya yolları güncellendi
- [x] Docker test dosyaları güncellendi

### v5.5.1 "Dream" - Error UX ✅ TAMAMLANDI
- [x] Hata kodları sistemi (E001-E031)
- [x] Kullanıcı dostu hata mesajları
- [x] Çözüm önerileri (💡 ile gösteriliyor)
- [x] Daha iyi hata açıklamaları

### v5.5.2 "Dream" - Bug Fixes ✅ TAMAMLANDI
- [x] pgrep bağımlılığı düzeltildi (Alpine/minimal container uyumluluğu)
- [x] Zypper güncelleme sayacı düzeltildi
- [x] Dökümantasyon tam senkronizasyonu

### v6.0 "Echo" - Uluslararasılaştırma (i18n) ✅ TAMAMLANDI
- [x] String'leri ayrı dosyaya taşı (`lang/tr.sh`, `lang/en.sh`)
- [x] Çeviri framework'ü (`--lang` parametresi, `BIGFIVE_LANG` env var)
- [x] İngilizce/Türkçe tam destek (~110 string)
- [x] Sistem LANG ayarına göre otomatik dil tespiti

### v6.0.1 "Echo" - Bug Fixes ✅ TAMAMLANDI
- [x] printf invalid number hatası düzeltildi (grep -c exit code sorunu)
- [x] Tüm paket yöneticisi sayaçları düzeltildi

### v6.0.2 "Echo" - Paketleme & İyileştirmeler ✅ TAMAMLANDI
- [x] Disk alanı kontrolü (`check_disk_space()`, E040 hata kodu)
- [x] Atomic self-update (install + mv pattern)
- [x] Türkçe man page kurulumu (install.sh Night-V1.4.1)
- [x] 13 yeni i18n BATS testi (toplam 151 test)
- [x] **AUR Paketi:** https://aur.archlinux.org/packages/bigfive-updater
  - `yay -S bigfive-updater` ile kurulum
- [x] **Alpine APKBUILD:** `packaging/alpine/APKBUILD`
  - Subpackages: doc, bash-completion, zsh-completion, fish-completion
- [x] **GitHub Actions Paket Workflow:** `.github/workflows/packages.yml`
  - Her release'de otomatik Arch ve Alpine paket build

### v6.x+ "Chrom" - Bildirimler & GUI (Planlanan)
- [ ] Email bildirimleri (SMTP)
- [ ] Webhook bildirimleri (Slack, Discord)
- [ ] Systemd timer şablonu
- [ ] Grafiksel kullanıcı arayüzü
- [ ] Masaüstü bildirimleri

---

## 🏷️ Codename Sistemi (Tematik)

| Versiyon | Edition | Codename | Özellik | Metafor |
|----------|---------|----------|---------|---------|
| v5.1-5.2 | BigFive | Alpine | APK desteği | Dağ/Distro |
| v5.3-5.4 | BigFive | Beacon | JSON + Shell entegrasyonu | Sinyal/İzleme |
| v5.5 | BigFive | Dream | Complete rebranding | Hedef/Rüya |
| v6.x | BigFive | Echo | Çoklu dil (i18n) | Yankı/Ses |
| v6.x+ | BigFive | Chrom | GUI | Görsel/Renk |

---

## 💡 Değerlendirilen Fikirler

| Fikir | Durum | Not |
|-------|-------|-----|
| AUR paketi | ✅ Tamamlandı | v6.0.2 - `yay -S bigfive-updater` |
| Alpine APKBUILD | ✅ Tamamlandı | v6.0.2 - Repo kurulumu devam ediyor |
| Masaüstü bildirimleri | 🤔 Belirsiz | v6.x için değerlendiriliyor |
| Paralel güncellemeler | ❌ Ertelendi | Riskli, karmaşık |
| Rust migration | ❌ Ertelendi | Bash yeterli |
| Web UI | ❌ Kapsam dışı | CLI odaklı kalıyoruz |
| Plugin sistemi | ❌ Ertelendi | Karmaşıklık |
| DEB/RPM paketleme | ❌ Ertelendi | curl-pipe-bash yeterli, maintenance yükü fazla |

---

## 📊 Test Durumu

| Bileşen | Test Sayısı | Durum |
|---------|-------------|-------|
| guncel.bats | 112 | ✅ |
| install.bats | 39 | ✅ |
| **Toplam** | **151** | ✅ |

### CI Test Matrisi

| Distro | Paket Yöneticisi | Durum |
|--------|------------------|-------|
| Ubuntu 24.04 | APT | ✅ |
| Fedora 40 | DNF | ✅ |
| Arch Linux | Pacman | ✅ |
| openSUSE Tumbleweed | Zypper | ✅ |
| Alpine 3.20 | APK | ✅ |

---

## 🤝 Katkıda Bulunma

Önerileriniz için [Issue](https://github.com/ahm3t0t/bigfive-updater/issues) açabilirsiniz.

Detaylı katkı kılavuzu: [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md)
