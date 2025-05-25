# PowerShell script to build Zephyr application

#******************************* Build Zephyr application *******************************

# Set strict error handling
$ErrorActionPreference = "Stop"

################################################################################
# CLEANUP CMAKE CACHE
################################################################################
$cmakePackagesPath = Join-Path $env:USERPROFILE ".cmake\packages"
$zephyrCachePath = Join-Path $cmakePackagesPath "Zephyr"
$zephyrSdkCachePath = Join-Path $cmakePackagesPath "Zephyr-sdk"

if (Test-Path $zephyrCachePath) {
    Remove-Item -Recurse -Force $zephyrCachePath
}

if (Test-Path $zephyrSdkCachePath) {
    Remove-Item -Recurse -Force $zephyrSdkCachePath
}

################################################################################
# SETUP ENVIROMENT AND ZEPHYR DEPENDENCIES
################################################################################

# Setup top level directories: ZEPHYRWW_HOME, ZEPHYRWW_SCRIPTS
if (-not $env:ZEPHYRWW_HOME) {
    $env:ZEPHYRWW_HOME = Join-Path $env:USERPROFILE ".zephyrww"
}

if (-not (Test-Path $env:ZEPHYRWW_HOME -PathType Container)) {
    Write-Host "Invalid ZEPHYRWW_HOME: $($env:ZEPHYRWW_HOME). Zephyrww may not be installed." -ForegroundColor Red
    exit 1
}

$ZEPHYRWW_SCRIPTS = Join-Path $env:ZEPHYRWW_HOME "scripts"

# Activate Zephyrww's python virtual env
$venvActivate = Join-Path $env:ZEPHYRWW_HOME ".venv\Scripts\Activate.ps1"
if (Test-Path $venvActivate) {
    & $venvActivate
} else {
    Write-Host "Python virtual environment not found at: $venvActivate" -ForegroundColor Red
    exit 1
}

# Parse arguments and export as env vars: BOARD, ZEPHYR_VERSION, BUILD_DIR, SOURCE_DIR
$parseArgsScript = Join-Path $ZEPHYRWW_SCRIPTS "parse_build_args.ps1"
if (Test-Path $parseArgsScript) {
    & $parseArgsScript @args
} else {
    Write-Host "Parse arguments script not found at: $parseArgsScript" -ForegroundColor Red
    exit 1
}

# If ZEPHYR_VERSION is latest, then fetch its actuall value
if ($env:ZEPHYR_VERSION -eq "latest") {
    Write-Host "ZEPHYR_VERSION is set to 'latest'. Retrieving latest version..."
    $getLatestScript = Join-Path $env:ZEPHYRWW_HOME "scripts\get_latest_zephyr_version.py"
    $env:ZEPHYR_VERSION = python $getLatestScript
    if (-not $env:ZEPHYR_VERSION) {
        Write-Host "Failed to retrieve Zephyr version." -ForegroundColor Red
        exit 1
    }
    Write-Host "Using latest Zephyr version: $($env:ZEPHYR_VERSION)"
}

# Ensure the zephyr installation for specified version exists
$ensureInstallScript = Join-Path $env:ZEPHYRWW_HOME "scripts\ensure_zephyr_installation.py"
python $ensureInstallScript --zephyr-version=$env:ZEPHYR_VERSION

################################################################################
# BUILD APP WITH CMAKE
################################################################################

# Export top level directory paths for Zephyr installation
$ZEPHYR_BASE_DIR = Join-Path $env:ZEPHYRWW_HOME $env:ZEPHYR_VERSION
$ZEPHYR_DIR = Join-Path $ZEPHYR_BASE_DIR "zephyr"
$ZEPHYR_SDK_DIR = Join-Path $ZEPHYR_BASE_DIR "zephyr-sdk"
$ZEPHYR_MODULES_BASE = Join-Path $ZEPHYR_BASE_DIR "modules"
$BOOTLOADER_BASE = Join-Path $ZEPHYR_BASE_DIR "bootloader"

# Set ZEPHYR_MODULES env var for use in cmake
$ZEPHYR_MODULES_LIST = @(
    (Join-Path $ZEPHYR_MODULES_BASE "lib\acpica"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\cmsis"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\cmsis-dsp"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\cmsis-nn"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\cmsis_6"),
    (Join-Path $ZEPHYR_MODULES_BASE "fs\fatfs"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\adi"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\ambiq"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\atmel"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\bouffalolab"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\espressif"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\ethos_u"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\gigadevice"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\infineon"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\intel"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\microchip"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\nordic"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\nuvoton"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\nxp"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\openisa"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\quicklogic"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\renesas"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\rpi_pico"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\silabs"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\st"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\stm32"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\tdk"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\telink"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\ti"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\wch"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\wurthelektronik"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\xtensa"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\hostap"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\liblc3"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\libmctp"),
    (Join-Path $ZEPHYR_MODULES_BASE "hal\libmetal"),
    (Join-Path $ZEPHYR_MODULES_BASE "fs\littlefs"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\loramac-node"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\gui\lvgl"),
    (Join-Path $ZEPHYR_MODULES_BASE "crypto\mbedtls"),
    (Join-Path $BOOTLOADER_BASE "mcuboot"),
    (Join-Path $ZEPHYR_MODULES_BASE "debug\mipi-sys-t"),
    (Join-Path $ZEPHYR_MODULES_BASE "bsim_hw_models\nrf_hw_models"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\nrf_wifi"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\open-amp"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\openthread"),
    (Join-Path $ZEPHYR_MODULES_BASE "debug\percepio"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\picolibc"),
    (Join-Path $ZEPHYR_MODULES_BASE "debug\segger"),
    (Join-Path $ZEPHYR_MODULES_BASE "crypto\tinycrypt"),
    (Join-Path $ZEPHYR_MODULES_BASE "tee\tf-a\trusted-firmware-a"),
    (Join-Path $ZEPHYR_MODULES_BASE "tee\tf-m\trusted-firmware-m"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\uoscore-uedhoc"),
    (Join-Path $ZEPHYR_MODULES_BASE "lib\zcbor")
)

$ZEPHYR_MODULES_STRING = $ZEPHYR_MODULES_LIST -join ";"
$env:ZEPHYR_MODULES = $ZEPHYR_MODULES_STRING

# Clean the build directory if it exists
if (Test-Path $env:BUILD_DIR) {
    Write-Host "Cleaning existing build directory: $($env:BUILD_DIR)"
    Remove-Item -Recurse -Force $env:BUILD_DIR
}

$env:ZEPHYR_ENTRY_POINT = Join-Path $ZEPHYR_DIR "share\zephyr-package\cmake"
$env:ZEPHYR_SDK_INSTALL_DIR = $ZEPHYR_SDK_DIR

# Run cmake configuration and build
#cmake -P "$ZEPHYR_DIR/share/zephyr-package/cmake/zephyr_export.cmake"
#cmake -P "$ZEPHYR_SDK_DIR/cmake/zephyr_sdk_export.cmake"
cmake -B"$($env:BUILD_DIR)" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON `
    -DZEPHYR_MODULES="$($env:ZEPHYR_MODULES)" -GNinja -DBOARD="$($env:BOARD)" "$($env:SOURCE_DIR)"
cmake --build "$($env:BUILD_DIR)"

# Deactivate Python virtual environment
if (Get-Command "deactivate" -ErrorAction SilentlyContinue) {
    deactivate
    Write-Host "Python virtual environment deactivated."
} else {
    Write-Host "No active virtual environment to deactivate or deactivate command not found." -ForegroundColor Yellow
}