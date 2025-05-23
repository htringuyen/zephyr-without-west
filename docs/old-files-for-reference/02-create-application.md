# Create application

As an example of creating application in the setup environment, this document will create an application named `ledpattern` that has two LEDs and one button controlling the blink frequencies of the LEDs.

For convenient, we will place the application right at the root of this repo, i.e. `./ledpattern`. However, with some adjustments, we can basically place the application anywhere we want.

## Step 1: Create an empty application following a template

### What to do ?

-   Create a template for the application we will build later.

### How to do ?

#### The created application will follow the below directory structure:

<pre>
[repo-root]
└── ledpattern
    ├── boards
    ├── builds
    ├── build.sh
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

- `builds`: the build dirs will be placed in this dir, a zephyr application may have multiple builds, e.g. for different boards (`builds/ek_ra8m1`, `builds/nrf52840dk`).

- [optional] `build.sh`: this is a convenient build script, we can create other build scripts with different names or even manually build line by line within CLI.

- [optional] `renode`: the directory contains renode simulation files for testing. The topic about `renode` will be placed in another document.
