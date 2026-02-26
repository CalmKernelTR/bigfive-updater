# BigFive Updater'a Katkıda Bulunma

Katkıda bulunmayı düşündüğün için teşekkürler!

---

## İçindekiler

- [Hızlı Kurallar](#-hızlı-kurallar)
- [Geliştirme Ortamı](#️-geliştirme-ortamı)
- [Kod Stili](#-kod-stili)
- [Commit Mesaj Formatı](#-commit-mesaj-formatı)
- [Sürüm Yönetimi](#-sürüm-yönetimi)
- [Release Oluşturma](#-release-oluşturma)
- [Test Senaryoları](#-test-senaryoları)
- [PR Süreci](#-pr-süreci)
- [Komut Satırı Seçenekleri](#-komut-satırı-seçenekleri)

---

## Hızlı Kurallar

- Basit, okunabilir ve güvenli kod yaz
- Mümkün olduğunca POSIX uyumlu shell kullan
- Asla log'lara secret yazdırma
- Yeni özellikler, araç yoksa graceful degrade etmeli

---

## Geliştirme Ortamı

```bash
git clone git@github.com:CalmKernelTR/bigfive-updater.git
cd bigfive-updater
chmod +x guncel install.sh release.sh
./guncel --help
```

### Gerekli Araçlar

| Araç | Versiyon | Amaç |
|------|----------|------|
| `bash` | 4.0+ | Script çalıştırma |
| `shellcheck` | güncel | Kod analizi |
| `bats` | 1.10+ | Birim testler |
| `curl` veya `wget` | - | İndirmeler |

### Önerilen Araçlar

| Araç | Amaç |
|------|------|
| `shfmt` | Bash formatter |
| `docker` | Çoklu dağıtım testi |
| `act` | Yerel GitHub Actions |
| `gh` | GitHub CLI |

---

## Kod Stili

### ShellCheck Kuralları

Tüm kod ShellCheck'ten geçmeli:

```bash
shellcheck -x guncel install.sh release.sh
```

### Girintileme (Google Shell Style Guide)

- **2 space** kullan (tab değil) - [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- Nested bloklar için tutarlı girintileme
- Format kontrolü: `shfmt -d -i 2 -ci -sr guncel`

```bash
# Doğru (2 space - Google style)
if [[ "$condition" == "true" ]]; then
  echo "2 space indent"
  if [[ "$nested" == "true" ]]; then
    echo "4 space for nested"
  fi
fi

# Yanlış (4 space)
if [[ "$condition" == "true" ]]; then
    echo "4 space - wrong"
fi
```

### POSIX Uyumluluğu

- `[[ ]]` yerine `[ ]` tercih et (mümkünse)
- Bash-specific özellikler gerektiğinde `#!/usr/bin/env bash` kullan
- `local` değişkenler fonksiyonlarda kullanılmalı

```bash
# Tercih edilen
my_function() {
    local my_var="value"
    # ...
}

# Bash-specific gerektiğinde
if [[ "$string" =~ ^[0-9]+$ ]]; then
    # regex için [[ ]] gerekli
fi
```

### Değişken Adlandırma

- Global değişkenler: `UPPER_SNAKE_CASE`
- Local değişkenler: `lower_snake_case`
- Fonksiyonlar: `lower_snake_case`

```bash
# Global
VERSION="5.2.0"
LOG_FILE="/var/log/app.log"

# Local (fonksiyon içinde)
my_function() {
    local temp_file
    local counter=0
}
```

---

## Commit Mesaj Formatı

[Conventional Commits](https://www.conventionalcommits.org/) formatını kullanıyoruz:

```
type(scope): description

[opsiyonel body]

[opsiyonel footer]
```

### Type Değerleri

| Type | Açıklama |
|------|----------|
| `feat` | Yeni özellik |
| `fix` | Bug düzeltme |
| `docs` | Dokümantasyon |
| `style` | Kod formatı (işlevsel değişiklik yok) |
| `refactor` | Kod yeniden yapılandırma |
| `test` | Test ekleme/düzeltme |
| `chore` | Build, CI, bağımlılık güncellemeleri |

### Scope Değerleri

| Scope | Açıklama |
|-------|----------|
| `apt` | APT paket yöneticisi |
| `dnf` | DNF paket yöneticisi |
| `pacman` | Pacman paket yöneticisi (Arch) |
| `zypper` | Zypper paket yöneticisi (openSUSE) |
| `apk` | APK paket yöneticisi (Alpine) |
| `flatpak` | Flatpak güncellemeleri |
| `snap` | Snap güncellemeleri |
| `fwupd` | Firmware güncelleme |
| `install` | Kurulum scripti |
| `ci` | CI/CD workflow |
| `config` | Yapılandırma dosyaları |
| `docs` | Dokümantasyon |
| `test` | Test dosyaları |

### Örnekler

```bash
# Yeni özellik
feat(apk): add Alpine Linux package manager support

# Bug düzeltme
fix(pacman): resolve orphan package detection issue

# Dokümantasyon
docs(readme): update BigFive support information

# CI güncellemesi
chore(ci): add Alpine to test matrix

# Refactoring
refactor(logging): consolidate print functions
```

---

## Sürüm Yönetimi

Bu projede **iki ayrı versiyon sistemi** kullanılmaktadır:

### 1. Ana Script (guncel) - SemVer

**Format:** `MAJOR.MINOR.PATCH` (örn: 6.5.1)

| Segment | Ne Zaman Artırılır |
|---------|--------------------|
| MAJOR | Geriye uyumsuz API değişiklikleri |
| MINOR | Geriye uyumlu yeni özellikler |
| PATCH | Geriye uyumlu bug düzeltmeleri |

**Güncelleme Sıklığı:** Her özellik veya fix'te

```bash
# guncel içinde
VERSION="6.5.1"
EDITION="Fluent"
CODENAME="India"
```

### 2. Kurulum Scripti (install.sh) - Night Version

**Format:** `Night-Vx.x.x` (örn: Night-V1.4.3)

**Güncelleme Sıklığı:** Sadece kurulum mantığı değiştiğinde

```bash
# install.sh içinde
# BigFive Updater Installer Night-V1.4.3
```

### Neden Ayrı Sistemler?

| Sebep | Açıklama |
|-------|----------|
| **Farklı Değişim Hızları** | Ana script sık güncellenir, installer nadiren değişir |
| **Bağımsız Takip** | Installer değişikliklerini ayrı izlemek daha kolay |

---

## Release Oluşturma

### release.sh Kullanımı

```bash
# Patch release (bug fix): 6.5.1 → 6.5.2
./release.sh patch

# Minor release (new feature): 6.5.1 → 6.6.0
./release.sh minor

# Major release (breaking change): 6.5.1 → 7.0.0
./release.sh major

# Manuel versiyon: → 6.5.5
./release.sh 6.5.5

# Otomatik onay (CI için)
./release.sh patch -y
```

### release.sh Ne Yapar?

1. `guncel` dosyasındaki VERSION'ı günceller
2. Git commit oluşturur
3. Git tag oluşturur
4. GitHub'a push eder
5. GitHub Actions GPG ile imzalar

### Versiyon Güncelleme Checklist

- [ ] `guncel` içinde `VERSION` ve `CODENAME` güncelle
- [ ] `CHANGELOG.en.md` ve `CHANGELOG.tr.md`'ye entry ekle
- [ ] `SHA256SUMS` dosyasını güncelle (otomatik - GitHub Actions)
- [ ] (Gerekirse) `install.sh` versiyonunu güncelle

---

## Test Senaryoları

### 1. ShellCheck Lint

```bash
shellcheck -x guncel install.sh release.sh
```

### 2. Bash Syntax Check

```bash
bash -n guncel
bash -n install.sh
bash -n release.sh
```

### 3. BATS Unit Tests

```bash
# Tüm testleri çalıştır
bats tests/*.bats

# Verbose çıktı
bats --tap tests/*.bats

# Sadece guncel testleri
bats tests/guncel.bats

# Sadece install testleri
bats tests/install.bats
```

### 4. Dry-Run Testi

```bash
# Root olmadan (hata vermeli)
./guncel --dry-run

# Root ile
sudo ./guncel --dry-run
```

### 5. Help Çıktı Kontrolü

```bash
./guncel --help
# Çıktıda şunlar olmalı:
# - VERSION ve CODENAME
# - Tüm seçenekler (--auto, --verbose, --quiet, --dry-run, --skip, --only)
# - Örnekler
```

### 6. Docker Multi-Distro Test

```bash
# Ubuntu test
docker run --rm -v "$(pwd):/app" ubuntu:24.04 bash -c "apt-get update && apt-get install -y curl && bash /app/install.sh && guncel --help"

# Fedora test
docker run --rm -v "$(pwd):/app" fedora:40 bash -c "dnf install -y curl && bash /app/install.sh && guncel --help"

# Arch test
docker run --rm -v "$(pwd):/app" archlinux:latest bash -c "pacman -Sy --noconfirm curl && bash /app/install.sh && guncel --help"

# openSUSE test
docker run --rm -v "$(pwd):/app" opensuse/tumbleweed:latest bash -c "zypper install -y curl gawk && bash /app/install.sh && guncel --help"

# Alpine test
docker run --rm -v "$(pwd):/app" alpine:3.20 sh -c "apk add bash curl && bash /app/install.sh && guncel --help"
```

### Test Durumu

| Bileşen | Test Sayısı | Durum |
|---------|-------------|-------|
| guncel.bats | 134 | ✅ |
| install.bats | 39 | ✅ |
| **Toplam** | **193** | ✅ |

### Code Coverage

Codecov ile test coverage takip edilir:
- **Dashboard:** https://app.codecov.io/gh/CalmKernelTR/bigfive-updater
- **Badge:** README.md'de görünür
- **CI:** Her PR'da coverage raporu oluşturulur

Coverage çalıştırma (lokal):
```bash
# kcov kurulumu (Ubuntu)
sudo apt-get install -y cmake libcurl4-openssl-dev libdw-dev binutils-dev zlib1g-dev
git clone --depth 1 https://github.com/SimonKagstrom/kcov.git /tmp/kcov
cd /tmp/kcov && mkdir build && cd build && cmake .. && make -j$(nproc) && sudo make install

# Coverage toplama
kcov --include-path=$(pwd)/guncel ./coverage ./guncel --help
kcov --include-path=$(pwd)/guncel ./coverage ./guncel --doctor
```

---

## PR Süreci

### Branch Naming Convention

```
type/short-description
```

**Örnekler:**
- `feat/alpine-support`
- `fix/pacman-orphan-detection`
- `docs/bigfive-readme`
- `chore/ci-alpine-matrix`

### PR Oluşturma Adımları

1. **Fork & Clone**
   ```bash
   git clone git@github.com:YOUR_USERNAME/bigfive-updater.git
   cd bigfive-updater
   ```

2. **Feature Branch Oluştur**
   ```bash
   git checkout -b feat/my-feature
   ```

3. **Değişiklikleri Yap & Test Et**
   ```bash
   # Kod değişiklikleri
   shellcheck -x guncel install.sh
   bash -n guncel
   bats tests/*.bats
   ./guncel --help
   ```

4. **Commit & Push**
   ```bash
   git add -A
   git commit -m "feat(scope): description"
   git push origin feat/my-feature
   ```

5. **PR Aç**
   - Base: `main`
   - Compare: `feat/my-feature`

### PR Review Checklist

- [ ] ShellCheck hatasız geçiyor
- [ ] `bash -n` syntax check başarılı
- [ ] `bats tests/*.bats` testler geçiyor
- [ ] `--help` çıktısı güncel
- [ ] `--dry-run` çalışıyor
- [ ] CHANGELOG güncellendi (gerekirse)
- [ ] Commit mesajları conventional format'ta

---

## Komut Satırı Seçenekleri

Script şu flag'leri destekler:

| Flag | Açıklama |
|------|----------|
| `--auto` | Otomatik mod - soru sormaz |
| `--verbose` | Detaylı çıktı |
| `--quiet` | Sessiz mod - sadece hata ve özet |
| `--dry-run` | Kuru çalıştırma - değişiklik yapmaz |
| `--skip <backend>` | Belirtilen backend'leri atla |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır |
| `--uninstall` | Aracı kaldır |
| `--uninstall --purge` | Aracı ve config/log'ları kaldır |
| `--help` | Yardım mesajı |
| `--json` | Monitoring için JSON çıktı |
| `--json-full` | SIEM/audit için detaylı JSON |
| `--doctor` | Sistem sağlık kontrolü |
| `--history [N]` | Güncelleme geçmişi (son N gün) |
| `--jitter [N]` | Cron için rastgele gecikme (0-N saniye) |
| `--security-only` | Sadece güvenlik güncellemeleri |
| `--lang <code>` | Çıktı dilini ayarla (tr/en) |

### Backend Değerleri

| Backend | Açıklama |
|---------|----------|
| `system` | Tüm paket yöneticileri |
| `apt` | APT (Debian/Ubuntu) |
| `dnf` | DNF (Fedora/RHEL) |
| `pacman` | Pacman (Arch) |
| `zypper` | Zypper (openSUSE) |
| `apk` | APK (Alpine) |
| `flatpak` | Flatpak |
| `snap` | Snap |
| `fwupd` | Firmware |
| `snapshot` | Timeshift/Snapper |

### Test Ederken

```bash
# Tüm modları test et
sudo ./guncel --verbose
sudo ./guncel --quiet
sudo ./guncel --dry-run
sudo ./guncel --skip flatpak,snap
sudo ./guncel --only system
sudo ./guncel --only pacman    # Arch Linux
sudo ./guncel --only apk       # Alpine Linux
```

---

## İletişim

Sorularınız için issue açabilir veya PR'da yorum bırakabilirsiniz.

- **GitHub Issues:** [bigfive-updater/issues](https://github.com/CalmKernelTR/bigfive-updater/issues)
- **Email:** ahmet@tanrikulu.net
