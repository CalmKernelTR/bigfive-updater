[![CI](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/ahm3t0t/arcb-wider-updater/actions/workflows/ci.yml)   [![Latest Release](https://img.shields.io/github/v/release/ahm3t0t/arcb-wider-updater?sort=semver)](https://github.com/ahm3t0t/arcb-wider-updater/releases/latest)   [![Stable Release](https://img.shields.io/badge/stable-v2.97-brightgreen)](https://github.com/ahm3t0t/arcb-wider-updater/releases/tag/v2.97)


# ARCB Wider Updater

**Tembel ama takıntılı adminin en yakın dostu**
> One command. One updater. Zero nonsense.



ARCB Wider Updater; Linux sistemlerde:
- APT / DNF güncellemeleri
- Flatpak / Snap güncellemeleri
- Firmware (fwupd)
- Güvenli kernel budama
- Opsiyonel GUI (Zenity)

tek komutla ve loglayarak yapan bir updater scriptidir.
Çeto Başkan ve Ahmet Reis ortak yapımıdır ;)


## 🚀 Hızlı Kurulum (Quick Install)

> Not: Kurulum scripti açık kaynaklıdır. İncelemek için:
> https://github.com/ahm3t0t/arcb-wider-updater/blob/main/install.sh

Aşağıdaki tek komut ile **ARCB Wider Updater** sistemine kurulabilir:

```bash
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | bash
```

## Kullanım

Varsayılan mod “sessiz”: özet ekrana, detaylar log dosyasına gider (önerilen).
```bash
guncel
```

Paket yöneticilerinin çıktılarını da terminalde görmek istersen:
```bash
guncel --show-output
```

GUI (zenity) istemiyorsan / sunucuda çalıştırıyorsan:
```bash
guncel --no-gui
```

Yardım:
```bash
guncel --help
```


## 🛣️ v3.0 Roadmap

ARCB Wider Updater’ın gelecekteki yönünü ve tasarım kararlarını görmek için:  
👉 [ROADMAP_v3.md](ROADMAP_v3.md)

