#!/usr/bin/env bash
# BigFive Updater - English Language File
# Language: English (en)
# Version: 6.2.0 Foxtrot Edition
# Encoding: UTF-8

# ============================================
# HEADERS - Section Headers
# ============================================
MSG_HEADER_SELF_UPDATE="Starting Self-Update..."
MSG_HEADER_SNAPSHOT_TIMESHIFT="Creating System Backup (Timeshift)"
MSG_HEADER_SNAPSHOT_SNAPPER="Creating System Backup (Snapper)"
MSG_HEADER_APT_UPDATE="APT: Starting Update"
MSG_HEADER_APT_UPGRADE="APT: Dist-Upgrade"
MSG_HEADER_APT_CLEANUP="APT: Cleanup"
MSG_HEADER_DNF_UPDATE="DNF: Update"
MSG_HEADER_PACMAN_UPDATE="Pacman: Update"
MSG_HEADER_PACMAN_ORPHAN="Pacman: Orphan Cleanup"
MSG_HEADER_ZYPPER_UPDATE="Zypper: Update"
MSG_HEADER_ZYPPER_CLEANUP="Zypper: Cleanup"
MSG_HEADER_APK_UPDATE="APK: Update"
MSG_HEADER_FLATPAK="Flatpak: Update"
MSG_HEADER_SNAP="Snap: Update"
MSG_HEADER_FIRMWARE="Firmware: Check"
MSG_HEADER_DRYRUN="[DRY-RUN] Checking Available Updates"

# ============================================
# INFO - Informational Messages
# ============================================
MSG_INFO_SHA256_OK="SHA256 verification successful."
MSG_INFO_BACKUP_CREATED="Old version backed up: %s"
MSG_INFO_PGREP_MISSING="pgrep not found, skipping DNF lock check."
MSG_INFO_SNAPSHOT_SKIPPED="Snapshot skipped (--skip snapshot)"
MSG_INFO_APT_COUNT="APT: %d packages updated."
MSG_INFO_DNF_COUNT="DNF: %d packages updated."
MSG_INFO_PACMAN_COUNT="Pacman: %d packages updated."
MSG_INFO_ZYPPER_COUNT="Zypper: %d packages updated."
MSG_INFO_APK_COUNT="APK: %d packages updated."
MSG_INFO_FLATPAK_COUNT="Flatpak: %d applications updated."
MSG_INFO_SNAP_COUNT="Snap: %d packages updated."
MSG_INFO_FIRMWARE_NONE="Firmware: No upgradable devices found."
MSG_INFO_FIRMWARE_COUNT="Firmware: %d updates."
MSG_INFO_GPG_OK="GPG signature verification successful."

# ============================================
# SUCCESS - Success Messages
# ============================================
MSG_SUCCESS_SCRIPT_UPDATED="Script updated. Restarting..."
MSG_SUCCESS_RESTORE="Restore successful."
MSG_SUCCESS_TIMESHIFT="Timeshift snapshot created."
MSG_SUCCESS_SNAPPER="Snapper snapshot created."
MSG_SUCCESS_UPDATE_DONE="[+] UPDATE COMPLETED"

# ============================================
# WARNING - Warning Messages
# ============================================
MSG_WARN_REPO_ACCESS="Cannot access repo files. Self-update disabled."
MSG_WARN_SHA256_MISSING="SHA256SUMS file not found, skipping verification."
MSG_WARN_BACKUP_FAILED="Backup failed, continuing anyway."
MSG_WARN_DNF_LOCK_WAIT="Waiting for DNF lock... (%d/%d)"
MSG_WARN_TIMESHIFT_TIMEOUT="Timeshift snapshot timed out (%ds)"
MSG_WARN_TIMESHIFT_FAILED="Timeshift snapshot failed (exit: %d)"
MSG_WARN_SNAPPER_TIMEOUT="Snapper snapshot timed out (%ds)"
MSG_WARN_SNAPPER_FAILED="Snapper snapshot creation failed."
MSG_WARN_FLATPAK_ERROR="Flatpak encountered an error."
MSG_WARN_SNAP_ERROR="Snap encountered an error."
MSG_WARN_FIRMWARE_FAILED="Firmware check failed (exit code: %d)"
MSG_WARN_GPG_MISSING="GPG not found, skipping signature verification."
MSG_WARN_GPG_KEY_FAIL="Could not download public key, skipping GPG verification."
MSG_WARN_GPG_IMPORT_FAIL="Could not import public key, skipping GPG verification."
MSG_WARN_GPG_SIG_MISSING="SHA256SUMS.asc not found, skipping GPG verification."

# ============================================
# ERROR - Error Messages
# ============================================
MSG_ERR_NO_CURL="Neither 'curl' nor 'wget' found on system!"
MSG_ERR_NO_SUDO="Sudo not available and you're not root."
MSG_ERR_SHA256_FAIL="SHA256 verification failed! Update cancelled."
MSG_ERR_COPY_FAIL="Failed to copy update!"
MSG_ERR_APT_LOCK="Could not release APT locks."
MSG_ERR_DNF_LOCK="DNF lock timeout!"
MSG_ERR_ALREADY_RUNNING="Another update process is already running."
MSG_ERR_NO_INTERNET="Could not establish internet connection."
MSG_ERR_GPG_FAIL="GPG signature verification failed! Update cancelled."

