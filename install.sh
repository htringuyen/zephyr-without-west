#!/bin/bash
set -e

# Get the directory of this script (repo root)
INSTALLER_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Optionally export if other processes need it
export INSTALLER_ROOT

# Define the path to the Python installer
INSTALLER_PYTHON="$INSTALLER_ROOT/scripts/share/install_zephyrww.py"

# Check that the Python script exists
if [ ! -f "$INSTALLER_PYTHON" ]; then
  echo "Error: Python installer not found at $INSTALLER_PYTHON"
  exit 1
fi

# Call the Python script, forwarding all arguments
python "$INSTALLER_PYTHON" "$@"
