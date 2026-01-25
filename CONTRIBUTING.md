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
```

## Command Line Options

The script supports the following flags:

| Flag | Description |
|------|-------------|
| `--auto` | Automatic mode - no prompts, ideal for cron jobs |
| `--verbose` | Verbose mode - shows all command outputs |
| `--quiet` | Quiet mode - shows only errors and final summary |
| `--help` | Display help message |

## Testing

When testing new features:
- Test with `--verbose` to see all output
- Test with `--quiet` to ensure errors are still visible
- Test on both Debian and Fedora based systems if possible
