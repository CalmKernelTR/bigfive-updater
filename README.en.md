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
wget -qO /etc/apk/keys/bigfive-updater.rsa.pub \
  https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/bigfive-updater.rsa.pub

# Add the repository
echo "https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/" >> /etc/apk/repositories

# Install
apk add bigfive-updater
```

### Fedora (COPR)

```bash
dnf copr enable calmkernel/bigfive-updater
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

### Options

```bash
guncel --quiet          # Minimal output (good for scripts)
guncel --lang en        # Switch output language to English
guncel --lang tr        # Switch output language to Turkish (default)
guncel --json           # JSON output for monitoring (Zabbix, Nagios, Prometheus)
guncel --json-full      # Detailed JSON for SIEM/audit (Wazuh, Splunk, ELK)
guncel --skip flatpak   # Skip specific backends
guncel --only system    # Run only specific backends
guncel --security-only  # Apply security updates only (v6.4.0+)
guncel --jitter 300     # Random delay for cron jobs (v6.3.0+)
guncel --help           # Show all available options
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
| `install.sh` | Night-Vx.x.x (e.g., Night-V1.4.3) | The installer, versioned independently |

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
