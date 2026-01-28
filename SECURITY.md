# Security Policy / Güvenlik Politikası

## Supported Versions / Desteklenen Sürümler

| Version | Security Updates | Status |
|---------|-----------------|--------|
| v5.x    | Yes / Evet | ✅ Active / Aktif |
| v4.1.x  | Limited / Sınırlı | 🟡 Critical only / Sadece kritik |
| v4.0.x  | No / Hayır | ⚠️ Deprecated / Kullanımdan kaldırıldı |
| v3.x    | No / Hayır | ⚠️ Deprecated / Kullanımdan kaldırıldı |

Only the **main** branch is actively maintained and supported.

Sadece **main** dalı aktif olarak desteklenmektedir.

---

## Reporting a Vulnerability / Güvenlik Açığı Bildirme

If you discover a security vulnerability, please report it **responsibly** and **privately**.

Bir güvenlik açığı keşfederseniz, lütfen **sorumlu** ve **gizli** bir şekilde bildirin.

### Preferred Methods / Tercih Edilen Yöntemler:

1. 📧 **Email:** meet@calmkernel.tr
2. 🔒 **GitHub Security Advisory:** [Report a vulnerability](https://github.com/ahm3t0t/arcb-wider-updater/security/advisories/new)
3. 📋 **GitHub Issue (Public):** Use `security` label only after fix is discussed / Düzeltme tartışıldıktan sonra `security` etiketi kullanın

### What to Include / Neleri Ekleyin:

- Description of the vulnerability / Açığın tanımı
- Steps to reproduce (if applicable) / Tekrar adımları (varsa)
- Potential impact / Potansiyel etki
- Your suggested fix (if any) / Önerilen çözümünüz (varsa)

**Timeline / Süre:** We aim to acknowledge reports within 48 hours and provide updates on progress.

48 saat içinde raporları onaylamayı ve ilerleme güncellemeleri sağlamayı hedefliyoruz.

Please avoid sharing sensitive details publicly before a fix is available. Thank you for helping keep ARCB secure!

Düzeltme yayınlanmadan önce hassas detayları herkese açık paylaşmaktan kaçının. ARCB'yi güvende tutmamıza yardım ettiğiniz için teşekkürler!

---

## 🔐 Release Signature Verification / Sürüm İmza Doğrulama (v4.1.0+)

From **v4.1.0 onwards**, all releases are **cryptographically signed with GPG**.

**v4.1.0'dan itibaren** tüm sürümler **GPG ile kriptografik olarak imzalanmaktadır**.

### Why Sign Releases? / Neden İmzalıyoruz?

- ✅ Proves releases come from official maintainer / Sürümlerin resmi bakımcıdan geldiğini kanıtlar
- ✅ Detects tampering or man-in-the-middle attacks / Değişiklik veya ortadaki adam saldırılarını tespit eder
- ✅ Ensures file integrity (SHA256SUMS) / Dosya bütünlüğünü sağlar
- ✅ Industry standard security practice / Endüstri standardı güvenlik uygulaması

### Quick Verification / Hızlı Doğrulama

#### Step 1: Import Public Key / Adım 1: Public Key'i İçe Aktar
```bash
# Import GPG key from repository
# GPG anahtarını repodan içe aktar
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/pubkey.asc | gpg --import

# Verify key fingerprint / Anahtar parmak izini doğrula
gpg --list-keys ahmet@tanrikulu.net
# Expected / Beklenen: A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF
```

#### Step 2: Download Release Files / Adım 2: Release Dosyalarını İndir
```bash
# Download checksums and signature
# Checksum ve imzayı indir
curl -fsSL https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
```

#### Step 3: Verify Signature / Adım 3: İmzayı Doğrula
```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
# Look for / Arayın: "Good signature from Ahmet T. (arcb-wider-updater signing key)"
```

#### Step 4: Verify File Hash / Adım 4: Dosya Hash'ini Doğrula
```bash
# Download the script / Scripti indir
curl -fsSL https://github.com/ahm3t0t/arcb-wider-updater/releases/latest/download/guncel -o guncel

# Verify hash / Hash'i doğrula
sha256sum -c SHA256SUMS --ignore-missing
# Expected / Beklenen: guncel: OK
```

### Signing Key Information / İmza Anahtarı Bilgileri

| Property / Özellik | Value / Değer |
|--------------------|---------------|
| **Key ID** | `E5B757C69EFF27BF` |
| **Fingerprint / Parmak İzi** | `A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF` |
| **UID** | `Ahmet T. (arcb-wider-updater signing key) <ahmet@tanrikulu.net>` |
| **Created / Oluşturma** | 2026-01-28 |
| **Algorithm / Algoritma** | RSA 4096 |

### Automated Verification / Otomatik Doğrulama

The `install.sh` script performs GPG verification automatically during installation. If GPG is not installed, verification is skipped with a warning.

`install.sh` scripti kurulum sırasında GPG doğrulamasını otomatik yapar. GPG kurulu değilse, uyarı ile atlanır.

```bash
# Full verified installation / Tam doğrulamalı kurulum
curl -fsSL https://raw.githubusercontent.com/ahm3t0t/arcb-wider-updater/main/install.sh | sudo bash
```

---

## 🛡️ Security Features / Güvenlik Özellikleri

### Strict Mode
```bash
set -Eeuo pipefail
```
- Exits on any error / Herhangi bir hatada çıkar
- Exits on undefined variables / Tanımsız değişkenlerde çıkar
- Exits on pipe failures / Pipe hatalarında çıkar

### TLS 1.2+ Hardening (v4.1.5+)
All network operations enforce modern TLS:
Tüm ağ işlemleri modern TLS kullanır:

```bash
# curl
curl --proto '=https' --tlsv1.2 ...

# wget
wget --secure-protocol=TLSv1_2 ...
```

### Secure Temporary Files
```bash
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT
```

### Lock File Protection
```bash
exec 200>/var/lock/arcb-updater.lock
flock -n 200 || exit 1
```
