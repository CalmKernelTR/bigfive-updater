# ARCB Wider Updater – v3.0 Roadmap

> **Silent by default. Transparent when needed.**
>
> Bu roadmap, ARCB Wider Updater’ın v2.97 ile ulaştığı olgunluk seviyesinden sonra,
> v3.0 sürümünde hedeflenen mimari, UX ve platform kararlarını tanımlar.

---

## 🎯 v3.0 Ana Hedef

v3.0, yeni özelliklerden çok **netlik, sürdürülebilirlik ve bilinçli tasarım** sürümüdür.

Odak noktaları:

* Çoklu distro desteğini resmileştirmek (APT + DNF)
* Kod mimarisini sadeleştirmek
* CLI / GUI davranışını kesin kurallara bağlamak
* Otomasyon ve manuel kullanım arasında denge kurmak

---

## 1️⃣ Platform Kapsamı (Kesin)

Desteklenen sistemler:

* Fedora / RHEL / Rocky / Alma
* Debian / Ubuntu / Zorin / Mint

Bilinçli olarak kapsam dışı:

* Arch / Manjaro (rolling release)
* openSUSE (şimdilik)

> README ve script başında açıkça belirtilecek:
> **“APT ve DNF tabanlı sistemler için tasarlanmıştır.”**

---

## 2️⃣ Paket Yöneticisi Soyutlaması (PM Layer)

Amaç: Paket yöneticisi farklarını ana akıştan tamamen izole etmek.

Planlanan yapı:

* `detect_pm()`
* `pm_update()`
* `pm_cleanup()`
* `pm_kernel_prune()` (opsiyonel)

Avantajlar:

* Main flow sadeleşir
* Yeni PM eklemek kolaylaşır
* Test edilebilirlik artar

---

## 3️⃣ Kernel Temizliği (Opsiyonel)

### APT tabanlı sistemler

* Çalışan kernel + 1 önceki korunur
* Diğer kernel paketleri temizlenebilir

### DNF tabanlı sistemler

* Varsayılan: **kapalı**
* Fedora zaten kernel yönetimini iyi yapıyor

UX:

* GUI / CLI ile açık onay
* Disk alanı kazanımı önceden bildirilir

---

## 4️⃣ Concurrency & Lock Mekanizması

Mevcut yapı v3’te çekirdek özellik olarak kalıcılaşır:

* `/tmp/arcb_updater.lock`
* PID doğrulaması
* Çifte çalışmayı engelleme

README’de özellikle vurgulanır:

> “Aynı anda iki terminalde çalıştırılamaz.”

---

## 5️⃣ Çıktı ve Verbosity Modeli

Varsayılan davranış:

* Sessiz mod
* Özet ekrana
* Detaylar log dosyasında

Kontroller:

* `--show-output`
* `SHOW_OUTPUT=1`

v3 opsiyonları:

* `--quiet` (sadece kritik hata)
* `--dry-run` (değişiklik yapmadan göster)

---

## 6️⃣ GUI / CLI Davranışı (Net Kural)

* GUI varsayılan davranıştır (Zenity varsa)
* `--no-gui` = tamamen CLI
* `--gui` **yoktur ve olmayacaktır**

Fallback zinciri:

1. Zenity
2. less / tail
3. saf stdout

---

## 7️⃣ Genişletilmiş Health Checks

Mevcut:

* Disk doluluk
* Failed services
* Snap health

v3 eklenebilecekler:

* `/boot` doluluk uyarısı
* inode doluluk (`df -i`)
* swap kullanım uyarısı
* flatpak pinned runtime bilgilendirmesi

---

## 8️⃣ Özet & Raporlama 2.0

Genişletilmiş sonuç ekranı:

* Güncellenen paket sayısı
* Açılan disk alanı
* Reboot gereksinimi

Amaç:

> “Log’a bakmadan sistem durumu anlaşılabilsin.”

---

## 9️⃣ Otomasyon Modu

Yeni modlar:

* `--auto`

  * Hiç soru sormaz
  * Journal temizliği dahil

Uyumluluk:

* cron
* systemd timer

---

## 🔟 Bildirim Entegrasyonları (Opsiyonel)

Tamamen isteğe bağlı:

* Telegram
* Discord webhook
* Mail

Varsayılan: **kapalı**

---

## 1️⃣1️⃣ Proje Sunumu & README

v3 ile beraber:

* Stable Release badge
* Test edilen sistemler listesi
* Kısa felsefe bölümü:

> *Silent by default. Transparent when needed.*

---

## 1️⃣2️⃣ Bilinçli Olarak v3 Dışında Bırakılanlar

* Rust rewrite
* Daemon mode
* Ayrı GUI uygulaması

Bunlar **v3+** veya bağımsız projeler olarak değerlendirilir.

---

## 🧭 Kapanış

v3.0, ARCB Wider Updater’ın:

* daha az sürprizli
* daha okunabilir
* daha güvenilir

bir bakım aracı haline gelmesini hedefler.

> **Tembel ama takıntılı adminler için.**

> Not: v3.0 sadece mimari ve kullanım iyileştirmelerine odaklanır.
> Rust rewrite, daemon mode vb. büyük mimari değişiklikler bu sürüm kapsamı dışındadır.

