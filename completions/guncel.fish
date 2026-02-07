# Fish completion for guncel/updater/bigfive
# BigFive Updater v6.5.1+
# Install: sudo cp guncel.fish /usr/share/fish/vendor_completions.d/guncel.fish

# Disable file completion
complete -c guncel -f
complete -c updater -f
complete -c bigfive -f

# Backend values for --skip and --only
set -l backends snapshot flatpak snap fwupd system apt dnf pacman zypper apk

# Language values for --lang
set -l languages tr en

# Main options
complete -c guncel -c updater -c bigfive -l help -d 'Show help message'
complete -c guncel -c updater -c bigfive -l auto -d 'Non-interactive mode for cron/automation'
complete -c guncel -c updater -c bigfive -l verbose -d 'Verbose output'
complete -c guncel -c updater -c bigfive -l quiet -d 'Quiet mode, minimal output'
complete -c guncel -c updater -c bigfive -l dry-run -d 'Show what would be done without making changes'
complete -c guncel -c updater -c bigfive -l json -d 'Output lightweight JSON for monitoring'
complete -c guncel -c updater -c bigfive -l json-full -d 'Output detailed JSON for SIEM/audit'
complete -c guncel -c updater -c bigfive -l uninstall -d 'Uninstall guncel from system'
complete -c guncel -c updater -c bigfive -l purge -d 'Remove all files including logs (use with --uninstall)'
complete -c guncel -c updater -c bigfive -l doctor -d 'Run system health check'
complete -c guncel -c updater -c bigfive -l history -d 'Show update history for last N days'
complete -c guncel -c updater -c bigfive -l lang -d 'Set output language' -xa "$languages"

# --skip option with backend values
complete -c guncel -c updater -c bigfive -l skip -d 'Skip specific backends' -xa "$backends"

# --only option with backend values
complete -c guncel -c updater -c bigfive -l only -d 'Run only specific backends' -xa "$backends"

# Security and jitter options
complete -c guncel -c updater -c bigfive -l security-only -d 'Only apply security updates (DNF/Zypper)'
complete -c guncel -c updater -c bigfive -l jitter -d 'Random delay in seconds for cron (0-N)'
