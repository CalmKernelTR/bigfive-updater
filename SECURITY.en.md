# Security Policy

## Supported Versions

| Version | Security Updates | Status |
|---------|-----------------|--------|
| v6.x    | Yes | Active |
| v5.x    | Yes | Security fixes only |
| < v5.0  | No | End of life |

Only the **main** branch is actively maintained and supported.

---

## Reporting a Vulnerability

If you discover a security vulnerability, please report it **responsibly** and **privately**.

### Preferred Methods:

1. **Email:** meet@calmkernel.tr
2. **GitHub Security Advisory:** [Report a vulnerability](https://github.com/CalmKernelTR/bigfive-updater/security/advisories/new)
3. **GitHub Issue (Public):** Use `security` label only after fix is discussed

### What to Include:

- Description of the vulnerability
- Steps to reproduce (if applicable)
- Potential impact
- Your suggested fix (if any)

**Timeline:** We aim to acknowledge reports within 48 hours and provide updates on progress.

Please avoid sharing sensitive details publicly before a fix is available. Thank you for helping keep BigFive secure!

---

## Release Signature Verification (v4.1.0+)

From **v4.1.0 onwards**, all releases are **cryptographically signed with GPG**.

### Why Sign Releases?

- Proves releases come from official maintainer
- Detects tampering or man-in-the-middle attacks
- Ensures file integrity (SHA256SUMS)
- Industry standard security practice

### Quick Verification

#### Step 1: Import Public Key
```bash
# Import GPG key from repository
curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/pubkey.asc | gpg --import

# Verify key fingerprint
gpg --list-keys ahmet@tanrikulu.net
# Expected: A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF
```

#### Step 2: Download Release Files
```bash
# Download checksums and signature
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS -o SHA256SUMS
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/SHA256SUMS.asc -o SHA256SUMS.asc
```

#### Step 3: Verify Signature
```bash
gpg --verify SHA256SUMS.asc SHA256SUMS
# Look for: "Good signature from Ahmet T. (bigfive-updater signing key)"
```

#### Step 4: Verify File Hash
```bash
# Download the script
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/guncel -o guncel

# Verify hash
sha256sum -c SHA256SUMS --ignore-missing
# Expected: guncel: OK
```

### Signing Key Information

| Property | Value |
|----------|-------|
| **Key ID** | `E5B757C69EFF27BF` |
| **Fingerprint** | `A9B7 CABC 5BC1 9608 7895 8003 E5B7 57C6 9EFF 27BF` |
| **UID** | `Ahmet T. (bigfive-updater signing key) <ahmet@tanrikulu.net>` |
| **Created** | 2026-01-28 |
| **Algorithm** | RSA 4096 |

### Automated Verification

The `install.sh` script performs GPG verification automatically during installation. If GPG is not installed, verification is skipped with a warning.

```bash
# Full verified installation
curl -fsSL https://github.com/CalmKernelTR/bigfive-updater/releases/latest/download/install.sh | sudo bash
```

---

## Security Features

### Strict Mode
```bash
set -Eeuo pipefail
```
- Exits on any error
- Exits on undefined variables
- Exits on pipe failures

### TLS 1.2+ Hardening (v4.1.5+)
All network operations enforce modern TLS:

```bash
# curl
curl --proto '=https' --tlsv1.2 ...

# wget
wget --secure-protocol=TLSv1_2 ...
```

### Secure Temporary Files
```bash
TEMP_FILE=$(mktemp)
trap 'rm -f "$TEMP_FILE"' EXIT
```

### Lock File Protection
```bash
exec 9> "$LOCK_FILE"
flock -n 9 || exit 1
```
