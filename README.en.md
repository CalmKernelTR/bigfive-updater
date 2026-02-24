# BigFive Updater — Full Documentation (English)

> **One command. All distros. Zero nonsense.**
>
> A smart, multi-distro update tool for Linux systems. Pure Bash. No dependencies. Works on Fedora, Ubuntu/Debian, Arch, openSUSE, and Alpine.

---

## What It Does

BigFive Updater detects your Linux distribution, selects the correct package manager, and runs system updates with sane defaults. It logs every operation, offers dry-run previews, performs health checks, and provides a consistent experience whether you're on a Fedora desktop or an Alpine container.

**It doesn't replace your package manager.** It wraps it with the guardrails and convenience you'd build yourself if you had the time.

### Key Features

- **Auto-detection** — recognizes 20+ distributions across 5 package manager families
- **Interactive and unattended modes** — `guncel` for hands-on, `guncel --auto` for cron jobs
- **Dry run** — `--dry-run` shows what would happen without touching anything
- **System doctor** — `--doctor` checks repo health, disk space, broken dependencies, stale locks
- **Update history** — `--history` lets you review past updates with timestamps
- **Logging with logrotate** — every update is logged, old logs are automatically rotated
- **i18n** — Turkish (default) and English, switchable at runtime with `--lang en`
- **Shell completions** — Bash, Zsh, and Fish
- **SHA256 verification** — release integrity verified with signed checksums
- **Three aliases** — `guncel`, `updater`, `bigfive` — pick the one you'll remember

---

## Supported Distributions

| Family | Distributions | Package Manager |
|---|---|---|
| **Red Hat** | Fedora, RHEL, CentOS Stream, Rocky Linux, AlmaLinux | `dnf` / `yum` |
| **Debian** | Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin OS, elementary OS | `apt` |
| **Arch** | Arch Linux, Manjaro, EndeavourOS, CachyOS, Garuda | `pacman` |
| **SUSE** | openSUSE Leap, openSUSE Tumbleweed, GeckoLinux | `zypper` |
| **Alpine** | Alpine Linux | `apk` |

---

## Installation

### Universal (All Distros)

```bash
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash
```

The install script detects your distro and places everything in the right locations. It installs:
- The main `guncel` script to `/usr/local/bin/`
- Shell completions for Bash, Zsh, Fish
- Logrotate configuration
- Example config file
- Man page (where applicable)

### Arch Linux (AUR)

```bash
yay -S bigfive-updater
# or
paru -S bigfive-updater
```

### Alpine Linux

```bash
# Import the signing key
sudo wget -O /etc/apk/keys/bigfive@ahm3t0t.rsa.pub \
  https://ahm3t0t.github.io/bigfive-updater/bigfive@ahm3t0t.rsa.pub

# Add the repository
echo "https://ahm3t0t.github.io/bigfive-updater/alpine/v3.20/main" | sudo tee -a /etc/apk/repositories

# Install
sudo apk update
sudo apk add bigfive-updater
```

### Fedora (COPR)

```bash
dnf copr enable tahmet/bigfive-updater
dnf install bigfive-updater
```

### Manual Installation

```bash
git clone https://github.com/CalmKernelTR/bigfive-updater.git
cd bigfive-updater
sudo bash install.sh
```

### Verify Installation

```bash
guncel --version
guncel --help
```

---

## Usage

### Basic

```bash
guncel              # Interactive mode — asks before proceeding
guncel --auto       # Non-interactive — runs everything, no prompts
guncel --dry-run    # Preview mode — shows what would change, touches nothing
```

### Diagnostics

```bash
guncel --doctor     # System health check: repos, disk, deps, locks
guncel --history    # Review past update logs
guncel --verbose    # Show full package manager output
```

#### `--doctor` Example Output

```
BigFive Doctor - System Health Check
══════════════════════════════════════════════════════

[1/9] Config file...        ✓ /etc/bigfive-updater.conf
[2/9] Required commands...  ✓ All present
[3/9] Optional commands...  - jq:✓ fwupd:✗ flatpak:✓ snap:✗
[4/9] Disk space...         ✓ 24830MB available (min: 500MB)
[5/9] Internet connectivity... ✓ GitHub reachable
[6/9] Language files...     ✓ 2 language files present
[7/9] File permissions...   ✓ All permissions correct
[8/9] GPG keyring...        ✓ GPG available, 1 keys
[9/9] Lock file...          ✓ No lock file (ready to run)

══════════════════════════════════════════════════════
✓ System healthy - BigFive ready to use
```

### Options

```bash
guncel --quiet      # Minimal output (good for scripts)
guncel --lang en    # Switch output language to English
guncel --lang tr    # Switch output language to Turkish (default)
guncel --help       # Show all available options
```

