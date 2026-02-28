# Skill: Paket Build ve Doğrulama

> AUR, Alpine APK ve RPM paket build süreçleri ve doğrulama adımları

---

## Ön Koşullar

- Docker kurulu olmalı (container build'leri için)
- İnternet bağlantısı (tarball indirme ve registry erişimi)
- Paketleme dosyaları `packaging/` dizininde mevcut

---

## Paket Dizin Yapısı

```
packaging/
├── aur/
│   └── PKGBUILD              # Arch Linux AUR paketi
├── alpine/
│   └── APKBUILD              # Alpine Linux paketi
├── alpine-repo/
│   └── bigfive@ahm3t0t.rsa.pub  # Alpine repo public key
└── rpm/
    └── bigfive-updater.spec   # Fedora/RHEL RPM spec
```

---

## 1. AUR Paket Build (Arch Linux)

### Lokal Build (Docker ile)

```bash
docker run --rm -v "$(pwd):/src" archlinux:latest bash -c '
  pacman -Syu --noconfirm base-devel git pacman-contrib
  useradd -m builder
  echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

  # PKGBUILD kopyala
  mkdir -p /tmp/build
  cp /src/packaging/aur/PKGBUILD /tmp/build/
  cd /tmp/build

  # Build
  chown -R builder:builder .
  su builder -c "makepkg -sf --noconfirm"

  echo "=== Oluşan paketler ==="
  ls -la *.pkg.tar.zst
'
```

### PKGBUILD Güncelleme

Versiyon güncellerken:
```bash
cd packaging/aur

# 1. Versiyon değiştir
sed -i "s/^pkgver=.*/pkgver=6.5.1/" PKGBUILD

# 2. pkgrel sıfırla (yeni versiyon ise)
sed -i "s/^pkgrel=.*/pkgrel=1/" PKGBUILD

# 3. Checksum güncelle
# Docker ile:
docker run --rm -v "$(pwd):/pkg" archlinux:latest bash -c '
  pacman -Sy --noconfirm pacman-contrib
  useradd -m builder
  cd /pkg
  chown -R builder:builder .
  su builder -c "updpkgsums"
  su builder -c "makepkg --printsrcinfo > .SRCINFO"
'
```

### CI Otomasyonu
- `aur.yml` workflow: Release publish'te otomatik AUR push
- `packages.yml` workflow: Release publish'te paket build + release'e ekleme
- Gerekli secret: `AUR_SSH_KEY`

---

## 2. Alpine APK Build

### Lokal Build (Docker ile)

```bash
docker run --rm -v "$(pwd):/src" alpine:latest sh -c '
  apk add --no-cache alpine-sdk bash curl sudo

  # Build kullanıcısı oluştur
  adduser -D builder
  addgroup builder abuild
  echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  mkdir -p /var/cache/distfiles
  chown builder:abuild /var/cache/distfiles
  chmod 755 /var/cache/distfiles

  # APKBUILD kopyala
  mkdir -p /tmp/build
  cp /src/packaging/alpine/APKBUILD /tmp/build/
  cd /tmp/build

  # Signing key oluştur
  chown -R builder:builder .
  su builder -c "abuild-keygen -a -n"

  # Build
  su builder -c "abuild checksum"
  su builder -c "abuild -r"

  echo "=== Oluşan paketler ==="
  find /home/builder/packages -name "*.apk" -ls
'
```

### APKBUILD Güncelleme

```bash
cd packaging/alpine
sed -i "s/^pkgver=.*/pkgver=6.5.1/" APKBUILD
```

### Alpine Repo
- `alpine-repo.yml` workflow: APK build → APKINDEX → GitHub Pages'e deploy
- Signed repo: `ALPINE_PRIVATE_KEY` secret ile imzalanır
- Public key: `packaging/alpine-repo/bigfive@ahm3t0t.rsa.pub`

### Kullanıcı Kurulum
```bash
# Public key indir
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# Repo ekle
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | \
    sudo tee -a /etc/apk/repositories

# Kur
sudo apk update
sudo apk add bigfive-updater
```

---

## 3. RPM Build (Fedora COPR)

### Lokal Build (Docker ile)

```bash
docker run --rm -v "$(pwd):/src" fedora:latest bash -c '
  dnf install -y rpm-build rpmdevtools

  # RPM build ortamını hazırla
  rpmdev-setuptree
  cp /src/packaging/rpm/bigfive-updater.spec ~/rpmbuild/SPECS/

  # Kaynak tarball indir
  VERSION="6.5.1"
  cd ~/rpmbuild/SOURCES
  curl -sL "https://github.com/CalmKernelTR/bigfive-updater/archive/v${VERSION}.tar.gz" \
    -o "bigfive-updater-${VERSION}.tar.gz"

  # SRPM build
  rpmbuild -bs ~/rpmbuild/SPECS/bigfive-updater.spec

  echo "=== Oluşan SRPM ==="
  ls -la ~/rpmbuild/SRPMS/

  # RPM build (tam)
  rpmbuild -ba ~/rpmbuild/SPECS/bigfive-updater.spec

  echo "=== Oluşan RPM ==="
  ls -la ~/rpmbuild/RPMS/noarch/
'
```

### CI Otomasyonu
- `copr.yml` workflow: Release publish'te SRPM build → COPR upload
- Gerekli secret'lar: `COPR_LOGIN`, `COPR_TOKEN`
- COPR projesi: `tahmet/bigfive-updater`

---

## 4. Paket Doğrulama

### Build Sonrası Kontrol Listesi

Her paket build'den sonra şunları kontrol et:

#### Arch (AUR)
```bash
# Paket içeriğini kontrol et
tar -tf bigfive-updater-*.pkg.tar.zst | head -20

# Kurulum testi
pacman -U bigfive-updater-*.pkg.tar.zst --noconfirm
guncel --help
guncel --doctor
```

#### Alpine (APK)
```bash
# Paket içeriğini kontrol et
tar -tzf bigfive-updater-*.apk | head -20

# Kurulum testi
apk add --allow-untrusted bigfive-updater-*.apk
guncel --help
guncel --doctor
```

#### RPM
```bash
# Paket içeriğini kontrol et
rpm -qlp bigfive-updater-*.rpm

# Spec doğrulama
rpmlint ~/rpmbuild/SPECS/bigfive-updater.spec
```

### Beklenen Paket İçeriği

Her pakette şu dosyalar olmalı:
- `/usr/local/bin/guncel` (veya `/usr/bin/guncel`)
- `/usr/local/share/bigfive-updater/lang/tr.sh`
- `/usr/local/share/bigfive-updater/lang/en.sh`
- `/etc/bash_completion.d/guncel` veya `/usr/share/bash-completion/completions/guncel`
- `/usr/share/zsh/site-functions/_guncel`
- `/usr/share/fish/vendor_completions.d/guncel.fish`
- `/usr/share/man/man8/guncel.8.gz`
- `/etc/bigfive-updater.conf.example`
- `/etc/logrotate.d/bigfive-updater`

---

## 5. Release Akışı

Tam bir release için `release.sh` scripti kullanılır:

```bash
# Versiyon bump (major/minor/patch/pre)
./release.sh --bump patch

# Release akışı:
# 1. Versiyon numarasını günceller (guncel, lang/*.sh, install.sh, PKGBUILD, APKBUILD, spec)
# 2. CHANGELOG oluşturur
# 3. Git commit + signed tag
# 4. Tag push → release.yml tetiklenir
# 5. release.yml: GPG sign → SHA256SUMS → GitHub Release
# 6. packages.yml: AUR + Alpine build
# 7. aur.yml: AUR publish
# 8. alpine-repo.yml: Alpine repo deploy
# 9. copr.yml: COPR build
```

---

## Hata Ayıklama

### "source not found" hatası
Paket build sırasında dosya yolu değişiklikleri olabilir. `PKGBUILD`/`APKBUILD`/`spec` dosyasında `source` URL'sini kontrol et.

### Checksum uyumsuzluğu
Release tarball'ı değişmiş olabilir. `updpkgsums` (Arch) veya `abuild checksum` (Alpine) ile güncelle.

### COPR build başarısız
- Spec dosyasında `BuildRequires` kontrol et
- `mock` ile lokal build dene
- COPR log'larını kontrol et: `copr-cli build-monitor tahmet/bigfive-updater`
