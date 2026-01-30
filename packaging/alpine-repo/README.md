# BigFive Updater - Alpine Linux Repository

Bu dizin, BigFive Updater için Alpine Linux paket reposunu yönetir.

## Kullanıcılar İçin Kurulum

### 1. Public Key'i İndir ve Kur

```bash
# Public key'i indir
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# Alternatif: curl ile
sudo curl -o /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub
```

### 2. Repo'yu Ekle

```bash
# Repo URL'ini ekle
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | \
    sudo tee -a /etc/apk/repositories
```

### 3. Paketi Kur

```bash
# Index'i güncelle ve kur
sudo apk update
sudo apk add bigfive-updater

# Opsiyonel: Shell completion
sudo apk add bigfive-updater-bash-completion
sudo apk add bigfive-updater-zsh-completion
sudo apk add bigfive-updater-fish-completion
```

## Desteklenen Alpine Versiyonları

| Versiyon | Durum |
|----------|-------|
| Alpine 3.20 | ✅ Destekleniyor |
| Alpine 3.19 | ✅ Destekleniyor |
| Alpine Edge | ✅ Destekleniyor |

## Paket Listesi

| Paket | Açıklama |
|-------|----------|
| `bigfive-updater` | Ana paket |
| `bigfive-updater-doc` | Man sayfaları ve dokümantasyon |
| `bigfive-updater-bash-completion` | Bash tamamlama |
| `bigfive-updater-zsh-completion` | Zsh tamamlama |
| `bigfive-updater-fish-completion` | Fish tamamlama |

---

## Maintainer Notları

### Signing Key Oluşturma (İlk kurulum)

```bash
# Key oluştur
abuild-keygen -a -n -i

# Dosyalar:
# ~/.abuild/bigfive@ahm3t0t.rsa       (private - GitHub Secret'a ekle)
# ~/.abuild/bigfive@ahm3t0t.rsa.pub   (public - repo'ya ekle)
```

### GitHub Secret Ekleme

1. Repo Settings → Secrets and variables → Actions
2. "New repository secret" tıkla
3. Name: `ALPINE_PRIVATE_KEY`
4. Value: Private key içeriği (cat ~/.abuild/*.rsa)

### Manuel Build

```bash
cd packaging/alpine
abuild checksum
abuild -r
```
