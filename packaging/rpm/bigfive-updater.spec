Name:           bigfive-updater
Version:        6.4.0
Release:        1%{?dist}
Summary:        Multi-distro Linux system updater with security features
License:        MIT
URL:            https://github.com/CalmKernelTR/bigfive-updater
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  coreutils
Requires:       bash >= 4.0
Requires:       coreutils
Requires:       grep
Requires:       sed
Requires:       util-linux
Recommends:     curl
Recommends:     wget
Recommends:     gnupg2

%description
BigFive Updater is a comprehensive Linux system update tool that supports
multiple package managers (DNF, APT, Pacman, Zypper, APK) with advanced
features including:

- GPG signature verification for secure self-updates
- JSON output for monitoring integration (Zabbix, Nagios, Prometheus)
- Pre/post update hooks for custom automation
- Security-only update mode (--security-only)
- Notification system (ntfy, gotify, webhooks)
- Cron jitter for distributed update scheduling
- Container environment detection
- Comprehensive logging with logrotate integration

%prep
%autosetup -n %{name}-%{version}

%build
# Nothing to build - pure shell script

%install
# Main script
install -Dm755 guncel %{buildroot}%{_bindir}/guncel

# Symlinks
ln -s guncel %{buildroot}%{_bindir}/updater
ln -s guncel %{buildroot}%{_bindir}/bigfive

# Man page
install -Dm644 man/guncel.8 %{buildroot}%{_mandir}/man8/guncel.8

# Bash completion
install -Dm644 completions/guncel.bash %{buildroot}%{_datadir}/bash-completion/completions/guncel

# Zsh completion
install -Dm644 completions/_guncel %{buildroot}%{_datadir}/zsh/site-functions/_guncel

# Fish completion
install -Dm644 completions/guncel.fish %{buildroot}%{_datadir}/fish/vendor_completions.d/guncel.fish

# Language files
install -Dm644 lang/tr.sh %{buildroot}%{_datadir}/%{name}/lang/tr.sh
install -Dm644 lang/en.sh %{buildroot}%{_datadir}/%{name}/lang/en.sh

# Config example
install -Dm644 bigfive-updater.conf.example %{buildroot}%{_sysconfdir}/%{name}.conf.example

# Logrotate
install -Dm644 logrotate.d/bigfive-updater %{buildroot}%{_sysconfdir}/logrotate.d/%{name}

# Hook directories
install -dm755 %{buildroot}%{_sysconfdir}/%{name}.d/pre.d
install -dm755 %{buildroot}%{_sysconfdir}/%{name}.d/post.d

# Log directory
install -dm755 %{buildroot}%{_localstatedir}/log/%{name}

%files
%license LICENSE
%doc README.md README.tr.md CHANGELOG.md CHANGELOG.tr.md
%{_bindir}/guncel
%{_bindir}/updater
%{_bindir}/bigfive
%{_mandir}/man8/guncel.8*
%{_datadir}/bash-completion/completions/guncel
%{_datadir}/zsh/site-functions/_guncel
%{_datadir}/fish/vendor_completions.d/guncel.fish
%{_datadir}/%{name}/lang/tr.sh
%{_datadir}/%{name}/lang/en.sh
%config(noreplace) %{_sysconfdir}/%{name}.conf.example
%config(noreplace) %{_sysconfdir}/logrotate.d/%{name}
%dir %{_sysconfdir}/%{name}.d
%dir %{_sysconfdir}/%{name}.d/pre.d
%dir %{_sysconfdir}/%{name}.d/post.d
%dir %{_localstatedir}/log/%{name}

%changelog
* Wed Feb 04 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.4.0-1
- New features: --security-only, pre/post hooks, notifications
- Codename: Fluent Edition Hotel

* Wed Feb 04 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.3.1-1
- Critical fix: systemd-detect-virt exit code issue

* Wed Feb 04 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.3.0-1
- New features: cron jitter, container detection
- Codename: Fluent Edition Golf

* Mon Feb 03 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.2.0-1
- New feature: GPG signature verification for self-update
- Codename: Fluent Edition Foxtrot

* Sun Feb 02 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.1.0-1
- New features: --doctor, --history commands
- Codename: Fluent Edition Echo

* Fri Jan 31 2026 Ahmet Kaan Sever <ahmet@calmkernel.net> - 6.0.0-1
- Initial Fedora/COPR package
- Codename: Fluent Edition
