# AGENTS.md — BigFive Updater

> Bu dosya AI coding agent'ları (Devin, Cursor, Copilot Workspace vb.) için proje bağlamı sağlar.
> Dil: Türkçe | Versiyon: 6.5.1 Fluent Edition (India)

---

## 1. Proje Özeti

**BigFive Updater** (`guncel`), 5 farklı Linux dağıtımını tek komutla güncelleyen bir Bash aracıdır.

| Özellik | Detay |
|---------|-------|
| Ana script | `guncel` (2604 satır) |
| Komut aliasları | `guncel`, `updater`, `bigfive` |
| Versiyon | 6.5.1 Fluent Edition — Codename: India |
| Lisans | MIT |
| Dil | Bash (POSIX-uyumlu, `#!/usr/bin/env bash`) |
| Test | BATS (~160 test) + kcov coverage |
| CI | GitHub Actions (9 workflow) |
| Paketleme | AUR, Alpine APK, RPM (COPR), DEB |
| i18n | Türkçe (tr) + İngilizce (en) |

### Desteklenen Paket Yöneticileri

| Distro | Paket Yöneticisi | Fonksiyon |
|--------|------------------|-----------|
| Ubuntu/Debian | APT | `update_apt()` |
| Fedora/RHEL | DNF | `update_dnf()` |
| Arch/Manjaro | Pacman | `update_pacman()` |
| openSUSE | Zypper | `update_zypper()` |
| Alpine | APK | `update_apk()` |

### Ek Backend'ler

- **Flatpak** → `update_flatpak()`
- **Snap** → `update_snap()`
- **Firmware (fwupd)** → `update_firmware()`
- **Timeshift/Snapper** → `create_snapshot()`

---

## 2. Dizin Yapısı

```
bigfive-updater/
├── guncel                    # Ana script (2604 satır)
├── install.sh                # Kurulum scripti (Night-V1.4.3)
├── release.sh                # Release otomasyon scripti (Dev-V1.3.1)
├── lang/
│   ├── tr.sh                 # Türkçe dil dosyası (256 satır, MSG_ prefix)
│   └── en.sh                 # İngilizce dil dosyası (256 satır, MSG_ prefix)
├── tests/
│   ├── guncel.bats           # Ana test dosyası (~816 satır, ~160 test)
│   ├── install.bats          # Kurulum testleri
│   ├── test_helper.bash      # BATS test helper
│   └── docker/               # Docker test altyapısı
│       └── base/             # Distro Dockerfile'ları
├── completions/
│   ├── guncel.bash           # Bash completion
│   ├── _guncel               # Zsh completion
│   └── guncel.fish           # Fish completion
├── docs/
│   ├── guncel.8              # Man page (troff)
│   ├── guncel.8.md           # Man page (markdown)
│   └── guncel.8.tr           # Man page (Türkçe troff)
├── packaging/
│   ├── aur/                  # Arch Linux PKGBUILD
│   ├── alpine/               # Alpine APKBUILD
│   ├── alpine-repo/          # Alpine repo signing key
│   └── rpm/                  # Fedora RPM spec
├── logrotate.d/              # Log rotation config
├── bigfive-updater.conf.example  # Örnek config dosyası
├── pubkey.asc                # GPG public key
├── SHA256SUMS                # Checksum dosyası
├── SHA256SUMS.asc            # GPG imzalı checksum
├── codecov.yml               # Coverage config
├── CLAUDE.md                 # Minimal AI context (28 satır)
├── AGENTS.md                 # ← Bu dosya
└── .agents/skills/           # AI agent skill dosyaları
    ├── shell-lint-and-test/
    ├── multi-distro-testing/
    ├── i18n-sync/
    └── packaging-build/
```

---

## 3. Execution Flow (Ana Akış)

`guncel` scripti şu sırayla çalışır:

