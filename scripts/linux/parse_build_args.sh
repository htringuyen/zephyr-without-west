#!/bin/bash

parse_args() {
    local board=""
    local zephyr_version=""
    local build_dir=""
    local source_dir=""
    
    # Check if no arguments provided
    if [ $# -eq 0 ]; then
        echo "Error: No arguments provided"
        show_usage
        exit 1
    fi
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -b)
                if [ -n "$2" ] && [[ $2 != -* ]]; then
                    board="$2"
                    shift 2
                else
                    echo "Error: -b requires a board name"
                    exit 1
                fi
                ;;
            -z)
                if [ -n "$2" ] && [[ $2 != -* ]]; then
                    zephyr_version="$2"
                    shift 2
                else
                    echo "Error: -z requires a zephyr version"
                    exit 1
                fi
                ;;
            -d)
                if [ -n "$2" ] && [[ $2 != -* ]]; then
                    build_dir="$2"
                    shift 2
                else
                    echo "Error: -d requires a build directory"
                    exit 1
                fi
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            -*)
                echo "Error: Unknown option $1"
                show_usage
                exit 1
                ;;
            *)
                # This should be the source directory (last positional argument)
                if [ -z "$source_dir" ]; then
                    source_dir="$1"
                else
                    echo "Error: Multiple source directories specified"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [ -z "$board" ]; then
        echo "Error: Board (-b) is required"
        show_usage
        exit 1
    fi
    
    if [ -z "$source_dir" ]; then
        echo "Error: Source directory is required"
        show_usage
        exit 1
    fi
    
    # Validate source directory exists
    if [ ! -d "$source_dir" ]; then
        echo "Error: Source directory '$source_dir' does not exist"
        exit 1
    fi
    
    # Set default values if not provided
    if [ -z "$zephyr_version" ]; then
        zephyr_version="latest"
    fi
    
    if [ -z "$build_dir" ]; then
        # Replace '/' with '_' in board name for default build directory
        board_safe="${board//\//_}"
        build_dir="builds/${board_safe}"
    fi
    
    # Export variables for use in main script
    export BOARD="$board"
    export ZEPHYR_VERSION="$zephyr_version"
    export BUILD_DIR="$build_dir"
    export SOURCE_DIR="$source_dir"
    
    # Optional: Print parsed values for debugging
    echo "Parsed arguments:"
    echo "  Board: $BOARD"
    echo "  Zephyr Version: $ZEPHYR_VERSION"
    echo "  Build Directory: $BUILD_DIR"
    echo "  Source Directory: $SOURCE_DIR"
}

show_usage() {
    cat << EOF
Usage: zephyrwwb -b <board> [-z <zephyr-version>] [-d <build-dir>] <source-dir>

Arguments:
  -b <board>              Board name (required)
  -z <zephyr-version>     Zephyr version (optional, default: latest)
  -d <build-dir>          Build directory (optional, default: builds/<board-with-slashes-as-underscores>)
  <source-dir>            Source directory (required)
  -h, --help              Show this help message

Examples:
  zephyrwwb -b nrf52840dk_nrf52840 ./my-project
  zephyrwwb -b esp32 -z v3.4.0 -d custom-build ./src
  zephyrwwb -z v1.0.1 -b nrf52840dk/nrf52840 .
    (default build dir: builds/nrf52840dk_nrf52840)
EOF
}

# Call the parser with all script arguments
parse_args "$@"