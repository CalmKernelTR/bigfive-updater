# BigFive Updater — Tam Dokümantasyon (Türkçe)

> **Tek komut. Tüm dağıtımlar. Sıfır saçmalık.**
>
> Linux sistemleri için akıllı, çoklu dağıtım güncelleme aracı. Saf Bash. Sıfır bağımlılık. Fedora, Ubuntu/Debian, Arch, openSUSE ve Alpine üzerinde çalışır.

---

## Ne Yapar?

BigFive Updater, Linux dağıtımınızı otomatik algılar, doğru paket yöneticisini seçer ve sisteminizi günceller. Her işlemi loglar, güncelleme öncesi önizleme sunar, sistem sağlık kontrolü yapar ve ister Fedora masaüstünde ister Alpine container'da olun tutarlı bir deneyim sağlar.

**Paket yöneticinizin yerine geçmez.** Etrafına, zamanınız olsa kendiniz yapacağınız güvenlik katmanlarını ve kolaylıkları ekler.

### Temel Özellikler

- **Otomatik algılama** — 5 paket yöneticisi ailesi, 20+ dağıtım tanıma
- **İnteraktif ve otomatik modlar** — `guncel` elle, `guncel --auto` cron için
- **Kuru çalıştırma** — `--dry-run` ile hiçbir şeye dokunmadan neyin değişeceğini gör
- **Sistem doktoru** — `--doctor` ile repo sağlığı, disk alanı, kırık bağımlılıklar, eski kilitler kontrol
- **Güncelleme geçmişi** — `--history` ile geçmiş güncellemeleri zaman damgasıyla incele
- **Logrotate dahil** — her güncelleme loglanır, eski loglar otomatik döndürülür
- **Çoklu dil** — Türkçe (varsayılan) ve İngilizce, çalışma anında `--lang en` ile değiştir
- **Shell tamamlama** — Bash, Zsh, Fish
- **SHA256 doğrulama** — sürüm bütünlüğü imzalı checksum ile doğrulanır
- **Üç alias** — `guncel`, `updater`, `bigfive` — hangisi aklınızda kalırsa

---

## Desteklenen Dağıtımlar

| Aile | Dağıtımlar | Paket Yöneticisi |
|---|---|---|
| **Red Hat** | Fedora, RHEL, CentOS Stream, Rocky Linux, AlmaLinux | `dnf` / `yum` |
| **Debian** | Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin OS, elementary OS | `apt` |
| **Arch** | Arch Linux, Manjaro, EndeavourOS, CachyOS, Garuda | `pacman` |
| **SUSE** | openSUSE Leap, openSUSE Tumbleweed, GeckoLinux | `zypper` |
| **Alpine** | Alpine Linux | `apk` |

---

## Kurulum

### Evrensel (Tüm Dağıtımlar)

```bash
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash
```

Kurulum scripti dağıtımınızı algılayıp her şeyi doğru yere yerleştirir. Kurulanlar:
- Ana `guncel` scripti → `/usr/local/bin/`
- Bash, Zsh, Fish shell tamamlamaları
- Logrotate yapılandırması
- Örnek config dosyası
- Man sayfası (varsa)

### Arch Linux (AUR)

```bash
yay -S bigfive-updater
# veya
paru -S bigfive-updater
```

### Alpine Linux

```bash
# İmza anahtarını içe aktar
wget -qO /etc/apk/keys/bigfive-updater.rsa.pub \
  https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/bigfive-updater.rsa.pub

# Repo ekle
echo "https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/" >> /etc/apk/repositories

# Kur
apk add bigfive-updater
```

### Fedora (COPR)

```bash
dnf copr enable calmkernel/bigfive-updater
dnf install bigfive-updater
```

### Manuel Kurulum

```bash
git clone https://github.com/CalmKernelTR/bigfive-updater.git
cd bigfive-updater
sudo bash install.sh
```

### Kurulumu Doğrula

```bash
guncel --version
guncel --help
```

---

## Kullanım

### Temel

```bash
guncel              # İnteraktif mod — devam etmeden önce sorar
guncel --auto       # Otomatik mod — her şeyi çalıştırır, soru sormaz
guncel --dry-run    # Önizleme modu — neyin değişeceğini gösterir, hiçbir şeye dokunmaz
```

### Tanılama

```bash
guncel --doctor     # Sistem sağlık kontrolü: repolar, disk, bağımlılıklar, kilitler
guncel --history    # Geçmiş güncelleme loglarını incele
guncel --verbose    # Paket yöneticisinin tam çıktısını göster
```

