# ARCB Wider Updater 🛡️

![CI Status](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)
![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver&label=Latest%20Version&color=blue)
![License](https://img.shields.io/github/license/ahm3t0t/arcb-wider-updater)

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
    * Windows satır sonu (`\r`) ve bozuk veri koruması.
* **Akıllı Installer:**
    * Pipe ile çalışırken (`curl | sudo bash`) güvenli yetki yönetimi.
    * Yerel dosya tespiti (Geliştirici dostu).
    * Her güncellemede eski sürümü otomatik yedekler.

## 📦 Kurulum (Tek Satır)

Aşağıdaki komutu terminale yapıştırın. Script gerekli yetkileri güvenli bir şekilde isteyecek ve kurulumu tamamlayacaktır:

```bash
curl -fsSL [https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh](https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh) | sudo bash
```

## 🛠️ Kullanım

Kurulumdan sonra terminalde `guncel` yazmanız yeterlidir.

```bash
# İnteraktif Mod (Önerilen - Detaylı çıktı verir)
guncel

# Otomatik Mod (Soru sormaz - Cron/Zamanlanmış görevler için)
guncel --auto
```

## 📋 Sürüm Notları

* **v3.4.2 (Solid Foundation):** Akıllı yerel dosya tespiti, Installer/Script sürüm senkronizasyonu ve Fedora tam uyumu.
* **v3.4.0 (Ironclad):** Gelişmiş hata yönetimi, ortam değişkeni koruması (`sudo -E`) ve güvenli temp dosyası kullanımı.
* **v3.3.6 (Diamond Polish):** Snapper ve DNF entegrasyonunun tamamlanması.

---
*Geliştirici: Ahmet Reis & Çeto Başkan - Lisans: MIT*
