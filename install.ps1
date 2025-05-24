# Enable strict error handling (equivalent to set -e)
$ErrorActionPreference = "Stop"

# Get the directory of this script (repo root)
$INSTALLER_ROOT = Split-Path -Parent $MyInvocation.MyCommand.Path

# Optionally set as environment variable if other processes need it
$env:INSTALLER_ROOT = $INSTALLER_ROOT

# Define the path to the Python installer
$INSTALLER_PYTHON = Join-Path $INSTALLER_ROOT "scripts\share\install_zephyrww.py"

# Check that the Python script exists
if (-not (Test-Path $INSTALLER_PYTHON)) {
    Write-Error "Error: Python installer not found at $INSTALLER_PYTHON"
    exit 1
}

# Call the Python script, forwarding all arguments
& python $INSTALLER_PYTHON @args