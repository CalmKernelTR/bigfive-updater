# Güvenlik Politikası

## Desteklenen Sürümler

| Sürüm | Güvenlik Güncellemeleri | Durum |
|-------|-------------------------|-------|
| v6.x    | Evet | Aktif |
| v5.x    | Evet | Sadece güvenlik |
| < v5.0  | Hayır | Kullanımdan kaldırıldı |

Sadece **main** dalı aktif olarak desteklenmektedir.

---

## Güvenlik Açığı Bildirme

Bir güvenlik açığı keşfederseniz, lütfen **sorumlu** ve **gizli** bir şekilde bildirin.

### Tercih Edilen Yöntemler:

1. **Email:** meet@calmkernel.tr
2. **GitHub Security Advisory:** [Güvenlik açığı bildir](https://github.com/CalmKernelTR/bigfive-updater/security/advisories/new)
3. **GitHub Issue (Herkese Açık):** Düzeltme tartışıldıktan sonra `security` etiketi kullanın

### Neleri Ekleyin:

- Açığın tanımı
- Tekrar adımları (varsa)
- Potansiyel etki
- Önerilen çözümünüz (varsa)

**Süre:** 48 saat içinde raporları onaylamayı ve ilerleme güncellemeleri sağlamayı hedefliyoruz.

Düzeltme yayınlanmadan önce hassas detayları herkese açık paylaşmaktan kaçının. BigFive'ı güvende tutmamıza yardım ettiğiniz için teşekkürler!

---

## Sürüm İmza Doğrulama (v4.1.0+)

**v4.1.0'dan itibaren** tüm sürümler **GPG ile kriptografik olarak imzalanmaktadır**.

### Neden İmzalıyoruz?

- Sürümlerin resmi bakımcıdan geldiğini kanıtlar
- Değişiklik veya ortadaki adam saldırılarını tespit eder
- Dosya bütünlüğünü sağlar (SHA256SUMS)
- Endüstri standardı güvenlik uygulaması

### Hızlı Doğrulama

#### Adım 1: Public Key'i İçe Aktar
```bash
# GPG anahtarını repodan içe aktar
curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc | gpg --import

# Anahtar parmak izini doğrula
gpg --list-keys ahmet@tanrikulu.net
# Beklenen: A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF
```

#### Adım 2: Release Dosyalarını İndir
```bash
# Checksum ve imzayı indir
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
```

#### Adım 3: İmzayı Doğrula
```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
# Arayın: "Good signature from Ahmet T. (bigfive-updater signing key)"
```

#### Adım 4: Dosya Hash'ini Doğrula
```bash
# Scripti indir
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/guncel -o guncel

# Hash'i doğrula
sha256sum -c SHA256SUMS --ignore-missing
# Beklenen: guncel: OK
```

### İmza Anahtarı Bilgileri

| Özellik | Değer |
|---------|-------|
| **Key ID** | `E5B757C69EFF27BF` |
| **Parmak İzi** | `A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF` |
| **UID** | `Ahmet T. (bigfive-updater signing key) <ahmet@tanrikulu.net>` |
| **Oluşturma** | 2026-01-28 |
| **Algoritma** | RSA 4096 |

### Otomatik Doğrulama

`install.sh` scripti kurulum sırasında GPG doğrulamasını otomatik yapar. GPG kurulu değilse, uyarı ile atlanır.

```bash
# Tam doğrulamalı kurulum
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash
```

---

## Güvenlik Özellikleri

### Strict Mode
```bash
set -Eeuo pipefail
```
- Herhangi bir hatada çıkar
- Tanımsız değişkenlerde çıkar
- Pipe hatalarında çıkar

### TLS 1.2+ Güçlendirmesi (v4.1.5+)
Tüm ağ işlemleri modern TLS kullanır:

```bash
# curl
curl --proto '=https' --tlsv1.2 ...

# wget
wget --secure-protocol=TLSv1_2 ...
```

### Güvenli Geçici Dosyalar
```bash
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT
```

### Lock Dosyası Koruması
```bash
exec 9> "$LOCK_FILE"
flock -n 9 || exit 1
```