### Cron Example

```bash
# /etc/cron.d/bigfive-updater
0 3 * * 1 root /usr/local/bin/guncel --auto --quiet >> /var/log/bigfive-updater/cron.log 2>&1
```

---

## Configuration

BigFive Updater works out of the box with no configuration. For customization, copy the example config:

```bash
sudo cp /etc/bigfive-updater.conf.example /etc/bigfive-updater.conf
```

Options include:
- Default language
- Auto-update behavior
- Logging verbosity
- Pre/post update hooks
- Excluded packages

See the example config file for all options with comments.

---

## How It Works

1. Detects the running distribution via `/etc/os-release`
2. Maps the distro to the correct package manager family
3. Runs the appropriate update commands with sane flags
4. Captures output and logs it with timestamps
5. Reports success/failure with exit codes suitable for monitoring

No external dependencies. No Python. No Node.js. Just Bash and the tools already on your system.

---

## Version System

This project uses two separate version tracks:

| Component | Format | Description |
|---|---|---|
| `guncel` (main script) | SemVer (e.g., 6.5.1) | The tool itself |
| `install.sh` | SemVer (e.g., 2.0.1) | The installer, versioned independently |

---

## Who Is This For?

- **Desktop users** who want a single, memorable command for updates across distros
- **Sysadmins** managing heterogeneous Linux environments (mixed Fedora/Ubuntu/Alpine)
- **Homelabbers** with multiple machines or VMs running different distros
- **Anyone** who wants logging, health checks, and dry-run previews around their updates

## Who Is This NOT For?

- If you run one distro on one machine and your muscle memory is already wired for `apt upgrade`, you don't need this
- If you need orchestration across dozens of servers, use Ansible/Salt — BigFive is a local tool

---

## Troubleshooting

| Problem | Cause | Solution |
|---------|-------|----------|
| `Permission denied` | Not running as root | Run with `sudo guncel` or as root |
| `--auto` mode fails with "sudo NOPASSWD required" | Cron/CI environment has no interactive sudo | Add a `NOPASSWD` entry in `/etc/sudoers` for the guncel command, or run directly as root |
| Stale lock file (`Another instance running`) | Previous run crashed without cleanup | Remove `/var/lock/bigfive-updater.lock` manually |
| Language files not found | Incomplete install or manual copy | Reinstall, or check that files exist in `/usr/share/bigfive-updater/lang/` |
| No update history (`--history` shows nothing) | No previous runs, or log directory missing | Check that `/var/log/bigfive-updater/` exists and has `update_*.log` files |
| Shell completions not working | Completion files not installed or shell not reloaded | See [Shell Completion](#shell-completion) below; restart your shell after installing |

---

## Shell Completion

The installer copies completion files automatically. For manual installation:

| Shell | Source File | Install Path |
|-------|------------|--------------|
| **Bash** | `completions/guncel.bash` | `/usr/share/bash-completion/completions/guncel` |
| **Zsh** | `completions/_guncel` | `/usr/share/zsh/site-functions/_guncel` |
| **Fish** | `completions/guncel.fish` | `~/.config/fish/completions/guncel.fish` |

```bash
# Manual install example (Bash)
sudo cp completions/guncel.bash /usr/share/bash-completion/completions/guncel

# Manual install example (Zsh)
sudo cp completions/_guncel /usr/share/zsh/site-functions/_guncel

# Manual install example (Fish)
cp completions/guncel.fish ~/.config/fish/completions/guncel.fish
```

After copying, open a new shell session (or run `source ~/.bashrc`) for completions to take effect.

---

## Project Structure

```
bigfive-updater/
├── guncel                  # Main script
├── install.sh              # Installer
├── bigfive-updater.conf.example  # Config template
├── completions/            # Shell completions (bash, zsh, fish)
├── lang/                   # i18n string files
├── docs/                   # Additional documentation
├── tests/                  # Test suite (Docker-based multi-distro)
├── packaging/              # Distribution packaging (RPM spec, PKGBUILD, etc.)
├── logrotate.d/            # Logrotate config
└── .github/                # CI/CD workflows
```

---

## Contributing

We welcome contributions! See [CONTRIBUTING.en.md](CONTRIBUTING.en.md) for guidelines.

- [Code of Conduct](CODE_OF_CONDUCT.en.md)
- [Security Policy](SECURITY.en.md)
- [Roadmap](ROADMAP.en.md)
- [Changelog](CHANGELOG.en.md)

---

## License

[MIT](LICENSE) — use it, fork it, improve it.

---

<p align="center">
  <i>Built by <a href="https://calmkernel.tr">CalmKernel</a> — your lazy but obsessive admin's best friend.</i>
</p>
