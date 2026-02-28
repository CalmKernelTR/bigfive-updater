# Skill: Multi-Distro Testing

> Docker container'larda 5 dağıtım test matrisi çalıştırma ve hata çözümleme

---

## Ön Koşullar

- Docker kurulu ve çalışıyor olmalı
- İnternet bağlantısı (container image pull için)
- `tests/docker/base/` altında Dockerfile'lar mevcut

---

## Desteklenen Dağıtımlar

| Distro | Base Image | Paket Yöneticisi | CI Container |
|--------|-----------|------------------|--------------|
| Ubuntu 24.04 | `ubuntu:24.04` | APT | `ghcr.io/ahm3t0t/bigfive-base-ubuntu:latest` |
| Fedora 40 | `fedora:40` | DNF | `ghcr.io/ahm3t0t/bigfive-base-fedora:latest` |
| Arch Linux | `archlinux:latest` | Pacman | `ghcr.io/ahm3t0t/bigfive-base-arch:latest` |
| openSUSE Leap 15.6 | `opensuse/leap:15.6` | Zypper | `ghcr.io/ahm3t0t/bigfive-base-opensuse:latest` |
| Alpine 3.20 | `alpine:3.20` | APK | `ghcr.io/ahm3t0t/bigfive-base-alpine:latest` |

---

## Adım 1: Lokal Docker Test (Tek Distro)

### Ubuntu/Debian
```bash
docker run --rm -v "$(pwd):/src" ubuntu:24.04 bash -c '
  apt-get update && apt-get install -y curl bash sudo
  cp /src/guncel /usr/local/bin/guncel
  chmod +x /usr/local/bin/guncel
  mkdir -p /usr/local/share/bigfive-updater/lang
  cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
  guncel --help
  guncel --doctor
  guncel --dry-run --auto
  guncel --json --dry-run --auto
  guncel --history
'
```

### Fedora
```bash
docker run --rm -v "$(pwd):/src" fedora:40 bash -c '
  dnf install -y curl bash sudo
  cp /src/guncel /usr/local/bin/guncel
  chmod +x /usr/local/bin/guncel
  mkdir -p /usr/local/share/bigfive-updater/lang
  cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
  guncel --help
  guncel --doctor
  guncel --dry-run --auto
'
```

### Arch Linux
```bash
docker run --rm -v "$(pwd):/src" archlinux:latest bash -c '
  pacman -Sy --noconfirm curl bash sudo
  cp /src/guncel /usr/local/bin/guncel
  chmod +x /usr/local/bin/guncel
  mkdir -p /usr/local/share/bigfive-updater/lang
  cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
  guncel --help
  guncel --doctor
  guncel --dry-run --auto
'
```

### openSUSE
```bash
docker run --rm -v "$(pwd):/src" opensuse/leap:15.6 bash -c '
  zypper -n install curl bash sudo
  cp /src/guncel /usr/local/bin/guncel
  chmod +x /usr/local/bin/guncel
  mkdir -p /usr/local/share/bigfive-updater/lang
  cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
  guncel --help
  guncel --doctor
  guncel --dry-run --auto
'
```

### Alpine
```bash
docker run --rm -v "$(pwd):/src" alpine:3.20 sh -c '
  apk add --no-cache bash curl sudo coreutils
  cp /src/guncel /usr/local/bin/guncel
  chmod +x /usr/local/bin/guncel
  mkdir -p /usr/local/share/bigfive-updater/lang
  cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
  guncel --help
  guncel --doctor
  guncel --dry-run --auto
'
```

---

## Adım 2: Tüm Distrolarda Test (Script)

Aşağıdaki komutları sırayla çalıştırarak tüm dağıtımları test et:

