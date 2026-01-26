# 🗺️ ARCB Wider Updater - Yol Haritası

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
- [x] BATS unit test altyapısı (32 test)
- [x] Çoklu dil dokümantasyonu (TR/EN)

### v4.0.0 "Polished" - Temizlik & Tutarlılık
- [x] CODENAME kurulum mesajında
- [x] Header temizliği (DRY)
- [x] Help mesajı tutarlılığı
- [x] Dokümantasyon güncellemesi

---

## 🔜 Planlanan Özellikler

### v4.1.0 - Güvenlik & Topluluk
- [ ] GPG imzalı release'ler
- [ ] FUNDING.yml (GitHub Sponsors)
- [ ] SECURITY.md (güvenlik politikası)

### v4.2.0 - Kullanıcı Deneyimi
- [ ] `--json` çıktı formatı (otomasyon için)
- [ ] Desktop notification desteği (notify-send)
- [ ] Systemd timer şablonu

### v4.3.0 - Gelişmiş Özellikler
- [ ] Paralel güncelleme (APT + Flatpak aynı anda)
- [ ] Güncelleme geçmişi raporu
- [ ] E-posta/webhook bildirimleri

---

## 💡 Değerlendirilen Fikirler

| Fikir | Durum | Not |
|-------|-------|-----|
| Rust migration | ❌ Ertelendi | Bash yeterli, karmaşıklık gereksiz |
| Web UI | ❌ Kapsam dışı | CLI odaklı kalıyoruz |
| Plugin sistemi | 🤔 Belirsiz | Gerekirse v5.x |

---

## 🤝 Katkıda Bulunma

Önerileriniz için [Issue](https://github.com/ahm3t0t/arcb-wider-updater/issues) açabilirsiniz.
