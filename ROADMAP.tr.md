# ARCB Wider Updater - Yol Haritası

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
- [x] Toplam 85 BATS testi

### v5.5+ - Kullanıcı Deneyimi (Planlanan)
- [ ] Graceful error messages (kullanıcı dostu hata mesajları)
- [ ] Daha iyi hata açıklamaları
- [ ] Çözüm önerileri

### v5.6+ - Gelişmiş Yapılandırma (Planlanan)
- [ ] Email bildirimleri (SMTP)
- [ ] Webhook bildirimleri (Slack, Discord)
- [ ] Systemd timer şablonu

### v6.0 "Echo" - Uluslararasılaştırma (i18n) (Planlanan)
- [ ] String'leri ayrı dosyaya taşı
- [ ] Çeviri framework'ü
- [ ] İngilizce/Türkçe tam destek

### v6.x+ "Chrom" - GUI (Planlanan)
- [ ] Grafiksel kullanıcı arayüzü
- [ ] Masaüstü bildirimleri

---

## 🏷️ Codename Sistemi (Tematik)

| Versiyon | Edition | Codename | Özellik | Metafor |
|----------|---------|----------|---------|---------|
| v5.1-5.2 | BigFive | Alpine | APK desteği | Dağ/Distro |
| v5.3 | BigFive | Beacon | JSON output | Sinyal/İzleme |
| v6.x | BigFive | Echo | Çoklu dil (i18n) | Yankı/Ses |
| v6.x+ | BigFive | Chrom | GUI | Görsel/Renk |

---

## 💡 Değerlendirilen Fikirler

| Fikir | Durum | Not |
|-------|-------|-----|
| Masaüstü bildirimleri | 🤔 Belirsiz | v6.x için değerlendiriliyor |
| Paralel güncellemeler | ❌ Ertelendi | Riskli, karmaşık |
| Rust migration | ❌ Ertelendi | Bash yeterli |
| Web UI | ❌ Kapsam dışı | CLI odaklı kalıyoruz |
| Plugin sistemi | ❌ Ertelendi | Karmaşıklık |
| DEB/RPM paketleme | ❌ Ertelendi | curl-pipe-bash yeterli |

---

## 📊 Test Durumu

| Bileşen | Test Sayısı | Durum |
|---------|-------------|-------|
| guncel.bats | 70 | ✅ |
| install.bats | 35 | ✅ |
| **Toplam** | **105** | ✅ |

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

Önerileriniz için [Issue](https://github.com/ahm3t0t/arcb-wider-updater/issues) açabilirsiniz.

Detaylı katkı kılavuzu: [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md)
