#!/bin/bash

# Default install directory (optional)
INSTALL_DIR="${HOME}/.zephyrww"

# Parse options
while getopts "d:" opt; do
  case ${opt} in
    d )
      INSTALL_DIR="$OPTARG"
      ;;
    \? )
      echo "Usage: $0 -d install_dir"
      exit 1
      ;;
  esac
done

# Print the directory (for testing)
echo "Install directory: $INSTALL_DIR"

#Check if the directory already exists
# if [ -d "$INSTALL_DIR" ]; then
#   echo "Error: Directory '$INSTALL_DIR' already exists."
#   exit 1
# fi


mkdir -p "$INSTALL_DIR"

cp -r ./scripts $INSTALL_DIR

if [ ! -d "$INSTALL_DIR/.venv" ]; then
    echo "Creating virtual environment in $INSTALL_DIR/.venv..."
    python -m venv "$INSTALL_DIR/.venv"
else
    echo "Virtual environment already exists at $INSTALL_DIR/.venv, skipping creation."
fi





