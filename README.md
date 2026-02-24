# BigFive Updater

**One command. All distros. Zero nonsense.**

[![CI](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml/badge.svg)](https://github.com/CalmKernelTR/bigfive-updater/actions/workflows/ci.yml)
[![Version](https://img.shields.io/github/v/release/CalmKernelTR/bigfive-updater?sort=semver&label=Version)](https://github.com/CalmKernelTR/bigfive-updater/releases)
[![License: MIT](https://img.shields.io/github/license/CalmKernelTR/bigfive-updater)](LICENSE)

---

You run Fedora on your desktop, Ubuntu on your server, Arch on your side project, and Alpine in your containers. Updating them means remembering `dnf`, `apt`, `pacman`, `zypper`, `apk` — and their flags, quirks, and gotchas.

**BigFive Updater** gives you one command that works everywhere: `guncel`.

It detects your distro, picks the right package manager, runs the update with sane defaults, logs everything, and gets out of your way. Pure Bash. No dependencies. No magic.

---

## Supported Distros

| | Distro Family | Package Manager |
|---|---|---|
| 🎩 | Fedora, RHEL, CentOS, Rocky, Alma | `dnf` / `yum` |
| 🐧 | Ubuntu, Debian, Linux Mint, Pop!_OS, Zorin | `apt` |
| 🏗️ | Arch, Manjaro, EndeavourOS, CachyOS | `pacman` |
| 🦎 | openSUSE Leap, Tumbleweed, GeckoLinux | `zypper` |
| 🏔️ | Alpine Linux | `apk` |

---

## Install

```bash
# Universal (all distros)
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash

# Arch Linux (AUR)
yay -S bigfive-updater

# Alpine Linux — see full docs for repo setup
apk add bigfive-updater
```

## Use

```bash
guncel                # Interactive update — just run it
guncel --auto         # Non-interactive, perfect for cron
guncel --dry-run      # See what would happen, change nothing
guncel --doctor       # System health check
guncel --history      # Review past updates
guncel --verbose      # Show every detail
guncel --quiet        # Minimal output
guncel --lang en      # English output (default: Turkish)
```

Three aliases, same tool: `guncel`, `updater`, `bigfive`.

---

## Why not just `apt upgrade`?

You already know your package manager. BigFive doesn't replace it — it wraps it with things you'd build yourself if you had the time:

- **Distro detection** — one command across all your machines, no muscle memory switching
- **Logging** — every update logged with timestamps, searchable with `--history`
- **Health checks** — `--doctor` catches common issues before they bite (stale repos, broken deps, disk space)
- **Dry run** — preview changes before committing, especially on production
- **i18n** — Turkish and English, runtime switchable
- **Cron-friendly** — `--auto --quiet` for unattended servers, with logrotate included
- **Shell completions** — Bash, Zsh, Fish

If you only run one distro on one machine, your native package manager is fine. BigFive shines when you manage multiple distros or want guardrails around your updates.

---

## Documentation

| | Language | README | Roadmap | Changelog |
|---|---|---|---|---|
| 🇹🇷 | Türkçe | [README.tr.md](README.tr.md) | [ROADMAP.tr.md](ROADMAP.tr.md) | [CHANGELOG.tr.md](CHANGELOG.tr.md) |
| 🇬🇧 | English | [README.en.md](README.en.md) | [ROADMAP.en.md](ROADMAP.en.md) | [CHANGELOG.en.md](CHANGELOG.en.md) |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) · [Code of Conduct](CODE_OF_CONDUCT.md) · [Security Policy](SECURITY.md)

---

## License

MIT — use it, fork it, improve it.

---

<p align="center">
  <i>Built by <a href="https://calmkernel.tr">CalmKernel</a> — tembel ama takıntılı adminin en yakın dostu.</i>
</p>
