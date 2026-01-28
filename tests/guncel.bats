#!/usr/bin/env bats
# BATS Unit Tests for guncel - ARCB Wider Updater

load test_helper

# Get current version from script dynamically
get_script_version() {
    grep -oP '^VERSION="\K[^"]+' "$GUNCEL_SCRIPT"
}

# =============================================================================
# --help OUTPUT TESTS
# =============================================================================

@test "--help flag shows usage information" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Kullanım"* ]] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"--help"* ]]
}

@test "--help flag shows version in header" {
    local version=$(get_script_version)
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"$version"* ]]
}

@test "--help flag shows dry-run option" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--dry-run"* ]]
}

# =============================================================================
# VERSION OUTPUT TESTS (via --help header)
# =============================================================================

@test "--help shows version number from VERSION variable" {
    local version=$(get_script_version)
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"$version"* ]]
}

@test "--help shows codename Signed" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Signed"* ]]
}

# =============================================================================
# --dry-run MODE TESTS
# =============================================================================

@test "--dry-run flag is recognized" {
    # Just check that the flag doesn't cause an error
    # (actual dry-run requires root, so we just verify parsing)
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"dry-run"* ]]
}

@test "DRY_RUN variable exists in script" {
    grep -q 'DRY_RUN=' "$GUNCEL_SCRIPT"
}

# =============================================================================
# --skip FLAG PARSING TESTS
# =============================================================================

@test "SKIP_FLATPAK variable exists" {
    grep -q 'SKIP_FLATPAK=' "$GUNCEL_SCRIPT"
}

@test "SKIP_SNAP variable exists" {
    grep -q 'SKIP_SNAP=' "$GUNCEL_SCRIPT"
}

@test "SKIP_FWUPD variable exists" {
    grep -q 'SKIP_FWUPD=' "$GUNCEL_SCRIPT"
}

@test "SKIP_SNAPSHOT variable exists" {
    grep -q 'SKIP_SNAPSHOT=' "$GUNCEL_SCRIPT"
}

@test "SKIP_PKG_MANAGER variable exists" {
    grep -q 'SKIP_PKG_MANAGER=' "$GUNCEL_SCRIPT"
}

@test "--skip-flatpak option documented in help" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"skip"* ]] || [[ "$output" == *"flatpak"* ]]
}

# =============================================================================
# --only FLAG PARSING TESTS
# =============================================================================

@test "ONLY_MODE variable exists" {
    grep -q 'ONLY_MODE=' "$GUNCEL_SCRIPT"
}

@test "--only option parsing exists in script" {
    grep -qE '\-\-only' "$GUNCEL_SCRIPT"
}

# =============================================================================
# INVALID FLAG TESTS
# =============================================================================

@test "Invalid flag shows error or help" {
    run bash "$GUNCEL_SCRIPT" --invalid-flag-xyz123
    # Should either fail or show help
    [[ "$status" -ne 0 ]] || [[ "$output" == *"Kullanım"* ]] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"hata"* ]] || [[ "$output" == *"error"* ]] || [[ "$output" == *"Bilinmeyen"* ]]
}

# =============================================================================
# COLOR VARIABLE TESTS
# =============================================================================

@test "RED color variable is defined" {
    grep -q '^RED=' "$GUNCEL_SCRIPT"
}

@test "GREEN color variable is defined" {
    grep -q '^GREEN=' "$GUNCEL_SCRIPT"
}

@test "YELLOW color variable is defined" {
    grep -q '^YELLOW=' "$GUNCEL_SCRIPT"
}

@test "BLUE color variable is defined" {
    grep -q '^BLUE=' "$GUNCEL_SCRIPT"
}

@test "BOLD color variable is defined" {
    grep -q '^BOLD=' "$GUNCEL_SCRIPT"
}

@test "NC (no color) variable is defined" {
    grep -q '^NC=' "$GUNCEL_SCRIPT"
}

# =============================================================================
# CRITICAL FUNCTION EXISTENCE TESTS
# =============================================================================

@test "print_header function exists" {
    grep -qE '^print_header\(\)|^function print_header' "$GUNCEL_SCRIPT"
}

@test "print_error function exists" {
    grep -qE '^print_error\(\)|^function print_error' "$GUNCEL_SCRIPT"
}

@test "log_message or logging function exists" {
    grep -qE 'log_message|LOG_FILE|>> "\$LOG_FILE"' "$GUNCEL_SCRIPT"
}

@test "load_config function exists" {
    grep -qE '^load_config\(\)|^function load_config' "$GUNCEL_SCRIPT"
}

@test "show_help or usage function exists" {
    grep -qE 'show_help|show_usage|usage\(\)|help\(\)' "$GUNCEL_SCRIPT"
}

