# Alpine Package: bigfive-updater

Alpine Linux APKBUILD for BigFive Updater.

## Package Structure

| Subpackage | Contents |
|------------|----------|
| `bigfive-updater` | Main script, language files, config |
| `bigfive-updater-doc` | Man pages, README, CHANGELOG |
| `bigfive-updater-bash-completion` | Bash tab completion |
| `bigfive-updater-zsh-completion` | Zsh tab completion |
| `bigfive-updater-fish-completion` | Fish tab completion |

## Installation

```bash
# 1. Add public key (one-time)
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
    https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# 2. Add repository (one-time)
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | \
    sudo tee -a /etc/apk/repositories

# 3. Install
sudo apk update && sudo apk add bigfive-updater

# With all completions
sudo apk add bigfive-updater-doc bigfive-updater-bash-completion
```

## Building Locally

```bash
# Install Alpine SDK
apk add alpine-sdk sudo

# Create build user
adduser -D builder
addgroup builder abuild
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Generate signing key (first time only)
su builder -c "abuild-keygen -a -i -n"

# Build package
su builder -c "abuild -r"
```

## Package Contents

| File | Location |
|------|----------|
| guncel | `/usr/bin/guncel` |
| updater | `/usr/bin/updater` → guncel |
| bigfive | `/usr/bin/bigfive` → guncel |
| Lang TR | `/usr/share/bigfive-updater/lang/tr.sh` |
| Lang EN | `/usr/share/bigfive-updater/lang/en.sh` |
| Config | `/etc/bigfive-updater.conf.example` |

## Maintainer Tasks

### Update for New Release

1. Update `pkgver` in APKBUILD
2. Update `sha512sums`:
   ```bash
   abuild checksum
   ```
3. Build and test:
   ```bash
   abuild -r
   ```
4. Commit and push

### Testing in Docker

```bash
docker run --rm -v $(pwd):/pkg alpine:latest sh -c '
apk add alpine-sdk
adduser -D builder
addgroup builder abuild
cp -r /pkg /home/builder/build
chown -R builder:builder /home/builder/build
su builder -c "cd /home/builder/build && abuild-keygen -a -n && abuild -r"
'
```

## Links

- [GitHub Repository](https://github.com/ahm3t0t/bigfive-updater)
- [APKBUILD Reference](https://wiki.alpinelinux.org/wiki/APKBUILD_Reference)
- [Creating an Alpine Package](https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package)
