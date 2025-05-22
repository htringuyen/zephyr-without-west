cmake_minimum_required(VERSION 3.20.0)

# Check if required environment variables are set
# if(NOT DEFINED ENV{ZEPHYR_SDK_INSTALL_DIR})
#     message(FATAL_ERROR "ZEPHYR_SDK_INSTALL_DIR environment variable is not set")
# endif()

# if(NOT DEFINED ENV{ZEPHYR_DIR})
#     message(FATAL_ERROR "ZEPHYR_DIR environment variable is not set")
# endif()

# if(NOT DEFINED ENV{ZEPHYR_MODULES})
#     message(FATAL_ERROR "ZEPHYR_MODULES environment variable is not set")
# endif()

# Set Zephyr SDK installation directory from environment variable
set(ZEPHYR_SDK_INSTALL_DIR $ENV{ZEPHYR_SDK_INSTALL_DIR})

# Set Zephyr modules from environment variable
set(ZEPHYR_MODULES $ENV{ZEPHYR_MODULES})

# Find Zephyr package with explicit path from environment variable
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_DIR})

project(ledpattern)
target_sources(app PRIVATE src/main.c)