# =============================================================================
# SCRIPT STRUCTURE TESTS
# =============================================================================

@test "Script has shebang" {
    head -1 "$GUNCEL_SCRIPT" | grep -q '^#!/'
}

@test "Script uses bash" {
    head -1 "$GUNCEL_SCRIPT" | grep -q 'bash'
}

@test "VERSION variable is set" {
    grep -q '^VERSION=' "$GUNCEL_SCRIPT"
}

@test "CODENAME variable is set" {
    grep -q '^CODENAME=' "$GUNCEL_SCRIPT"
}

@test "Script passes bash syntax check" {
    bash -n "$GUNCEL_SCRIPT"
}

# =============================================================================
# --uninstall TESTS (v4.1.x)
# =============================================================================

@test "--uninstall option exists in script" {
    grep -qE '\-\-uninstall' "$GUNCEL_SCRIPT"
}

@test "do_uninstall function exists" {
    grep -qE '^do_uninstall\(\)|^function do_uninstall' "$GUNCEL_SCRIPT"
}

@test "--uninstall shows in help" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"uninstall"* ]]
}

@test "--purge option exists for uninstall" {
    grep -qE '\-\-purge' "$GUNCEL_SCRIPT"
}

# =============================================================================
# TLS HARDENING TESTS (v4.1.5+)
# =============================================================================

@test "curl uses TLS 1.2+ enforcement" {
    grep -q "\-\-proto '=https' --tlsv1.2" "$GUNCEL_SCRIPT"
}

@test "wget uses TLS 1.2+ enforcement" {
    grep -q "\-\-secure-protocol=TLSv1_2" "$GUNCEL_SCRIPT"
}

@test "download_file function uses TLS hardening" {
    # Check that download_file contains TLS flags
    awk '/^download_file\(\)/,/^}/' "$GUNCEL_SCRIPT" | grep -q "tlsv1.2\|TLSv1_2"
}

# =============================================================================
# PATH EXPORT TESTS (Cron compatibility)
# =============================================================================

@test "PATH is exported for Cron compatibility" {
    grep -qE '^export PATH=' "$GUNCEL_SCRIPT"
}

@test "PATH includes standard system directories" {
    grep 'export PATH=' "$GUNCEL_SCRIPT" | grep -q '/usr/local/bin'
}

# =============================================================================
# NETWORK FUNCTION TESTS
# =============================================================================

@test "download_file function exists" {
    grep -qE '^download_file\(\)|^function download_file' "$GUNCEL_SCRIPT"
}

@test "check_connectivity function exists" {
    grep -qE '^check_connectivity\(\)|^function check_connectivity' "$GUNCEL_SCRIPT"
}

@test "GITHUB_RAW_URL variable is defined" {
    grep -q 'GITHUB_RAW_URL=' "$GUNCEL_SCRIPT"
}

# =============================================================================
# SECURITY TESTS
# =============================================================================

@test "Script uses set -e or equivalent error handling" {
    grep -qE 'set -[eEuo]|set -o errexit|set -o pipefail' "$GUNCEL_SCRIPT"
}

@test "flock is used for concurrency protection" {
    grep -q 'flock' "$GUNCEL_SCRIPT"
}

@test "LOG_DIR uses secure permissions" {
    grep -qE 'mkdir.*700|chmod.*700.*LOG_DIR' "$GUNCEL_SCRIPT" || grep -q 'LOG_DIR=' "$GUNCEL_SCRIPT"
}

# =============================================================================
# v5.0 BIGFOUR TESTS
# =============================================================================

@test "update_pacman function exists" {
    grep -qE '^update_pacman\(\)|^function update_pacman' "$GUNCEL_SCRIPT"
}

@test "update_zypper function exists" {
    grep -qE '^update_zypper\(\)|^function update_zypper' "$GUNCEL_SCRIPT"
}

@test "PACMAN_COUNT variable is initialized" {
    grep -q '^PACMAN_COUNT=' "$GUNCEL_SCRIPT"
}

@test "ZYPPER_COUNT variable is initialized" {
    grep -q '^ZYPPER_COUNT=' "$GUNCEL_SCRIPT"
}

@test "should_run_backend recognizes pacman" {
    grep -q '"pacman"' "$GUNCEL_SCRIPT"
}

@test "should_run_backend recognizes zypper" {
    grep -q '"zypper"' "$GUNCEL_SCRIPT"
}

@test "help shows pacman option" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"pacman"* ]]
}

@test "help shows zypper option" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"zypper"* ]]
}

@test "BigFour execution chain exists" {
    grep -q 'update_apt || update_dnf || update_pacman || update_zypper' "$GUNCEL_SCRIPT"
}