### Seçenekler

```bash
guncel --quiet      # Minimal çıktı (scriptler için uygun)
guncel --lang en    # Çıktı dilini İngilizce'ye çevir
guncel --lang tr    # Çıktı dilini Türkçe'ye çevir (varsayılan)
guncel --help       # Tüm seçenekleri göster
```

### Cron Örneği

```bash
# /etc/cron.d/bigfive-updater
0 3 * * 1 root /usr/local/bin/guncel --auto --quiet >> /var/log/bigfive-updater/cron.log 2>&1
```

---

## Yapılandırma

BigFive Updater sıfır yapılandırmayla kutudan çıktığı gibi çalışır. Özelleştirmek için örnek config'i kopyalayın:

```bash
sudo cp /etc/bigfive-updater.conf.example /etc/bigfive-updater.conf
```

Seçenekler:
- Varsayılan dil
- Otomatik güncelleme davranışı
- Log ayrıntı düzeyi
- Güncelleme öncesi/sonrası hook'lar
- Hariç tutulan paketler

Tüm seçenekler örnek config dosyasında açıklamalarıyla birlikte mevcuttur.

---

## Nasıl Çalışır?

1. `/etc/os-release` dosyasından çalışan dağıtımı algılar
2. Dağıtımı doğru paket yöneticisi ailesine eşler
3. Uygun güncelleme komutlarını mantıklı flag'lerle çalıştırır
4. Çıktıyı yakalar ve zaman damgasıyla loglar
5. Başarı/hata durumunu monitoring'e uygun çıkış kodlarıyla raporlar

Harici bağımlılık yok. Python yok. Node.js yok. Sadece Bash ve sisteminizde zaten bulunan araçlar.

---

## Sürüm Sistemi

Bu proje iki ayrı sürüm izlemesi kullanır:

| Bileşen | Format | Açıklama |
|---|---|---|
| `guncel` (ana script) | SemVer (ör. 6.1.2) | Aracın kendisi |
| `install.sh` | SemVer (ör. 2.0.1) | Kurulum scripti, bağımsız sürümlenir |

---

## Kimin İçin?

- Farklı dağıtımlarda tek, akılda kalıcı bir güncelleme komutu isteyen **masaüstü kullanıcıları**
- Karma Linux ortamları (Fedora/Ubuntu/Alpine bir arada) yöneten **sistem yöneticileri**
- Farklı dağıtımlarla birden fazla makine veya VM çalıştıran **homelab meraklıları**
- Güncellemelerinin etrafında loglama, sağlık kontrolü ve kuru çalıştırma isteyen **herkes**

## Kimin İçin DEĞİL?

- Tek bir dağıtımda tek bir makine kullanıyorsanız ve kaslarınız `apt upgrade` için hazırsa, buna ihtiyacınız yok
- Düzinelerce sunucuda orkestrasyon gerekiyorsa Ansible/Salt kullanın — BigFive yerel bir araçtır

---

## Proje Yapısı

```
bigfive-updater/
├── guncel                  # Ana script
├── install.sh              # Kurulum scripti
├── bigfive-updater.conf.example  # Yapılandırma şablonu
├── completions/            # Shell tamamlamaları (bash, zsh, fish)
├── lang/                   # Çoklu dil dosyaları
├── docs/                   # Ek dokümantasyon
├── tests/                  # Test paketi (Docker tabanlı çoklu dağıtım)
├── packaging/              # Dağıtım paketleme (RPM spec, PKGBUILD, vb.)
├── logrotate.d/            # Logrotate yapılandırması
└── .github/                # CI/CD iş akışları
```

---

## Katkıda Bulunma

Katkılarınızı bekliyoruz! Rehber için [CONTRIBUTING.tr.md](CONTRIBUTING.tr.md) dosyasına bakın.

- [Davranış Kuralları](CODE_OF_CONDUCT.tr.md)
- [Güvenlik Politikası](SECURITY.tr.md)
- [Yol Haritası](ROADMAP.tr.md)
- [Değişiklik Günlüğü](CHANGELOG.tr.md)

---

## Lisans

[MIT](LICENSE) — kullanın, fork'layın, geliştirin.

---

<p align="center">
  <i><a href="https://calmkernel.tr">CalmKernel</a> yapımı — tembel ama takıntılı adminin en yakın dostu.</i>
</p>
