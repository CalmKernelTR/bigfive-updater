#!/usr/bin/env bash
# BATS Test Helper - Common functions for guncel tests
# v3.9.0 "Tested"

# Path to the main script
export GUNCEL_SCRIPT="${BATS_TEST_DIRNAME}/../guncel"

# Mock directory for test isolation
export MOCK_DIR="${BATS_TEST_DIRNAME}/mocks"

# Helper: Run guncel with arguments
run_guncel() {
    bash "$GUNCEL_SCRIPT" "$@"
}

# Helper: Check if function exists in script
function_exists() {
    local func_name="$1"
    grep -qE "^${func_name}\\(\\)|^function ${func_name}" "$GUNCEL_SCRIPT"
}

# Helper: Extract variable value from script
get_script_variable() {
    local var_name="$1"
    grep -E "^${var_name}=" "$GUNCEL_SCRIPT" | head -1 | cut -d'=' -f2- | tr -d '"'
}

# Helper: Check if color variable is defined
color_defined() {
    local color_name="$1"
    grep -qE "^${color_name}=" "$GUNCEL_SCRIPT"
}

# Setup: Create mock directory
setup() {
    mkdir -p "$MOCK_DIR"
}

# Teardown: Clean up mock directory
teardown() {
    rm -rf "$MOCK_DIR"
}
