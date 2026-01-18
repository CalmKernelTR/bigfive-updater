# Contributing to ARCB Wider Updater

Thanks for considering a contribution! ❤️

## Quick rules
- Keep it simple, readable, and safe.
- Prefer POSIX-ish, portable shell where possible.
- Never print secrets to logs.
- Any new feature should degrade gracefully if tools are missing.

## Development setup
Clone and run locally:

```bash
git clone git@github.com:ahm3t0t/arcb-wider-updater.git
cd arcb-wider-updater
chmod +x guncel install.sh
./guncel
./guncel --gui

