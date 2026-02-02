% GUNCEL(8) BigFive Updater 6.1.0
% Ahmet T. <ahm3t0t@users.noreply.github.com>
% February 2026

# NAME

guncel - universal Linux system updater (BigFive Edition)

# SYNOPSIS

**guncel** [*OPTIONS*]

**updater** [*OPTIONS*]

**bigfive** [*OPTIONS*]

# DESCRIPTION

**BigFive Updater** (BigFive Edition) updates all package managers on your
Linux system with a single command. It supports five major package managers
(APT, DNF, Pacman, Zypper, APK) plus Flatpak, Snap, and firmware updates.

The tool automatically detects which package managers are available on your
system and runs the appropriate update commands. It creates timestamped logs,
supports dry-run mode, and can output JSON for integration with monitoring
systems.

# OPTIONS

**--auto**
:   Non-interactive mode for cron jobs and automated tasks. Updates proceed
    without user confirmation.

**--verbose**
:   Show detailed output including all package manager commands and their
    full output.

**--quiet**
:   Minimal output mode. Only shows errors and final summary.

**--dry-run**
:   Show what would be updated without making any changes. Useful for
    previewing updates before applying them.

**--json**
:   Output lightweight JSON suitable for monitoring systems (Zabbix, Nagios,
    Prometheus). Includes status, exit code, timestamp, and update count.

**--json-full**
:   Output detailed JSON for SIEM and audit systems (Wazuh, Splunk, ELK).
    Includes system info, package details, warnings, and errors.

**--skip** *backends*
:   Skip specified backends (comma-separated). Available values:
    snapshot, flatpak, snap, fwupd, system, apt, dnf, pacman, zypper, apk

**--only** *backends*
:   Run only specified backends (comma-separated). Available values:
    system, flatpak, snap, fwupd, apt, dnf, pacman, zypper, apk

**--uninstall**
:   Remove BigFive Updater from the system. Configuration and logs are
    preserved.

**--uninstall --purge**
:   Completely remove BigFive Updater including configuration files and
    logs.

**--lang** *code*
:   Set output language. Available values: tr (Turkish), en (English).
    Default is auto-detected from system LANG.

**--doctor**
:   Run system health check. Verifies configuration file, required and
    optional commands, disk space, internet connectivity, and language
    files. Useful for troubleshooting issues before running updates.

**--history** *[N]*
:   Show update history for the last N days (default: 7). Displays date,
    time, status, and details of each update run from the log directory.

**--help**
:   Display help message and exit.

# SUPPORTED PACKAGE MANAGERS

**APT** (Debian, Ubuntu, Linux Mint, Pop!_OS, Zorin OS)
:   Runs apt update, apt dist-upgrade, apt autoremove, apt autoclean

**DNF** (Fedora, RHEL, CentOS, Rocky Linux, AlmaLinux)
:   Runs dnf upgrade with automatic orphan cleanup

**Pacman** (Arch Linux, Manjaro, EndeavourOS)
:   Runs pacman -Syu with orphan package cleanup and cache management

**Zypper** (openSUSE Leap, openSUSE Tumbleweed)
:   Runs zypper refresh and zypper update

**APK** (Alpine Linux)
:   Runs apk update and apk upgrade with cache cleanup

**Flatpak**
:   Updates all Flatpak applications and removes unused runtimes

**Snap**
:   Refreshes all Snap packages

**Firmware** (fwupd)
:   Checks and applies firmware updates for supported hardware

# FILES

*/etc/bigfive-updater.conf*
:   Main configuration file. Set default options here.

*/var/log/bigfive-updater/*
:   Log directory. Each update creates a timestamped log file.

*/usr/local/bin/guncel*
:   Main executable script.

*/usr/local/bin/updater*
:   Symlink to guncel (English alias).

*/usr/local/bin/bigfive*
:   Symlink to guncel (brand alias).

*/usr/share/bash-completion/completions/guncel*
:   Bash completion script.

*/usr/share/zsh/site-functions/_guncel*
:   Zsh completion script.

*/usr/share/fish/vendor_completions.d/guncel.fish*
:   Fish completion script.

*/usr/share/bigfive-updater/lang/*
:   Language files directory (tr.sh, en.sh).

# EXAMPLES

Run interactive update (recommended):

    sudo guncel

Run automated update for cron:

    sudo guncel --auto

Preview what would be updated:

    sudo guncel --dry-run

Update only system packages (skip Flatpak/Snap):

    sudo guncel --only system

Skip firmware updates:

    sudo guncel --skip fwupd

Output JSON for monitoring:

    sudo guncel --json

Run system health check:

    guncel --doctor

Show last 14 days of update history:

    guncel --history 14

# EXIT STATUS

**0**
:   Success - all updates completed without errors.

**1**
:   General error - one or more update operations failed.

**130**
:   Interrupted by user (Ctrl+C).

# CONFIGURATION

Configuration file format (*/etc/bigfive-updater.conf*):

    # Enable automatic mode by default
    CONFIG_AUTO_MODE=true

    # Skip specific backends
    CONFIG_SKIP_FLATPAK=true
    CONFIG_SKIP_SNAP=true

    # Enable verbose output
    CONFIG_VERBOSE=true

    # Snapshot timeout (seconds)
    CONFIG_SNAPSHOT_TIMEOUT=300

# SEE ALSO

**apt**(8), **dnf**(8), **pacman**(8), **zypper**(8), **apk**(8),
**flatpak**(1), **snap**(8), **fwupdmgr**(1)

# BUGS

Report bugs at: https://github.com/CalmKernelTR/bigfive-updater/issues

# COPYRIGHT

Copyright (C) 2026 Ahmet T. Licensed under MIT License.

# AUTHOR

Written by Ahmet T. with contributions from Claude AI.

Project homepage: https://github.com/CalmKernelTR/bigfive-updater