# ============================================
# HINTS - Solution Suggestions
# ============================================
MSG_HINT_INSTALL_CURL="Install with: apt install curl or dnf install curl"
MSG_HINT_NO_SUDO="If sudo not installed: su -c 'dnf install sudo' or run as root."
MSG_HINT_SHA256_FAIL="File may be corrupted. Try again later or install manually."
MSG_HINT_COPY_FAIL="Disk may be full or no write permission. Check with 'df -h' and 'ls -la /usr/local/bin/'"
MSG_HINT_APT_LOCK="Another update may be running. Check with 'sudo lsof /var/lib/dpkg/lock-frontend'"
MSG_HINT_DNF_LOCK="Find running process with 'pgrep -a dnf' or wait. Close GNOME Software if open."
MSG_HINT_ALREADY_RUNNING="Check with 'pgrep -a guncel'. If needed, remove lock with 'sudo rm %s'"
MSG_HINT_NO_INTERNET="Test connection with 'ping -c 1 google.com'. Check DNS or network settings."
MSG_HINT_GPG_FAIL="File may have been tampered. Manual install: curl -fsSL https://raw.githubusercontent.com/CalmKernelTR/bigfive-updater/main/install.sh | sudo bash"

# ============================================
# HELP - Help Text
# ============================================
MSG_HELP_USAGE="Usage: guncel | updater | bigfive [OPTION]"
MSG_HELP_OPTIONS="Options:"
MSG_HELP_OPT_AUTO="  --auto              Automatic mode (Updates without confirmation)"
MSG_HELP_OPT_VERBOSE="  --verbose           Verbose output mode (Shows all command output)"
MSG_HELP_OPT_QUIET="  --quiet             Quiet mode (Only shows errors and summary)"
MSG_HELP_OPT_DRYRUN="  --dry-run           Dry run (Show what would be done, don't do it)"
MSG_HELP_OPT_JSON="  --json              JSON output (for monitoring systems)"
MSG_HELP_OPT_JSON_FULL="  --json-full         Detailed JSON output (for SIEM/audit)"
MSG_HELP_OPT_SKIP="  --skip <backend>    Skip specified backends (comma-separated)"
MSG_HELP_OPT_SKIP_VALUES="                      Values: snapshot, flatpak, snap, fwupd, system"
MSG_HELP_OPT_SKIP_SYSTEM="                      (system = apt, dnf, pacman, zypper, apk)"
MSG_HELP_OPT_ONLY="  --only <backend>    Run only specified backends (comma-separated)"
MSG_HELP_OPT_ONLY_VALUES="                      Values: system, flatpak, snap, fwupd, apt, dnf, pacman, zypper, apk"
MSG_HELP_OPT_UNINSTALL="  --uninstall         Uninstall BigFive Updater"
MSG_HELP_OPT_PURGE="  --uninstall --purge Also delete config and logs"
MSG_HELP_OPT_LANG="  --lang <code>       Language selection (tr, en)"
MSG_HELP_OPT_HELP="  --help              Show this help message"
MSG_HELP_EXAMPLES="Examples:"
MSG_HELP_EX_INTERACTIVE="  guncel                        -> Interactive (Recommended)"
MSG_HELP_EX_AUTO="  guncel --auto                 -> Cron / Scheduled tasks"
MSG_HELP_EX_VERBOSE="  guncel --verbose              -> Update with detailed output"
MSG_HELP_EX_QUIET="  guncel --quiet                -> Quiet update (summary only)"
MSG_HELP_EX_DRYRUN="  guncel --dry-run              -> List updates (without applying)"
MSG_HELP_EX_JSON="  guncel --json                 -> JSON output for monitoring (Zabbix/Nagios)"
MSG_HELP_EX_JSON_FULL="  guncel --json-full            -> Detailed JSON for SIEM (Wazuh/Splunk)"
MSG_HELP_EX_SKIP="  guncel --skip flatpak,snap    -> Skip Flatpak and Snap"
MSG_HELP_EX_ONLY_SYSTEM="  guncel --only system          -> System packages only (APT/DNF/Pacman/Zypper/APK)"
MSG_HELP_EX_ONLY_FLATPAK="  guncel --only flatpak,fwupd   -> Flatpak and Firmware only"
MSG_HELP_EX_ONLY_PACMAN="  guncel --only pacman          -> Pacman only (Arch Linux)"
MSG_HELP_EX_ONLY_APK="  guncel --only apk             -> APK only (Alpine Linux)"
MSG_HELP_EX_UNINSTALL="  guncel --uninstall            -> Uninstall (keeps config/logs)"
MSG_HELP_EX_PURGE="  guncel --uninstall --purge    -> Complete uninstall"
MSG_HELP_CONFIG="Config File: %s"
MSG_HELP_CONFIG_DESC="  You can define default settings in the config file."
MSG_HELP_CONFIG_EXAMPLE="  Example: /etc/bigfive-updater.conf.example"

