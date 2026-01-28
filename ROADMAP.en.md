# ARCB Wider Updater - Roadmap

> Continuing development as a shell script.

---

## Completed Versions

### v3.x Series - Stability & Infrastructure
- [x] Color and character fixes
- [x] DNF/APT lock mechanism
- [x] `--dry-run` mode
- [x] `--skip` and `--only` flags
- [x] Config file support
- [x] Logrotate integration
- [x] Release automation (GitHub Actions)
- [x] BATS unit test infrastructure (32 tests)
- [x] Multi-language documentation (TR/EN)

### v4.0.0 "Polished" - Cleanup & Consistency
- [x] CODENAME in installation message
- [x] Header cleanup (DRY)
- [x] Help message consistency
- [x] Documentation update

---

## Planned Features

### v4.1.0 - Security & Community
- [ ] GPG signed releases
- [ ] FUNDING.yml (GitHub Sponsors)
- [ ] SECURITY.md (security policy)

### v4.2.0 - User Experience
- [ ] `--json` output format (for automation)
- [ ] Desktop notification support (notify-send)
- [ ] Systemd timer template

### v4.3.0 - Advanced Features
- [ ] Parallel updates (APT + Flatpak simultaneously)
- [ ] Update history report
- [ ] Email/webhook notifications

---

## Ideas Under Consideration

| Idea | Status | Note |
|------|--------|------|
| Rust migration | Deferred | Bash is sufficient, complexity unnecessary |
| Web UI | Out of scope | Staying CLI-focused |
| Plugin system | Uncertain | If needed, v5.x |

---

## Contributing

Feel free to open an [Issue](https://github.com/ahm3t0t/arcb-wider-updater/issues) for suggestions.
