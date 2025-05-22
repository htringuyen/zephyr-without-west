#!/bin/bash
set -e

################################################################################
# SETUP ZEPHYR DEPENDENCIES
################################################################################

# Check if ZEPHYRWW_HOME exists
if [ -z "$ZEPHYRWW_HOME" ]; then
  ZEPHYRWW_HOME="${HOME}/.zephyrww"
fi

if [ ! -d "$ZEPHYRWW_HOME" ]; then
  echo "Invalid ZEPHYRWW_HOME: $ZEPHYRWW_HOME. Zephyrww may not be installed." >&2
  exit 1
fi

# export top level dir for use in scripts
export ZEPHYRWW_HOME=$ZEPHYRWW_HOME

# Check if first argument (board) is provided
if [ $# -eq 0 ] || [ -z "$1" ]; then
    echo "Error: Board name is required as first argument"
    echo "Usage: $0 <board> [--zephyr-version=<version>]"
    exit 1
fi

BOARD="$1"
ZEPHYR_VERSION=""

# Parse remaining arguments
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        --zephyr-version=*)
            ZEPHYR_VERSION="${1#*=}"
            shift
            ;;
        *)
            echo "Error: Unknown argument '$1'"
            echo "Usage: $0 <board> [--zephyr-version=<version>]"
            exit 1
            ;;
    esac
done

# Check if ZEPHYR_VERSION is not set or is empty
if [ -z "$ZEPHYR_VERSION" ]; then
    echo "ZEPHYR_VERSION is not set. Retrieving latest version..."
    ZEPHYR_VERSION=$(python $ZEPHYRWW_HOME/scripts/get_latest_zephyr_version.py)
    if [ -z "$ZEPHYR_VERSION" ]; then
        echo "Failed to retrieve Zephyr version."
        exit 1
    fi
    echo "Using Zephyr version: $ZEPHYR_VERSION"
fi

# Proceed with build logic
echo "Building for board: $BOARD"

# Ensure the corresponding zephyr version is installed
source $ZEPHYRWW_HOME/.venv/bin/activate
python $ZEPHYRWW_HOME/scripts/ensure_zephyr_installation.py --zephyr-version=$ZEPHYR_VERSION


################################################################################
# BUILD WITH THE ABOVE SETUP
################################################################################

export ZEPHYR_BASE_DIR="${ZEPHYRWW_HOME}/${ZEPHYR_VERSION}"

export ZEPHYR_SDK_INSTALL_DIR="${ZEPHYR_BASE_DIR}/zephyr-sdk"

export ZEPHYR_DIR="${ZEPHYR_BASE_DIR}/zephyr"

export ZEPHYR_MODULES_BASE="${ZEPHYR_BASE_DIR}/modules"
export BOOTLOADER_BASE="${ZEPHYR_BASE_DIR}/bootloader"

