#!/bin/bash

set -e

################################################################################
# PROCESS INSTALLATION ARGUMENTS
################################################################################

parse_install_args() {
    local zephyrww_home=""
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d)
                if [ -n "$2" ] && [[ $2 != -* ]]; then
                    zephyrww_home="$2"
                    shift 2
                else
                    echo "Error: -d requires an installation directory"
                    exit 1
                fi
                ;;
            -h|--help)
                show_install_usage
                exit 0
                ;;
            -*)
                echo "Error: Unknown option $1"
                show_install_usage
                exit 1
                ;;
            *)
                echo "Error: Unexpected argument '$1'"
                show_install_usage
                exit 1
                ;;
        esac
    done
    
    # Set default value if not provided
    if [ -z "$zephyrww_home" ]; then
        zephyrww_home="$HOME/.zephyrww"
    fi
    
    # Expand tilde if present
    zephyrww_home="${zephyrww_home/#\~/$HOME}"
    
    # Export variable for use in main script
    export ZEPHYRWW_HOME="$zephyrww_home"
    
    # Optional: Print parsed values for debugging
    echo "Parsed installation arguments:"
    echo "  Installation Directory: $ZEPHYRWW_HOME"
}

show_install_usage() {
    cat << EOF
Usage: ./install.sh [-d <ZEPHYRWW_HOME>]

Arguments:
  -d <ZEPHYRWW_HOME>      Installation directory (optional, default: \$HOME/.zephyrww)
  -h, --help              Show this help message

Examples:
  ./install.sh
  ./install.sh -d /opt/zephyrww
  ./install.sh -d ~/my-zephyr-tools
EOF
}

# Call the parser with all script arguments
parse_install_args "$@"

################################################################################
# INSTALLING
################################################################################

# Log the directory (for testing)
echo "Install directory: $ZEPHYRWW_HOME"

# Create installation dir
if [ -d "$ZEPHYRWW_HOME" ]; then
  echo "Warning: Instalation directory already exists"
fi
mkdir -p "$ZEPHYRWW_HOME"

# Install scripts
if [ -d "$ZEPHYRWW_HOME/scripts" ]; then
  echo "Warning: Overriding existing scripts directory"
  rm -r "$ZEPHYRWW_HOME/scripts"
fi
mkdir -p "$ZEPHYRWW_HOME/scripts"
cp -r ./scripts/share/* "$ZEPHYRWW_HOME/scripts"
cp -r ./scripts/linux/* "$ZEPHYRWW_HOME/scripts"

# Install bin
if [ -d "$ZEPHYRWW_HOME/bin" ]; then
  echo "Warning: Overriding existing bin directory"
  rm -r "$ZEPHYRWW_HOME/bin"
fi
mkdir -p "$ZEPHYRWW_HOME/bin"
cp -r ./bin/linux/* "$ZEPHYRWW_HOME/bin"

# Install python virtual enviroment
if [ ! -d "$ZEPHYRWW_HOME/.venv" ]; then
    echo "Creating virtual environment in $ZEPHYRWW_HOME/.venv..."
    python -m venv "$ZEPHYRWW_HOME/.venv"
else
    echo "Warning: Virtual environment already exists at $ZEPHYRWW_HOME/.venv, skipping creation."
fi