```bash
DISTROS=("ubuntu:24.04" "fedora:40" "archlinux:latest" "opensuse/leap:15.6" "alpine:3.20")
INSTALL_CMD=("apt-get update && apt-get install -y curl bash sudo" \
             "dnf install -y curl bash sudo" \
             "pacman -Sy --noconfirm curl bash sudo" \
             "zypper -n install curl bash sudo" \
             "apk add --no-cache bash curl sudo coreutils")

for i in "${!DISTROS[@]}"; do
  echo "=== Testing ${DISTROS[$i]} ==="
  docker run --rm -v "$(pwd):/src" "${DISTROS[$i]}" bash -c "
    ${INSTALL_CMD[$i]}
    cp /src/guncel /usr/local/bin/guncel
    chmod +x /usr/local/bin/guncel
    mkdir -p /usr/local/share/bigfive-updater/lang
    cp /src/lang/*.sh /usr/local/share/bigfive-updater/lang/
    echo '--- --help ---'
    guncel --help
    echo '--- --doctor ---'
    guncel --doctor
    echo '--- --dry-run ---'
    guncel --dry-run --auto
  "
  echo ""
done
```

---

## Adım 3: install.sh Test

Her distro'da kurulum scriptini test et:

```bash
docker run --rm -v "$(pwd):/src" ubuntu:24.04 bash -c '
  apt-get update && apt-get install -y curl bash sudo gpg
  bash /src/install.sh --local
  guncel --help
  guncel --uninstall --purge
'
```

`install.sh --local` parametresi: GitHub'dan indirmek yerine yerel dosyaları kullanır.

---

## Adım 4: CI Pipeline (GitHub Actions)

CI'da `ci.yml` workflow'u otomatik olarak 5 distro test çalıştırır:

```yaml
strategy:
  fail-fast: false
  matrix:
    include:
      - distro: ubuntu
        image: ghcr.io/ahm3t0t/bigfive-base-ubuntu:latest
      - distro: fedora
        image: ghcr.io/ahm3t0t/bigfive-base-fedora:latest
      - distro: arch
        image: ghcr.io/ahm3t0t/bigfive-base-arch:latest
      - distro: opensuse
        image: ghcr.io/ahm3t0t/bigfive-base-opensuse:latest
      - distro: alpine
        image: ghcr.io/ahm3t0t/bigfive-base-alpine:latest
```

---

## Yaygın Hatalar ve Çözümleri

### 1. Alpine'da `grep -P` hatası
```
grep: unrecognized option: P
```
**Çözüm:** `grep -P` yerine `grep -E` veya `grep -oE` kullan. Alpine'da GNU grep yerine BusyBox grep gelir.

### 2. Fedora'da DNF kilidi
```
Error: Could not open lock file /var/cache/dnf/metadata_lock.pid
```
**Çözüm:** Container'da genellikle sorun olmaz. Host'ta `sudo rm /var/cache/dnf/metadata_lock.pid` veya bekleme.

### 3. Arch'da keyring hatası
```
error: required key missing from keyring
```
**Çözüm:** `pacman-key --init && pacman-key --populate archlinux` çalıştır.

### 4. openSUSE'de GPG import hatası
```
Warning: Digest verification failed
```
**Çözüm:** `zypper --gpg-auto-import-keys refresh` çalıştır.

### 5. Container'da flock çalışmıyor
```
flock: open lock file failed
```
**Çözüm:** `guncel` container ortamını tespit eder ve uyarı verir. `--skip system` ile test edilebilir.

### 6. CI'da "DOCS-ONLY CHANGE" mesajı
CI, sadece `*.md`, `docs/`, `LICENSE` gibi dosyalar değiştiyse testleri atlar. Kod değişikliği yoksa bu beklenen davranıştır.

---

## Base Image Güncelleme

Docker base image'ler `docker-base-images.yml` workflow'u ile güncellenir:

```bash
# tests/docker/base/ altındaki Dockerfile'lar değişince
# otomatik olarak GHCR'a push edilir
# Manuel tetikleme: Actions → Docker Base Images → Run workflow
```
