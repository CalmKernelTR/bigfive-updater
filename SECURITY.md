# Security Policy

## Reporting Security Vulnerabilities

If you discover a security vulnerability in ARCB Wider Updater, please **do not** open a public GitHub issue. Instead, please email us at:

📧 **meet@calmkernel.tr**

Please include:
- Description of the vulnerability
- Steps to reproduce (if applicable)
- Potential impact
- Suggested fix (if any)

We will acknowledge your report within 48 hours and provide updates on our progress.

Please avoid sharing sensitive details publicly before a fix is discussed.

---

## Signature Verification

All ARCB Wider Updater releases from **v4.1.0 onwards** are cryptographically signed using GPG.

### Verify Downloads

#### Step 1: Download Release Files
```bash
# Release sayfasından indir:
# - guncel
# - guncel.asc
# - install.sh
# - install.sh.asc
# - SHA256SUMS
# - SHA256SUMS.asc

cd ~/Downloads
ls -la guncel* install.sh* SHA256SUMS*
````

## Supported Versions

Only the **main** branch is actively maintained and supported.

Older commits or forks are not guaranteed to receive security updates.




Thank you for helping keep this project secure.
