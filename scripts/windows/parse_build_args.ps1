# PowerShell argument parsing functions

function Parse-Args {
    param(
        [string[]]$Arguments
    )
    
    $board = ""
    $zephyr_version = ""
    $build_dir = ""
    $source_dir = ""
    
    # Check if no arguments provided
    if ($Arguments.Count -eq 0) {
        Write-Host "Error: No arguments provided" -ForegroundColor Red
        Show-Usage
        exit 1
    }
    
    # Parse arguments
    $i = 0
    while ($i -lt $Arguments.Count) {
        switch ($Arguments[$i]) {
            "-b" {
                if (($i + 1) -lt $Arguments.Count -and -not $Arguments[$i + 1].StartsWith("-")) {
                    $board = $Arguments[$i + 1]
                    $i += 2
                } else {
                    Write-Host "Error: -b requires a board name" -ForegroundColor Red
                    exit 1
                }
            }
            "-z" {
                if (($i + 1) -lt $Arguments.Count -and -not $Arguments[$i + 1].StartsWith("-")) {
                    $zephyr_version = $Arguments[$i + 1]
                    $i += 2
                } else {
                    Write-Host "Error: -z requires a zephyr version" -ForegroundColor Red
                    exit 1
                }
            }
            "-d" {
                if (($i + 1) -lt $Arguments.Count -and -not $Arguments[$i + 1].StartsWith("-")) {
                    $build_dir = $Arguments[$i + 1]
                    $i += 2
                } else {
                    Write-Host "Error: -d requires a build directory" -ForegroundColor Red
                    exit 1
                }
            }
            "-h" {
                Show-Usage
                exit 0
            }
            "--help" {
                Show-Usage
                exit 0
            }
            default {
                # Check if it's an unknown option (starts with -)
                if ($Arguments[$i].StartsWith("-")) {
                    Write-Host "Error: Unknown option $($Arguments[$i])" -ForegroundColor Red
                    Show-Usage
                    exit 1
                }
                # This should be the source directory (last positional argument)
                if ([string]::IsNullOrEmpty($source_dir)) {
                    $source_dir = $Arguments[$i]
                } else {
                    Write-Host "Error: Multiple source directories specified" -ForegroundColor Red
                    exit 1
                }
                $i++
            }
        }
    }
    
    # Validate required arguments
    if ([string]::IsNullOrEmpty($board)) {
        Write-Host "Error: Board (-b) is required" -ForegroundColor Red
        Show-Usage
        exit 1
    }
    
    if ([string]::IsNullOrEmpty($source_dir)) {
        Write-Host "Error: Source directory is required" -ForegroundColor Red
        Show-Usage
        exit 1
    }
    
    # Validate source directory exists
    if (-not (Test-Path $source_dir -PathType Container)) {
        Write-Host "Error: Source directory '$source_dir' does not exist" -ForegroundColor Red
        exit 1
    }
    
    # Set default values if not provided
    if ([string]::IsNullOrEmpty($zephyr_version)) {
        $zephyr_version = "latest"
    }
    
    if ([string]::IsNullOrEmpty($build_dir)) {
        # Replace '/' with '_' in board name for default build directory
        $board_safe = $board -replace "/", "_"
        $build_dir = "builds/$board_safe"
    }
    
    # Set environment variables for use in main script
    $env:BOARD = $board
    $env:ZEPHYR_VERSION = $zephyr_version
    $env:BUILD_DIR = $build_dir
    $env:SOURCE_DIR = $source_dir
    
    # Optional: Print parsed values for debugging
    Write-Host "Parsed arguments:"
    Write-Host " Board: $($env:BOARD)"
    Write-Host " Zephyr Version: $($env:ZEPHYR_VERSION)"
    Write-Host " Build Directory: $($env:BUILD_DIR)"
    Write-Host " Source Directory: $($env:SOURCE_DIR)"
}

function Show-Usage {
    Write-Host @"
Usage: zephyrwwb -b <board> [-z <zephyr-version>] [-d <build-dir>] <source-dir>

Arguments:
 -b <board>          Board name (required)
 -z <zephyr-version> Zephyr version (optional, default: latest)
 -d <build-dir>      Build directory (optional, default: builds/<board-with-slashes-as-underscores>)
 <source-dir>        Source directory (required)
 -h, --help          Show this help message

Examples:
 zephyrwwb -b nrf52840dk_nrf52840 ./my-project
 zephyrwwb -b esp32 -z v3.4.0 -d custom-build ./src
 zephyrwwb -z v1.0.1 -b nrf52840dk/nrf52840 .
 (default build dir: builds/nrf52840dk_nrf52840)
"@
}

# Call the parser with all script arguments
Parse-Args $args