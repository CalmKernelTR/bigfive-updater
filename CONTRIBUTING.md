# Contributing to ARCB Wider Updater

Teşekkürler! Katkıda bulunmayı düşündüğün için ❤️

Thanks for considering a contribution! ❤️

---

## 📋 İçindekiler / Table of Contents

- [Hızlı Kurallar / Quick Rules](#-hızlı-kurallar--quick-rules)
- [Geliştirme Ortamı / Development Setup](#-geliştirme-ortamı--development-setup)
- [Kod Stili / Code Style](#-kod-stili--code-style)
- [Commit Mesaj Formatı / Commit Message Format](#-commit-mesaj-formatı--commit-message-format)
- [Sürüm Yönetimi / Version Management](#-sürüm-yönetimi--version-management)
- [Test Senaryoları / Test Scenarios](#-test-senaryoları--test-scenarios)
- [PR Süreci / PR Process](#-pr-süreci--pr-process)
- [Komut Satırı Seçenekleri / Command Line Options](#-komut-satırı-seçenekleri--command-line-options)

---

## 🚀 Hızlı Kurallar / Quick Rules

- Basit, okunabilir ve güvenli kod yaz / Keep it simple, readable, and safe
- Mümkün olduğunca POSIX uyumlu shell kullan / Prefer POSIX-ish, portable shell where possible
- Asla log'lara secret yazdırma / Never print secrets to logs
- Yeni özellikler, araç yoksa graceful degrade etmeli / Any new feature should degrade gracefully if tools are missing

---

## 🛠️ Geliştirme Ortamı / Development Setup

```bash
git clone git@github.com:ahm3t0t/arcb-wider-updater.git
cd arcb-wider-updater
chmod +x guncel install.sh
./guncel --help
```

### Gerekli Araçlar / Required Tools

- `bash` (4.0+)
- `shellcheck` (lint için / for linting)
- `curl` veya `wget`

---

## 📝 Kod Stili / Code Style

### ShellCheck Kuralları

Tüm kod ShellCheck'ten geçmeli:

```bash
shellcheck -x guncel install.sh
```

### Girintileme / Indentation

- **4 space** kullan (tab değil)
- Nested bloklar için tutarlı girintileme

```bash
# ✅ Doğru
if [[ "$condition" == "true" ]]; then
    echo "4 space indent"
    if [[ "$nested" == "true" ]]; then
        echo "8 space for nested"
    fi
fi

# ❌ Yanlış
if [[ "$condition" == "true" ]]; then
  echo "2 space - yanlış"
fi
```

### POSIX Uyumluluğu

- `[[ ]]` yerine `[ ]` tercih et (mümkünse)
- Bash-specific özellikler gerektiğinde `#!/usr/bin/env bash` kullan
- `local` değişkenler fonksiyonlarda kullanılmalı

```bash
# ✅ Tercih edilen
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
VERSION="3.8.1"
LOG_FILE="/var/log/app.log"

# Local (fonksiyon içinde)
my_function() {
    local temp_file
    local counter=0
}
```

---

## 💬 Commit Mesaj Formatı / Commit Message Format

[Conventional Commits](https://www.conventionalcommits.org/) formatını kullanıyoruz:

```
type(scope): description

[optional body]

[optional footer]
```

### Type Değerleri

| Type | Açıklama | Description |
|------|----------|-------------|
| `feat` | Yeni özellik | New feature |
| `fix` | Bug düzeltme | Bug fix |
| `docs` | Dokümantasyon | Documentation only |
| `style` | Kod formatı (işlevsel değişiklik yok) | Code style (no functional change) |
| `refactor` | Kod yeniden yapılandırma | Code refactoring |
| `test` | Test ekleme/düzeltme | Adding/fixing tests |
| `chore` | Build, CI, bağımlılık güncellemeleri | Build, CI, dependency updates |

### Scope Değerleri

| Scope | Açıklama |
|-------|----------|
| `fwupd` | Firmware güncelleme |
| `apt` | APT paket yöneticisi |
| `dnf` | DNF paket yöneticisi |
| `flatpak` | Flatpak güncellemeleri |
| `snap` | Snap güncellemeleri |
| `install` | Kurulum scripti |
| `ci` | CI/CD workflow |
| `config` | Yapılandırma dosyaları |

### Örnekler

```bash
# Yeni özellik
feat(fwupd): add exit code handling for no updatable devices

# Bug düzeltme
fix(apt): resolve lock file detection issue

# Dokümantasyon
docs(readme): split into TR/EN versions

# CI güncellemesi
chore(ci): add shellcheck workflow

# Refactoring
refactor(logging): consolidate print functions
```

---

## 📦 Sürüm Yönetimi / Version Management

Bu projede **iki ayrı versiyon sistemi** kullanılmaktadır:

### 1. Ana Script (guncel) - SemVer

**Format:** `MAJOR.MINOR.PATCH` (örn: 3.8.1)

| Segment | Ne Zaman Artırılır |
|---------|--------------------|
| MAJOR | Geriye uyumsuz API değişiklikleri |
| MINOR | Geriye uyumlu yeni özellikler |
| PATCH | Geriye uyumlu bug düzeltmeleri |

**Güncelleme Sıklığı:** Her özellik veya fix'te güncellenir.

```bash
# guncel içinde
VERSION="3.8.1"
CODENAME="Documented"
```

### 2. Kurulum Scripti (install.sh) - Night Version

**Format:** `Night-Vx.x.x` (örn: Night-V1.0.0)

**Güncelleme Sıklığı:** Sadece kurulum mantığı değiştiğinde güncellenir.

```bash
# install.sh içinde
# ARCB Updater Installer Night-V1.0.0
```

### Neden Ayrı Sistemler?

| Sebep | Açıklama |
|-------|----------|
| **Farklı Değişim Hızları** | Ana script sık güncellenir, installer nadiren değişir |
| **Bağımsız Takip** | Installer değişikliklerini ayrı izlemek daha kolay |
| **Kullanıcı Deneyimi** | Kullanıcılar hangi bileşenin güncellendiğini net görür |

### Versiyon Güncelleme Checklist

- [ ] `guncel` içinde `VERSION` ve `CODENAME` güncelle
- [ ] `CHANGELOG.md`'ye entry ekle
- [ ] `SHA256SUMS` dosyasını güncelle
- [ ] (Gerekirse) `install.sh` versiyonunu güncelle

---

## 🧪 Test Senaryoları / Test Scenarios

### 1. ShellCheck Lint

```bash
shellcheck -x guncel install.sh
```

### 2. Bash Syntax Check

```bash
bash -n guncel
bash -n install.sh
```

### 3. Dry-Run Testi

```bash
# Root olmadan (hata vermeli)
./guncel --dry-run

# Root ile
sudo ./guncel --dry-run
```

### 4. Help Çıktı Kontrolü

```bash
./guncel --help
# Çıktıda şunlar olmalı:
# - VERSION ve CODENAME
# - Tüm seçenekler (--auto, --verbose, --quiet, --dry-run, --skip, --only)
# - Örnekler
```

### 5. CI Workflow Testleri

GitHub Actions otomatik olarak şunları kontrol eder:
- ShellCheck lint
- Bash syntax validation
- Help output verification

---

## 🔄 PR Süreci / PR Process

### Branch Naming Convention

```
type/short-description
```

**Örnekler:**
- `feat/fwupd-exit-code`
- `fix/apt-lock-detection`
- `docs/readme-split`
- `chore/ci-shellcheck`

### PR Oluşturma Adımları

1. **Fork & Clone**
   ```bash
   git clone git@github.com:YOUR_USERNAME/arcb-wider-updater.git
   cd arcb-wider-updater
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
- [ ] `--help` çıktısı güncel
- [ ] `--dry-run` çalışıyor
- [ ] CHANGELOG.md güncellendi (gerekirse)
- [ ] Commit mesajları conventional format'ta

---

## 📋 Komut Satırı Seçenekleri / Command Line Options

Script şu flag'leri destekler:

| Flag | Açıklama | Description |
|------|----------|-------------|
| `--auto` | Otomatik mod - soru sormaz | Automatic mode - no prompts |
| `--verbose` | Detaylı çıktı | Verbose output |
| `--quiet` | Sessiz mod - sadece hata ve özet | Quiet mode - errors and summary only |
| `--dry-run` | Kuru çalıştırma - değişiklik yapmaz | Dry run - no changes made |
| `--skip <backend>` | Belirtilen backend'leri atla | Skip specified backends |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır | Run only specified backends |
| `--help` | Yardım mesajı | Help message |

### Test Ederken

```bash
# Tüm modları test et
sudo ./guncel --verbose
sudo ./guncel --quiet
sudo ./guncel --dry-run
sudo ./guncel --skip flatpak,snap
sudo ./guncel --only system
```

---

## 📞 İletişim / Contact

Sorularınız için issue açabilir veya PR'da yorum bırakabilirsiniz.

For questions, open an issue or leave a comment on your PR.
