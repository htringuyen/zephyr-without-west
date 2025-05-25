cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED
    PATHS $ENV{ZEPHYR_ENTRY_POINT}
    NO_DEFAULT_PATH
)

project(ledpattern)
target_sources(app PRIVATE src/main.c)