# Set all Zephyr modules paths
export ZEPHYR_MODULES_LIST=(
    "${ZEPHYR_MODULES_BASE}/lib/acpica"
    "${ZEPHYR_MODULES_BASE}/hal/cmsis"
    "${ZEPHYR_MODULES_BASE}/lib/cmsis-dsp"
    "${ZEPHYR_MODULES_BASE}/lib/cmsis-nn"
    "${ZEPHYR_MODULES_BASE}/hal/cmsis_6"
    "${ZEPHYR_MODULES_BASE}/fs/fatfs"
    "${ZEPHYR_MODULES_BASE}/hal/adi"
    "${ZEPHYR_MODULES_BASE}/hal/ambiq"
    "${ZEPHYR_MODULES_BASE}/hal/atmel"
    "${ZEPHYR_MODULES_BASE}/hal/bouffalolab"
    "${ZEPHYR_MODULES_BASE}/hal/espressif"
    "${ZEPHYR_MODULES_BASE}/hal/ethos_u"
    "${ZEPHYR_MODULES_BASE}/hal/gigadevice"
    "${ZEPHYR_MODULES_BASE}/hal/infineon"
    "${ZEPHYR_MODULES_BASE}/hal/intel"
    "${ZEPHYR_MODULES_BASE}/hal/microchip"
    "${ZEPHYR_MODULES_BASE}/hal/nordic"
    "${ZEPHYR_MODULES_BASE}/hal/nuvoton"
    "${ZEPHYR_MODULES_BASE}/hal/nxp"
    "${ZEPHYR_MODULES_BASE}/hal/openisa"
    "${ZEPHYR_MODULES_BASE}/hal/quicklogic"
    "${ZEPHYR_MODULES_BASE}/hal/renesas"
    "${ZEPHYR_MODULES_BASE}/hal/rpi_pico"
    "${ZEPHYR_MODULES_BASE}/hal/silabs"
    "${ZEPHYR_MODULES_BASE}/hal/st"
    "${ZEPHYR_MODULES_BASE}/hal/stm32"
    "${ZEPHYR_MODULES_BASE}/hal/tdk"
    "${ZEPHYR_MODULES_BASE}/hal/telink"
    "${ZEPHYR_MODULES_BASE}/hal/ti"
    "${ZEPHYR_MODULES_BASE}/hal/wch"
    "${ZEPHYR_MODULES_BASE}/hal/wurthelektronik"
    "${ZEPHYR_MODULES_BASE}/hal/xtensa"
    "${ZEPHYR_MODULES_BASE}/lib/hostap"
    "${ZEPHYR_MODULES_BASE}/lib/liblc3"
    "${ZEPHYR_MODULES_BASE}/lib/libmctp"
    "${ZEPHYR_MODULES_BASE}/hal/libmetal"
    "${ZEPHYR_MODULES_BASE}/fs/littlefs"
    "${ZEPHYR_MODULES_BASE}/lib/loramac-node"
    "${ZEPHYR_MODULES_BASE}/lib/gui/lvgl"
    "${ZEPHYR_MODULES_BASE}/crypto/mbedtls"
    "${BOOTLOADER_BASE}/mcuboot"
    "${ZEPHYR_MODULES_BASE}/debug/mipi-sys-t"
    "${ZEPHYR_MODULES_BASE}/bsim_hw_models/nrf_hw_models"
    "${ZEPHYR_MODULES_BASE}/lib/nrf_wifi"
    "${ZEPHYR_MODULES_BASE}/lib/open-amp"
    "${ZEPHYR_MODULES_BASE}/lib/openthread"
    "${ZEPHYR_MODULES_BASE}/debug/percepio"
    "${ZEPHYR_MODULES_BASE}/lib/picolibc"
    "${ZEPHYR_MODULES_BASE}/debug/segger"
    "${ZEPHYR_MODULES_BASE}/crypto/tinycrypt"
    "${ZEPHYR_MODULES_BASE}/tee/tf-a/trusted-firmware-a"
    "${ZEPHYR_MODULES_BASE}/tee/tf-m/trusted-firmware-m"
    "${ZEPHYR_MODULES_BASE}/lib/uoscore-uedhoc"
    "${ZEPHYR_MODULES_BASE}/lib/zcbor"
)

# build the value for ZEPHYR_MODULES
export ZEPHYR_MODULES_STRING=""
for module in "${ZEPHYR_MODULES_LIST[@]}"; do
    if [ -z "$ZEPHYR_MODULES_STRING" ]; then
        ZEPHYR_MODULES_STRING="$module"
    else
        ZEPHYR_MODULES_STRING="$ZEPHYR_MODULES_STRING;$module"
    fi
done
export ZEPHYR_MODULES="$ZEPHYR_MODULES_STRING"

echo "Environment variables set successfully!"
echo "ZEPHYR_SDK_INSTALL_DIR: $ZEPHYR_SDK_INSTALL_DIR"
echo "ZEPHYR_DIR: $ZEPHYR_DIR"
echo "ZEPHYR_MODULES count: ${#ZEPHYR_MODULES_LIST[@]}"


# Check if board name is provided
# if [ -z "$1" ]; then
#   echo "Usage: $0 <board_name>"
#   exit 1
# fi

BOARD_FULL=$BOARD
BOARD_DIR="${BOARD_FULL%%/*}"  # Extract part before the first '/'
BUILD_DIR="builds/$BOARD_DIR"

# Clean the build directory if it exists
if [ -d "$BUILD_DIR" ]; then
  echo "Cleaning existing build directory: $BUILD_DIR"
  rm -rf "$BUILD_DIR"
fi

# Run cmake configuration and build
cmake -P "$ZEPHYR_DIR/share/zephyr-package/cmake/zephyr_export.cmake"

#cmake -P "$ZEPHYR_SDK_INSTALL_DIR/cmake"

cmake -B"$BUILD_DIR" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -GNinja -DBOARD="$BOARD_FULL" .
cmake --build "$BUILD_DIR"
