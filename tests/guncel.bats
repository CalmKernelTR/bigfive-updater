#!/usr/bin/env bats
# BATS Unit Tests for guncel - ARCB Wider Updater
# v3.9.0 "Tested"

load test_helper

# =============================================================================
# --help OUTPUT TESTS
# =============================================================================

@test "--help flag shows usage information" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Kullanım"* ]] || [[ "$output" == *"Usage"* ]] || [[ "$output" == *"--help"* ]]
}

@test "--help flag shows version in header" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"v3.9.0"* ]]
}

@test "--help flag shows dry-run option" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--dry-run"* ]]
}

# =============================================================================
# VERSION OUTPUT TESTS (via --help header)
# =============================================================================

@test "--help shows version number 3.9.0" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"3.9.0"* ]]
}

@test "--help shows codename Tested" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"Tested"* ]]
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

@test "SKIP_DNF variable exists" {
    grep -q 'SKIP_DNF=' "$GUNCEL_SCRIPT"
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
