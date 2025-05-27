# Ledpattern

An sample application named `ledpattern` that has two blinking LEDs and one button controlling the blink frequencies of the LEDs.

## Build

__Prerequisite__: `zephyrww` installed

In root dir of this sample application,

```bash
# build for EK RA8M1, into ./builds/ek_ra8m1
zephyrwwb -b ek_ra8m1 -z v4.1.0 .

# build for nrf52840dk/nrf52840, into ./builds/nrf52840dk_nrf52840
zephyrwwb -b nrf52840dk/nrf52840 .
```

## Test if the build is executable with Renode

Starting with Renode's [git repo](https://github.com/renode/renode) to learn Renode.

This sample contains Renode simulation scripts (.resc) (in `renode` directory) to test if the resulting build is executable.

__Run the .resc scripts in docker__

This repo also contains docker compose file for convenient. 
You can start the simulation with a single command without any change, given that you have docker installed and the host machine is linux based. 

```bash
# change dir to the renode directory of ledpattern sample
cd /path-to-zephyr-without-west/samples/ledpattern/renode

docker compose run --rm renode renode -e 'start @/ledpattern/renode/ek_ra8m1.resc'
```

__Run the resc scripts in host OS__

You can also run Renode simulation in your host machine with Renode installed, in this case, you should read the scripts and ensure every paths in them being correct. 
```bash
# check if renode installed
renode --version

# after ensuring paths in the resc scripts being correct,
# run simulation script
renode -e 'start @/path/to/your/resc'
```



## Example build logs for EK RA8M1 in Windows
```bash
PS C:\Users\tri.nguyen-huu2\embeddedc\zephyr-without-west\samples\ledpattern> zephyrwwb -b ek_ra8m1 .
Parsed arguments:
 Board: ek_ra8m1
 Zephyr Version: latest
 Build Directory: builds/ek_ra8m1
 Source Directory: .
ZEPHYR_VERSION is set to 'latest'. Retrieving latest version...
Using latest Zephyr version: v4.1.0
Zephyr installation v4.1.0 exists. Skipping installation.
Loading Zephyr default modules (Freestanding).
-- Application: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern
-- CMake version: 4.0.2
-- Found Python3: C:/Users/tri.nguyen-huu2/.zephyrww/.venv/Scripts/python.exe (found suitable version "3.12.10", minimum required is "3.10") found components: Interpreter
-- Cache files will be written to: C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/.cache
-- Zephyr version: 4.1.0 (C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr)
-- Board: ek_ra8m1, qualifiers: r7fa8m1ahecbd
-- Found host-tools: zephyr 0.17.0 (C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr-sdk)
-- Found toolchain: zephyr 0.17.0 (C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr-sdk)
-- Found Dtc: C:/Users/tri.nguyen-huu2/AppData/Local/Microsoft/WinGet/Packages/oss-winget.dtc_Microsoft.Winget.Source_8wekyb3d8bbwe/usr/bin/dtc.exe (found suitable version "1.6.1", minimum required is "1.4.6")
-- Found BOARD.dts: C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/boards/renesas/ek_ra8m1/ek_ra8m1.dts
-- Found devicetree overlay: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/boards/ek_ra8m1.overlay
-- Generated zephyr.dts: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/zephyr.dts
-- Generated pickled edt: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/edt.pickle
-- Generated devicetree_generated.h: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/include/generated/zephyr/devicetree_generated.h
-- Including generated dts.cmake file: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/dts.cmake
CMake Warning at C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/cmake/modules/dts.cmake:425 (message):
  dtc raised one or more warnings:


  C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/zephyr.dts:554.14-557.5:
  Warning (simple_bus_reg): /soc/trng: missing or empty reg/ranges property


  C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/zephyr.dts:804.14-817.5:
  Warning (simple_bus_reg): /soc/mdio: missing or empty reg/ranges property

Call Stack (most recent call first):
  C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/cmake/modules/zephyr_default.cmake:133 (include)
  C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/share/zephyr-package/cmake/ZephyrConfig.cmake:66 (include)
  C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/share/zephyr-package/cmake/ZephyrConfig.cmake:159 (include_boilerplate)
  CMakeLists.txt:3 (find_package)


Parsing C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/Kconfig
Loaded configuration 'C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr/boards/renesas/ek_ra8m1/ek_ra8m1_defconfig'
Merged configuration 'C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/prj.conf'
Configuration saved to 'C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/.config'
Kconfig header saved to 'C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/include/generated/zephyr/autoconf.h'
-- Found GnuLd: c:/users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr-sdk/arm-zephyr-eabi/arm-zephyr-eabi/bin/ld.bfd.exe (found version "2.38")
-- The C compiler identification is GNU 12.2.0
-- The CXX compiler identification is GNU 12.2.0
-- The ASM compiler identification is GNU
-- Found assembler: C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr-sdk/arm-zephyr-eabi/bin/arm-zephyr-eabi-gcc.exe
-- Using ccache: C:/Users/tri.nguyen-huu2/local/mingw64/bin/ccache.exe
-- Configuring done (64.1s)
-- Generating done (0.9s)
-- Build files have been written to: C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1
[1/129] Generating include/generated/zephyr/version.h
-- Zephyr version: 4.1.0 (C:/Users/tri.nguyen-huu2/.zephyrww/v4.1.0/zephyr), build: v4.1.0
[129/129] Linking C executable zephyr\zephyr.elf
Memory region         Used Size  Region Size  %age Used
           FLASH:       24422 B      2016 KB      1.18%
             RAM:        7336 B       896 KB      0.80%
OPTION_SETTING_OFS:          20 B         24 B     83.33%
OPTION_SETTING_SAS:           4 B        204 B      1.96%
OPTION_SETTING_S:         208 B        256 B     81.25%
        IDT_LIST:          0 GB        32 KB      0.00%
Generating files from C:/Users/tri.nguyen-huu2/embeddedc/zephyr-without-west/samples/ledpattern/builds/ek_ra8m1/zephyr/zephyr.elf for board: ek_ra8m1
Python virtual environment deactivated.
```