# ============================================
# SUMMARY - Summary Messages
# ============================================
MSG_SUMMARY_PRE="PRE-UPDATE SYSTEM INFO"
MSG_SUMMARY_POST="POST-UPDATE SUMMARY"
MSG_SUMMARY_REBOOT_YES="Reboot: [!] Required"
MSG_SUMMARY_REBOOT_NO="Reboot: Not required"
MSG_SUMMARY_REBOOT_REQUIRED="Required"
MSG_SUMMARY_REBOOT_NOT_REQUIRED="Not required"

# ============================================
# MISC - Other
# ============================================
MSG_CONFIRM_CONTINUE="Do you want to continue? [Y/n]"
MSG_RESTORE_ATTEMPT="Attempting restore from backup..."
MSG_DNF_LOCK_FAILED="Could not acquire DNF lock, skipping DNF update."

# ============================================
# v6.1.0 - DOCTOR Messages
# ============================================
MSG_DOCTOR_TITLE="BigFive Doctor - System Health Check"
MSG_DOCTOR_CHECK_CONFIG="Config file..."
MSG_DOCTOR_CHECK_REQUIRED="Required commands..."
MSG_DOCTOR_CHECK_OPTIONAL="Optional commands..."
MSG_DOCTOR_CHECK_DISK="Disk space..."
MSG_DOCTOR_CHECK_INTERNET="Internet connectivity..."
MSG_DOCTOR_CHECK_LANG="Language files..."
MSG_DOCTOR_CONFIG_OK="%s"
MSG_DOCTOR_CONFIG_SYNTAX_ERR="Syntax error: %s"
MSG_DOCTOR_CONFIG_NONE="Not found (default settings will be used)"
MSG_DOCTOR_CMDS_OK="All present"
MSG_DOCTOR_CMDS_MISSING="Missing: %s"
MSG_DOCTOR_DISK_OK="%sMB available (min: 500MB)"
MSG_DOCTOR_DISK_LOW="%sMB available (min: 500MB required)"
MSG_DOCTOR_DISK_UNKNOWN="Could not check"
MSG_DOCTOR_NET_OK="GitHub reachable"
MSG_DOCTOR_NET_FAIL="GitHub unreachable"
MSG_DOCTOR_LANG_OK="%d language files present"
MSG_DOCTOR_LANG_PARTIAL="%d present, %d missing"
MSG_DOCTOR_SUMMARY_OK="System healthy - BigFive ready to use"
MSG_DOCTOR_SUMMARY_WARN="%d warning(s) - BigFive can run"
MSG_DOCTOR_SUMMARY_ERR="%d error(s), %d warning(s) - Please fix issues"
# v6.5.0 - New Doctor checks
MSG_DOCTOR_CHECK_PERMS="File permissions..."
MSG_DOCTOR_PERMS_OK="All permissions correct"
MSG_DOCTOR_PERMS_WARN="Check: %s"
MSG_DOCTOR_CHECK_GPG="GPG keyring..."
MSG_DOCTOR_GPG_OK="GPG available, %d keys"
MSG_DOCTOR_GPG_NOKEYS="GPG available, no keys imported"
MSG_DOCTOR_GPG_NOTFOUND="GPG not installed (optional)"
MSG_DOCTOR_CHECK_LOCK="Lock file..."
MSG_DOCTOR_LOCK_OK="No lock file (ready to run)"
MSG_DOCTOR_LOCK_ACTIVE="Another instance running (PID: %s)"
MSG_DOCTOR_LOCK_STALE="Stale lock file (can be removed)"

# ============================================
# v6.1.0 - HISTORY Messages
# ============================================
MSG_HISTORY_TITLE="BigFive Update History - Last %d Days"
MSG_HISTORY_COL_DATE="Date"
MSG_HISTORY_COL_TIME="Time"
MSG_HISTORY_COL_STATUS="Status"
MSG_HISTORY_COL_DETAIL="Detail"
MSG_HISTORY_NO_DIR="Log directory not found: %s"
MSG_HISTORY_NO_DIR_HINT="No updates may have been performed yet."
MSG_HISTORY_NO_LOGS="No update records found in the last %d days."
MSG_HISTORY_TOTAL="Total: %d records"
MSG_HISTORY_STATUS_OK="OK"
MSG_HISTORY_STATUS_ERROR="ERROR"
MSG_HISTORY_STATUS_DRY="DRY"
MSG_HISTORY_STATUS_UNKNOWN="?"
MSG_HISTORY_DETAIL_SUCCESS="Successful"
MSG_HISTORY_DETAIL_ERRORS="%d error(s)"
MSG_HISTORY_DETAIL_SIMULATION="Simulation"
MSG_HISTORY_DETAIL_UNKNOWN="Unknown"

# ============================================
# v6.1.0 - HELP Messages (Additional)
# ============================================
MSG_HELP_OPT_DOCTOR="  --doctor            System health check (config, dependencies, disk, network)"
MSG_HELP_OPT_HISTORY="  --history [N]       Show update history for last N days (default: 7)"
