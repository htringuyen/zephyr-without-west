# Template for applications
This sample recommends a project strucutre that is compatible with Zephyr build system and easy to start.

## Project strucutre

<pre>
[application-root]
    ├── boards
    ├── builds
    ├── CMakeLists.txt
    ├── prj.conf
    ├── renode
    ├── socs
    └── src
        └── main.c
</pre>

Explaination of the directories/files in the above template:
- `src`: contains source code of the application, it contains the file `main.c` as a bootstrap file specified by in `CMakeLists.txt`.

- `CMakeLists.txt`: top level cmake file, it is an entry point to zephyr build system.

- `prj.conf`: the KConfig file that Zephyr will look into by default. More details in: [The initial Configuration](https://docs.zephyrproject.org/latest/build/kconfig/setting.html#initial-conf).

-   [optional] `boards` and `socs`: are places to put device tree overlays. Zephyr build system will look to those places to find overlays files. More details in: [Set devicetree overlays](https://docs.zephyrproject.org/latest/build/dts/howtos.html#set-devicetree-overlays).

- `builds`: the build dirs will be placed in this dir, a zephyr application may have multiple builds, e.g. for different boards (`builds/ek_ra8m1`, `builds/nrf52840dk_nrf52840`).

- [optional] `renode`: the directory contains renode simulation files for testing. The topic about `renode` will be placed in another document.
