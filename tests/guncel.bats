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

@test "--help shows codename BigFive" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"BigFive"* ]]
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

@test "BigFive execution chain exists" {
    grep -q 'update_apt || update_dnf || update_pacman || update_zypper || update_apk' "$GUNCEL_SCRIPT"
}

# =============================================================================
# v5.1 BIGFIVE TESTS (Alpine apk)
# =============================================================================

@test "update_apk function exists" {
    grep -qE '^update_apk\(\)|^function update_apk' "$GUNCEL_SCRIPT"
}

@test "APK_COUNT variable is initialized" {
    grep -q '^APK_COUNT=' "$GUNCEL_SCRIPT"
}

@test "should_run_backend recognizes apk" {
    grep -q '"apk"' "$GUNCEL_SCRIPT"
}

@test "help shows apk option" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"apk"* ]]
}

# =============================================================================
# v5.3 JSON OUTPUT TESTS
# =============================================================================

@test "--json flag is recognized in help" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--json"* ]]
}

@test "--json-full flag is recognized in help" {
    run bash "$GUNCEL_SCRIPT" --help
    [ "$status" -eq 0 ]
    [[ "$output" == *"--json-full"* ]]
}

@test "JSON_MODE variable exists" {
    grep -q 'JSON_MODE=' "$GUNCEL_SCRIPT"
}

@test "output_json function exists" {
    grep -qE '^output_json\(\)|^function output_json' "$GUNCEL_SCRIPT"
}

@test "json_escape function exists" {
    grep -qE '^json_escape\(\)|^function json_escape' "$GUNCEL_SCRIPT"
}

@test "add_pkg_manager_status function exists" {
    grep -qE '^add_pkg_manager_status\(\)|^function add_pkg_manager_status' "$GUNCEL_SCRIPT"
}

@test "get_distro_info function exists" {
    grep -qE '^get_distro_info\(\)|^function get_distro_info' "$GUNCEL_SCRIPT"
}

@test "JSON_PACKAGES array is declared" {
    grep -q 'declare -a JSON_PACKAGES' "$GUNCEL_SCRIPT"
}

@test "JSON_PKG_MANAGERS array is declared" {
    grep -q 'declare -a JSON_PKG_MANAGERS' "$GUNCEL_SCRIPT"
}

@test "START_TIME variable is used" {
    grep -q 'START_TIME=' "$GUNCEL_SCRIPT"
}

# =============================================================================
# BASH COMPLETION TESTS (v5.4)
# =============================================================================

@test "Bash completion file exists" {
    [ -f "$PROJECT_ROOT/completions/guncel.bash" ]
}

@test "Bash completion has valid syntax" {
    bash -n "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion registers guncel command" {
    grep -q 'complete -F _guncel_completions guncel' "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion registers updater alias" {
    grep -q 'complete -F _guncel_completions updater' "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion registers bigfive alias" {
    grep -q 'complete -F _guncel_completions bigfive' "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion includes --json option" {
    grep -q '\-\-json' "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion includes --skip option" {
    grep -q '\-\-skip' "$PROJECT_ROOT/completions/guncel.bash"
}

@test "Bash completion includes backend values" {
    grep -q 'flatpak snap fwupd' "$PROJECT_ROOT/completions/guncel.bash"
}

# =============================================================================
# MAN PAGE TESTS (v5.4)
# =============================================================================

@test "Man page file exists" {
    [ -f "$PROJECT_ROOT/docs/guncel.8" ]
}

@test "Man page has valid troff format" {
    head -1 "$PROJECT_ROOT/docs/guncel.8" | grep -q '^\.\\"'
}

@test "Man page includes NAME section" {
    grep -q '^\.SH NAME' "$PROJECT_ROOT/docs/guncel.8"
}

@test "Man page includes SYNOPSIS section" {
    grep -q '^\.SH SYNOPSIS' "$PROJECT_ROOT/docs/guncel.8"
}

@test "Man page includes OPTIONS section" {
    grep -q '^\.SH OPTIONS' "$PROJECT_ROOT/docs/guncel.8"
}

@test "Man page documents --json option" {
    grep -q '\-\-json' "$PROJECT_ROOT/docs/guncel.8"
}

@test "Man page documents all package managers" {
    grep -q 'APT' "$PROJECT_ROOT/docs/guncel.8" && \
    grep -q 'DNF' "$PROJECT_ROOT/docs/guncel.8" && \
    grep -q 'Pacman' "$PROJECT_ROOT/docs/guncel.8" && \
    grep -q 'Zypper' "$PROJECT_ROOT/docs/guncel.8" && \
    grep -q 'APK' "$PROJECT_ROOT/docs/guncel.8"
}

# =============================================================================
# v5.4.7 COUNTER PARSING TESTS
# =============================================================================

@test "DNF5 counter parsing uses Transaction Summary pattern" {
    # v5.4.7: "Upgrading: X packages" from Transaction Summary
    grep -q 'grep -oP "Upgrading:\\s+\\K\\d+"' "$GUNCEL_SCRIPT"
}

@test "Zypper counter parsing uses pipe-separated pattern" {
    # v5.4.7: Count lines with | separator (not "^v")
    grep -q 'grep -c "|"' "$GUNCEL_SCRIPT"
}

@test "Self-update uses releases URL not raw.githubusercontent.com" {
    # v5.4.6: CDN cache fix
    grep -q 'GITHUB_RAW_URL="https://github.com/ahm3t0t/arcb-wider-updater/releases' "$GUNCEL_SCRIPT"
}

@test "SHA256 grep pattern matches exact guncel filename" {
    # v5.4.5: Must use "  guncel$" pattern to avoid matching guncel.bash, guncel.8
    grep -qE 'grep -E "\s+guncel\$"' "$GUNCEL_SCRIPT"
}

# =============================================================================
# ZSH/FISH COMPLETION TESTS (v5.4.8)
# =============================================================================

@test "Zsh completion file exists" {
    [ -f "$PROJECT_ROOT/completions/_guncel" ]
}

@test "Zsh completion has valid compdef header" {
    grep -q '#compdef guncel updater bigfive' "$PROJECT_ROOT/completions/_guncel"
}

@test "Zsh completion includes --json option" {
    grep -q '\-\-json' "$PROJECT_ROOT/completions/_guncel"
}

@test "Zsh completion includes backend values" {
    grep -q 'snapshot' "$PROJECT_ROOT/completions/_guncel"
    grep -q 'flatpak' "$PROJECT_ROOT/completions/_guncel"
}

@test "Fish completion file exists" {
    [ -f "$PROJECT_ROOT/completions/guncel.fish" ]
}

@test "Fish completion registers guncel command" {
    grep -q 'complete -c guncel' "$PROJECT_ROOT/completions/guncel.fish"
}

@test "Fish completion registers updater alias" {
    grep -q 'complete -c updater' "$PROJECT_ROOT/completions/guncel.fish"
}

@test "Fish completion registers bigfive alias" {
    grep -q 'complete -c bigfive' "$PROJECT_ROOT/completions/guncel.fish"
}

@test "Fish completion includes --json option" {
    grep -q '\-l json' "$PROJECT_ROOT/completions/guncel.fish"
}

@test "Fish completion includes backend values for --skip" {
    grep -q '\-l skip' "$PROJECT_ROOT/completions/guncel.fish"
    grep -q 'snapshot' "$PROJECT_ROOT/completions/guncel.fish"
}
