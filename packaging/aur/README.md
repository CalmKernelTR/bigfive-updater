# AUR Package: bigfive-updater

Arch User Repository package for BigFive Updater.

## Installation (After AUR Submission)

```bash
# With yay
yay -S bigfive-updater

# With paru
paru -S bigfive-updater

# Manual
git clone https://aur.archlinux.org/bigfive-updater.git
cd bigfive-updater
makepkg -si
```

## Package Contents

| File | Location |
|------|----------|
| guncel | `/usr/bin/guncel` |
| updater | `/usr/bin/updater` → guncel |
| bigfive | `/usr/bin/bigfive` → guncel |
| Lang TR | `/usr/share/bigfive-updater/lang/tr.sh` |
| Lang EN | `/usr/share/bigfive-updater/lang/en.sh` |
| Man page | `/usr/share/man/man8/guncel.8` |
| Man page TR | `/usr/share/man/tr/man8/guncel.8` |
| Bash completion | `/usr/share/bash-completion/completions/guncel` |
| Zsh completion | `/usr/share/zsh/site-functions/_guncel` |
| Fish completion | `/usr/share/fish/vendor_completions.d/guncel.fish` |
| Config example | `/etc/bigfive-updater.conf.example` |

## Maintainer Tasks

### Update Package for New Release

1. Update `pkgver` in PKGBUILD
2. Download new tarball and calculate sha256:
   ```bash
   curl -sL https://github.com/CalmKernelTR/bigfive-updater/archive/vX.Y.Z.tar.gz | sha256sum
   ```
3. Update `sha256sums` in PKGBUILD
4. Regenerate .SRCINFO:
   ```bash
   makepkg --printsrcinfo > .SRCINFO
   ```
5. Commit and push to AUR

### Testing PKGBUILD

```bash
# In Arch Linux or container
makepkg -sf
namcap PKGBUILD
namcap bigfive-updater-*.pkg.tar.zst
```

## AUR Submission

1. Create AUR account: https://aur.archlinux.org/register
2. Add SSH key to AUR account
3. Clone AUR package base:
   ```bash
   git clone ssh://aur@aur.archlinux.org/bigfive-updater.git
   ```
4. Copy PKGBUILD and .SRCINFO
5. Commit and push

## Links

- [AUR Package](https://aur.archlinux.org/packages/bigfive-updater) (after submission)
- [GitHub Repository](https://github.com/CalmKernelTR/bigfive-updater)
- [PKGBUILD Guidelines](https://wiki.archlinux.org/title/PKGBUILD)