```
1.  Config yükleme          → load_config()
2.  i18n yükleme            → load_language()
3.  Argüman parse           → while [[ $# -gt 0 ]]
4.  Cron jitter             → apply_jitter()
5.  Root kontrolü           → check_root()
6.  flock kilidi            → exec 9> "$LOCK_FILE" && flock -n 9
7.  Logging başlat          → setup_logging()
8.  Disk alanı kontrolü     → check_disk_space(500)
9.  Container tespiti       → check_container_environment()
10. Bağlantı kontrolü       → check_connectivity()
11. Self-update             → check_self_update()
12. Sistem başlığı          → print_system_header()
13. Snapshot oluştur        → create_snapshot()
14. Pre-update hooks        → run_hooks("pre")
15. Güncellemeler           → perform_updates()
    ├── update_apt() || update_dnf() || update_pacman() || update_zypper() || update_apk()
    ├── update_flatpak()
    ├── update_snap()
    └── update_firmware()
16. Post-update hooks       → run_hooks("post")
17. Özet                    → print_final_summary()
18. Bildirim                → send_notification()
19. JSON çıktı              → output_json()
```

### Özel Modlar

| Bayrak | Davranış |
|--------|----------|
| `--dry-run` | `perform_dry_run_check()` — değişiklik yapmaz, sadece listeler |
| `--json` / `--json-full` | Terminal çıktısı bastırılır, sonuç JSON olarak döner |
| `--doctor` | `do_doctor()` — 9 adımlı sistem sağlık kontrolü |
| `--history [N]` | `do_history()` — son N günün log analizi |
| `--uninstall [--purge]` | `do_uninstall()` — kaldırma |
| `--security-only` | Sadece güvenlik güncellemeleri (DNF/Zypper native) |
| `--skip <backend>` | Belirtilen backend'leri atla |
| `--only <backend>` | Sadece belirtilen backend'leri çalıştır |
| `--jitter <sn>` | Cron rastgele gecikme (server farm load distribution) |

---

## 4. Fonksiyon Haritası

### Güvenlik Fonksiyonları
| Fonksiyon | Satır | Açıklama |
|-----------|-------|----------|
| `safe_source()` | ~39 | Güvenli dosya sourcing (ownership + world-writable kontrol) |
| `safe_mktemp()` | ~69 | Güvenli temp dosya oluşturma (TMPDIR manipülasyonuna karşı) |
| `verify_gpg_signature()` | ~780 | İzole GNUPGHOME ile GPG doğrulama |
| `check_self_update()` | ~1377 | SHA256 + GPG doğrulamalı self-update |

### Paket Yöneticisi Fonksiyonları
| Fonksiyon | Satır | Timeout |
|-----------|-------|---------|
| `update_apt()` | ~1644 | update: 10dk, upgrade: 30dk |
| `update_dnf()` | ~1698 | 30dk |
| `update_pacman()` | ~1766 | Sy: 10dk, Su: 30dk |
| `update_zypper()` | ~1839 | refresh: 10dk, update: 30dk |
| `update_apk()` | ~1900 | (bkz. script) |
| `update_flatpak()` | ~1960 | — |
| `update_snap()` | ~2018 | — |
| `update_firmware()` | ~2052 | — |

