# Contributing to ARCB Wider Updater

Thanks for considering a contribution!

---

## Table of Contents

- [Quick Rules](#-quick-rules)
- [Development Setup](#️-development-setup)
- [Code Style](#-code-style)
- [Commit Message Format](#-commit-message-format)
- [Version Management](#-version-management)
- [Creating Releases](#-creating-releases)
- [Test Scenarios](#-test-scenarios)
- [PR Process](#-pr-process)
- [Command Line Options](#-command-line-options)

---

## Quick Rules

- Keep it simple, readable, and safe
- Prefer POSIX-ish, portable shell where possible
- Never print secrets to logs
- Any new feature should degrade gracefully if tools are missing

---

## Development Setup

```bash
git clone git@github.com:ahm3t0t/arcb-wider-updater.git
cd arcb-wider-updater
chmod +x guncel install.sh release.sh
./guncel --help
```

### Required Tools

| Tool | Version | Purpose |
|------|---------|---------|
| `bash` | 4.0+ | Script execution |
| `shellcheck` | latest | Lint |
| `bats` | 1.10+ | Unit tests |
| `curl` or `wget` | - | Downloads |

### Recommended Tools

| Tool | Purpose |
|------|---------|
| `shfmt` | Bash formatter |
| `docker` | Multi-distro testing |
| `act` | Local GitHub Actions |
| `gh` | GitHub CLI |

---

## Code Style

### ShellCheck Rules

All code must pass ShellCheck:

```bash
shellcheck -x guncel install.sh release.sh
```

### Indentation

- Use **4 spaces** (not tabs)
- Consistent indentation for nested blocks

```bash
# Correct
if [[ "$condition" == "true" ]]; then
    echo "4 space indent"
    if [[ "$nested" == "true" ]]; then
        echo "8 space for nested"
    fi
fi

# Wrong
if [[ "$condition" == "true" ]]; then
  echo "2 space - wrong"
fi
```

### POSIX Compatibility

- Prefer `[ ]` over `[[ ]]` where possible
- Use `#!/usr/bin/env bash` when bash-specific features are needed
- Use `local` variables in functions

```bash
# Preferred
my_function() {
    local my_var="value"
    # ...
}

# When bash-specific is needed
if [[ "$string" =~ ^[0-9]+$ ]]; then
    # [[ ]] required for regex
fi
```

### Variable Naming

- Global variables: `UPPER_SNAKE_CASE`
- Local variables: `lower_snake_case`
- Functions: `lower_snake_case`

```bash
# Global
VERSION="5.2.0"
LOG_FILE="/var/log/app.log"

# Local (inside function)
my_function() {
    local temp_file
    local counter=0
}
```

---

## Commit Message Format

We use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
type(scope): description

[optional body]

[optional footer]
```

### Type Values

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Code style (no functional change) |
| `refactor` | Code refactoring |
| `test` | Adding/fixing tests |
| `chore` | Build, CI, dependency updates |

### Scope Values

| Scope | Description |
|-------|-------------|
| `apt` | APT package manager |
| `dnf` | DNF package manager |
| `pacman` | Pacman package manager (Arch) |
| `zypper` | Zypper package manager (openSUSE) |
| `apk` | APK package manager (Alpine) |
| `flatpak` | Flatpak updates |
| `snap` | Snap updates |
| `fwupd` | Firmware update |
| `install` | Installation script |
| `ci` | CI/CD workflow |
| `config` | Configuration files |
| `docs` | Documentation |
| `test` | Test files |

### Examples

```bash
# New feature
feat(apk): add Alpine Linux package manager support

# Bug fix
fix(pacman): resolve orphan package detection issue

# Documentation
docs(readme): update BigFive support information

# CI update
chore(ci): add Alpine to test matrix

# Refactoring
refactor(logging): consolidate print functions
```

---

## Version Management

This project uses **two separate version systems**:

### 1. Main Script (guncel) - SemVer

**Format:** `MAJOR.MINOR.PATCH` (e.g., 5.2.0)

| Segment | When to Increment |
|---------|-------------------|
| MAJOR | Breaking changes |
| MINOR | New features |
| PATCH | Bug fixes |

**Update Frequency:** Every feature or fix

```bash
# in guncel
VERSION="5.2.1"
EDITION="BigFive"
CODENAME="Alpine"
```

### 2. Installation Script (install.sh) - Night Version

**Format:** `Night-Vx.x.x` (e.g., Night-V1.3.2)

**Update Frequency:** Only when install logic changes

```bash
# in install.sh
# ARCB Updater Installer Night-V1.3.2
```

### Why Separate Systems?

| Reason | Description |
|--------|-------------|
| **Different Change Rates** | Main script updates often, installer rarely changes |
| **Independent Tracking** | Easier to track installer changes separately |

---

## Creating Releases

### Using release.sh

```bash
# Patch release (bug fix): 5.2.0 → 5.2.1
./release.sh patch

# Minor release (new feature): 5.2.0 → 5.3.0
./release.sh minor

# Major release (breaking change): 5.2.0 → 6.0.0
./release.sh major

# Manual version: → 5.2.5
./release.sh 5.2.5

# Auto-confirm (for CI)
./release.sh patch -y
```

### What does release.sh do?

1. Updates VERSION in guncel
2. Creates git commit
3. Creates git tag
4. Pushes to GitHub
5. GitHub Actions signs with GPG

### Version Update Checklist

- [ ] Update `VERSION` and `CODENAME` in `guncel`
- [ ] Add entry to `CHANGELOG.en.md` and `CHANGELOG.tr.md`
- [ ] Update `SHA256SUMS` (automatic - GitHub Actions)
- [ ] (If needed) Update `install.sh` version

---

## Test Scenarios

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
# Run all tests
bats tests/*.bats

# Verbose output
bats --tap tests/*.bats

# Only guncel tests
bats tests/guncel.bats

# Only install tests
bats tests/install.bats
```

### 4. Dry-Run Test

```bash
# Without root (should error)
./guncel --dry-run

# With root
sudo ./guncel --dry-run
```

### 5. Help Output Check

```bash
./guncel --help
# Should contain:
# - VERSION and CODENAME
# - All options (--auto, --verbose, --quiet, --dry-run, --skip, --only)
# - Examples
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

### Test Status

| Component | Tests | Status |
|-----------|-------|--------|
| guncel.bats | 60 | Pass |
| install.bats | 35 | Pass |
| **Total** | **138** | Pass |

---

## PR Process

### Branch Naming Convention

```
type/short-description
```

**Examples:**
- `feat/alpine-support`
- `fix/pacman-orphan-detection`
- `docs/bigfive-readme`
- `chore/ci-alpine-matrix`

### PR Creation Steps

1. **Fork & Clone**
   ```bash
   git clone git@github.com:YOUR_USERNAME/arcb-wider-updater.git
   cd arcb-wider-updater
   ```

2. **Create Feature Branch**
   ```bash
   git checkout -b feat/my-feature
   ```

3. **Make Changes & Test**
   ```bash
   # Code changes
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

5. **Open PR**
   - Base: `main`
   - Compare: `feat/my-feature`

### PR Review Checklist

- [ ] ShellCheck passes
- [ ] `bash -n` syntax check passes
- [ ] `bats tests/*.bats` tests pass
- [ ] `--help` output updated
- [ ] `--dry-run` works
- [ ] CHANGELOG updated if needed
- [ ] Commits follow convention

---

## Command Line Options

Script supports these flags:

| Flag | Description |
|------|-------------|
| `--auto` | Automatic mode - no prompts |
| `--verbose` | Verbose output |
| `--quiet` | Quiet mode - errors and summary only |
| `--dry-run` | Dry run - no changes made |
| `--skip <backend>` | Skip specified backends |
| `--only <backend>` | Run only specified backends |
| `--uninstall` | Uninstall the tool |
| `--uninstall --purge` | Remove with config/logs |
| `--help` | Help message |

### Backend Values

| Backend | Description |
|---------|-------------|
| `system` | All package managers |
| `apt` | APT (Debian/Ubuntu) |
| `dnf` | DNF (Fedora/RHEL) |
| `pacman` | Pacman (Arch) |
| `zypper` | Zypper (openSUSE) |
| `apk` | APK (Alpine) |
| `flatpak` | Flatpak |
| `snap` | Snap |
| `fwupd` | Firmware |
| `snapshot` | Timeshift/Snapper |

### When Testing

```bash
# Test all modes
sudo ./guncel --verbose
sudo ./guncel --quiet
sudo ./guncel --dry-run
sudo ./guncel --skip flatpak,snap
sudo ./guncel --only system
sudo ./guncel --only pacman    # Arch Linux
sudo ./guncel --only apk       # Alpine Linux
```

---

## Contact

For questions, open an issue or leave a comment on your PR.

- **GitHub Issues:** [arcb-wider-updater/issues](https://github.com/ahm3t0t/arcb-wider-updater/issues)
- **Email:** ahmet@tanrikulu.net
