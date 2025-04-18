#!/usr/bin/env bash
# Make run-tests.sh executable with: chmod +x run-tests.sh

set -euo pipefail

# Make sure bats is installed
if ! command -v bats >/dev/null 2>&1; then
  echo "Error: bats is not installed. Please install it with your package manager."
  echo "For Ubuntu/Debian: sudo apt install bats"
  echo "For macOS: brew install bats-core"
  exit 1
fi

# Make sure the til script is executable
chmod +x ./til

# Run the tests
bats ./test/til.bats