### Yardımcı Fonksiyonları
| Fonksiyon | Açıklama |
|-----------|----------|
| `sanitize_count()` | Sayaçları güvenli numerik değere dönüştürür |
| `run_with_logging()` | Verbose/non-verbose komut çalıştırma (timeout ile) |
| `run_logged()` | Verbose/non-verbose komut çalıştırma (timeout'suz) |
| `json_escape()` | JSON özel karakter escape |
| `output_json()` | `--json` ve `--json-full` çıktı üretimi |
| `should_run_backend()` | `--only` modu kontrolü |
| `wait_for_lock()` | APT lock bekleme |
| `wait_for_dnf_lock()` | DNF lock bekleme |
| `apply_jitter()` | Cron jitter (RANDOM % max) |
| `check_container_environment()` | Docker/Podman/LXC tespiti |
| `run_hooks()` | Pre/post hook runner |
| `send_notification()` | ntfy/gotify/webhook bildirim gönderme |

---

## 5. CI Pipeline (9 Workflow)

### PR / Push Workflow'ları

| Workflow | Dosya | Tetikleyici | Açıklama |
|----------|-------|-------------|----------|
| **CI** | `ci.yml` | push/PR → main | Ana pipeline: path-filter → lint → multi-distro (5) → BATS + kcov |
| **Tests** | `test.yml` | push/PR (paths-ignore: *.md, docs/) | Syntax check + BATS + multi-distro install test |
| **Security** | `security.yml` | push/PR + weekly cron | TruffleHog secret scanning |

### Release Workflow'ları

| Workflow | Dosya | Tetikleyici | Açıklama |
|----------|-------|-------------|----------|
| **Release** | `release.yml` | tag push (`v*`) | GPG sign → SHA256SUMS → GitHub Release oluştur |
| **Packages** | `packages.yml` | release published | Arch + Alpine paket build → release'e ekle |
| **AUR Publish** | `aur.yml` | release published | PKGBUILD güncelle → AUR'a push |
| **Alpine Repo** | `alpine-repo.yml` | release published | APK build → GitHub Pages'e deploy |
| **COPR Build** | `copr.yml` | release published | SRPM build → Fedora COPR'a upload |

### Altyapı Workflow'ları

| Workflow | Dosya | Tetikleyici | Açıklama |
|----------|-------|-------------|----------|
| **Docker Base** | `docker-base-images.yml` | tests/docker/base/ değişince | 5 distro base image build → GHCR push |

### CI Pipeline Detayları (ci.yml)

```
changes (path-filter)
  └── code changed?
       ├── YES → lint (ShellCheck + shfmt + bash -n + actionlint)
       │         ├── multi-distro (5 container: ubuntu, fedora, arch, opensuse, alpine)
       │         │   └── Her biri: setup → install → --help → --doctor → --history → --dry-run → --json → uninstall
       │         └── bats (BATS tests + kcov coverage → Codecov upload)
       └── NO  → "DOCS-ONLY CHANGE — CI SKIPPED"
```

---

## 6. Geliştirme Kuralları

### Kod Stili
- **Google Shell Style Guide** uyumlu
- **2-space indent** (`shfmt -i 2 -ci -sr`)
- **ShellCheck** warning seviyesinde lint (`shellcheck -S warning`)
- **Strict mode**: `set -Eeuo pipefail`
- Tüm printf çıktıları `$'\033[...]'` ANSI-C quoting kullanır

### Commit Conventions
- **Conventional Commits** (İngilizce): `feat:`, `fix:`, `docs:`, `ci:`, `test:`, `refactor:`, `chore:`
- GPG signed commit (`git commit -S`)
- GPG signed tag (`git tag -s`)
- `release.sh --check-commits` ile commit hygiene kontrolü

### Bash Syntax check (hızlı)
```bash
bash -n guncel && bash -n install.sh && bash -n release.sh
```

### ShellCheck + shfmt
```bash
shellcheck -S warning guncel install.sh release.sh
shfmt -d -i 2 -ci -sr guncel install.sh release.sh
```

### BATS Testleri
```bash
bats tests/guncel.bats tests/install.bats
```

### Değişiklik Yaparken Dikkat

1. **5 distro uyumluluğu zorunlu** — Her değişiklik APT, DNF, Pacman, Zypper ve APK ile çalışmalı
2. **POSIX uyumluluğu** — `grep -P` yerine `grep -E` tercih et (Alpine'da `grep -P` yok)
3. **Timeout'lar** — Ağ işlemleri mutlaka timeout ile sarılmalı
4. **SC2059 disable** — i18n printf format string'lerde değişken kullanımı gerekli, dosya başında disable
5. **Test ekle** — Yeni fonksiyon → `tests/guncel.bats`'a test ekle
6. **İki dil dosyası güncelle** — Yeni MSG_ → hem `lang/tr.sh` hem `lang/en.sh`

---

## 7. i18n Sistemi

### Mimari
- Dil dosyaları: `lang/tr.sh`, `lang/en.sh`
- Tüm kullanıcıya görünen stringler `MSG_` prefix'li değişkenler
- `load_language()` fonksiyonu dil dosyasını `safe_source()` ile yükler
- Öncelik sırası: `--lang` argümanı > `BIGFIVE_LANG` env var > sistem `LANG` > varsayılan `tr`

### MSG_ Kategorileri
| Prefix | Açıklama | Örnek |
|--------|----------|-------|
| `MSG_HEADER_*` | Bölüm başlıkları | `MSG_HEADER_APT_UPDATE` |
| `MSG_INFO_*` | Bilgi mesajları | `MSG_INFO_APT_COUNT` |
| `MSG_SUCCESS_*` | Başarı mesajları | `MSG_SUCCESS_SCRIPT_UPDATED` |
| `MSG_WARN_*` | Uyarılar | `MSG_WARN_GPG_MISSING` |
| `MSG_ERR_*` | Hatalar | `MSG_ERR_NO_INTERNET` |
| `MSG_HINT_*` | Çözüm önerileri | `MSG_HINT_NO_SUDO` |
| `MSG_HELP_*` | Yardım metinleri | `MSG_HELP_OPT_AUTO` |
| `MSG_DOCTOR_*` | Doctor kontrolleri | `MSG_DOCTOR_NET_OK` |
| `MSG_HISTORY_*` | History mesajları | `MSG_HISTORY_TITLE` |
| `MSG_SUMMARY_*` | Özet mesajları | `MSG_SUMMARY_REBOOT_YES` |
| `MSG_HOOK_*` | Hook mesajları | `MSG_HOOK_RUNNING` |

### Yeni Mesaj Ekleme Kuralı
```bash
# 1. guncel'de varsayılan ile kullan:
print_info "${MSG_INFO_YENI_MESAJ:-Varsayılan Türkçe metin}"

# 2. lang/tr.sh'e ekle:
MSG_INFO_YENI_MESAJ="Türkçe metin"

# 3. lang/en.sh'e ekle:
MSG_INFO_YENI_MESAJ="English text"
```

---

## 8. Güvenlik Modeli

### Temel Prensipler
- `set -Eeuo pipefail` — strict mode
- `umask 0077` — log ve temp dosyalar sadece root okusun
- `flock` — eşzamanlı çalışma engeli
- TLS 1.2+ zorunlu — `--proto '=https' --tlsv1.2` (curl), `--secure-protocol=TLSv1_2` (wget)

### Dosya Güvenliği
| Fonksiyon | Koruma |
|-----------|--------|
| `safe_source()` | World-writable kontrol + root ownership kontrol |
| `safe_mktemp()` | `/tmp` hardcoded (TMPDIR manipülasyonu engelenir) |
| `verify_gpg_signature()` | İzole `GNUPGHOME` (sistem keyring kirlenmez) |
| `run_hooks()` | World-writable hook'lar atlanır |

### Self-Update Güvenlik Zinciri
```
1. Yeni sürüm indir
2. "BigFive Updater" imza kontrolü (grep)
3. SHA256SUMS indir
4. SHA256SUMS.asc indir → GPG imza doğrula (izole keyring)
5. SHA256 checksum doğrula
6. Atomic replace: install → mv (kesintiye dayanıklı)
7. Başarısızlıkta .bak'tan rollback
```

### Dosya İzinleri
| Dosya/Dizin | İzin |
|-------------|------|
| `/usr/local/bin/guncel` | 755 veya 700 |
| `/etc/bigfive-updater.conf` | 644 veya 600 |
| `/var/log/bigfive-updater/` | 700 |
| Log dosyaları | 600 |

---

## 9. Paketleme

### AUR (Arch Linux)
- `packaging/aur/PKGBUILD`
- Otomatik publish: `aur.yml` workflow
- `makepkg -sf` ile build

### Alpine APK
- `packaging/alpine/APKBUILD`
- `alpine-repo.yml` → GitHub Pages'e deploy
- Signed repo: `bigfive@ahm3t0t.rsa` key

### RPM (Fedora COPR)
- `packaging/rpm/bigfive-updater.spec`
- `copr.yml` → COPR'a SRPM upload
- `copr-cli build tahmet/bigfive-updater`

### Genel Paket Build
- `packages.yml` → Arch + Alpine paket build → GitHub Release'e eklenir

---

## 10. Test Stratejisi

### BATS Testleri
- `tests/guncel.bats` — ~160 test (help, flags, functions, security, i18n, completions, man page)
- `tests/install.bats` — Kurulum scripti testleri
- `tests/test_helper.bash` — Ortak helper fonksiyonlar

### Test Kategorileri
| Kategori | Test Sayısı (yaklaşık) |
|----------|----------------------|
| --help output | ~5 |
| --dry-run mode | ~2 |
| --skip / --only flags | ~10 |
| Renk değişkenleri | ~6 |
| Kritik fonksiyonlar | ~10 |
| Script yapısı | ~5 |
| --uninstall | ~4 |
| TLS hardening | ~3 |
| PATH export | ~2 |
| Ağ fonksiyonları | ~3 |
| Güvenlik | ~3 |
| BigFive (5 distro) | ~15 |
| JSON output | ~10 |
| Completion dosyaları | ~20 |
| Man page | ~7 |
| i18n | ~20 |
| v6.x features | ~30+ |

### Coverage
- **kcov** ile coverage toplama
- **Codecov** entegrasyonu (`codecov.yml`)
- CI'da `--help`, `--version`, `--doctor`, `--dry-run`, `--history`, `--json --dry-run` ile coverage

### Multi-Distro Test Matrisi
5 container'da (Ubuntu 24.04, Fedora 40, Arch, openSUSE Leap 15.6, Alpine 3.20):
- `guncel --help`
- `guncel --doctor`
- `guncel --history`
- `guncel --dry-run`
- `guncel --json --dry-run`
- Uninstall temizlik

---

## 11. Yapılandırma

### Config Dosyası
- Yol: `/etc/bigfive-updater.conf`
- Örnek: `bigfive-updater.conf.example`
- `load_config()` ile `safe_source()` kullanarak yüklenir
- Argümanlar config'i override eder

### Ortam Değişkenleri
| Değişken | Açıklama |
|----------|----------|
| `BIGFIVE_LANG` | Dil override (tr/en) |
| `BIGFIVE_JITTER` | Cron jitter (saniye) |
| `BIGFIVE_NOTIFY_URL` | Bildirim URL'si (ntfy/gotify/webhook) |
| `BIGFIVE_NOTIFY_SUCCESS` | Başarı bildirimi (true/false) |
| `BIGFIVE_NOTIFY_ERROR` | Hata bildirimi (true/false) |
| `BIGFIVE_REEXEC` | Self-update sonrası re-exec flag |

### Hooks
- Dizin: `/etc/bigfive-updater.d/{pre,post}.d/`
- Executable dosyalar sırayla çalıştırılır
- World-writable hook'lar güvenlik nedeniyle atlanır

---

## 12. Hızlı Başlangıç (Agent İçin)

### Kodu anlamak için:
```bash
# Fonksiyon listesi
grep -n '^[a-z_]*()' guncel | head -40

# MSG_ değişkenleri (i18n)
grep -c '^MSG_' lang/tr.sh   # → ~120 mesaj

# Test sayısı
grep -c '@test' tests/guncel.bats tests/install.bats

# CI workflow'ları
ls .github/workflows/
```

### Değişiklik yapmadan önce:
```bash
# 1. Syntax kontrolü
bash -n guncel

# 2. ShellCheck
shellcheck -S warning guncel

# 3. shfmt (stil kontrolü)
shfmt -d -i 2 -ci -sr guncel

# 4. BATS testleri
bats tests/guncel.bats tests/install.bats
```

### Yeni özellik eklerken:
1. `guncel`'e fonksiyon ekle
2. İlgili `MSG_` değişkenlerini her iki dil dosyasına ekle
3. `tests/guncel.bats`'a test ekle
4. `--help` çıktısına seçenek ekle
5. Completion dosyalarını güncelle (bash, zsh, fish)
6. Man page'i güncelle (`docs/guncel.8`, `docs/guncel.8.md`, `docs/guncel.8.tr`)
7. Conventional Commit mesajı ile commit at
