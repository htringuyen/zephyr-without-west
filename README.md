# Zephyr without West

A CLI tool that build zephyr applications without using west.

## Usage
### zephyrwwb: build regular zephyr app
<pre>
Usage: zephyrwwb -b &lt;board&gt; [-z &lt;zephyr-version&gt;] [-d &lt;build-dir&gt;] &lt;source-dir&gt;

Arguments:
  -b &lt;board&gt;              Board name (required)
  -z &lt;zephyr-version&gt;     Zephyr version (optional, default: latest)
  -d &lt;build-dir&gt;          Build directory (optional, default: builds/&lt;board&gt;)
  -h, --help                    Show this help message
  &lt;source-dir&gt;            Source directory (required)

Examples:
  zephyrwwb -b nrf52840dk_nrf52840 ./my-project
  zephyrwwb -b esp32 -z v3.4.0 -d custom-build ./src
  zephyrwwb -z v1.0.1 -b nrf52840dk/nrf52840 .
</pre>

### twisterw: build and run compact unit test, as well as regular integration test
This tool incorporates Zephyr's [twister](https://github.com/htringuyen/zephyr/tree/main/scripts/pylib/twister) and [ztest-build-ext](https://github.com/htringuyen/ztest-build-ext), and a downstream [fork of Zephyr](https://github.com/htringuyen/zephyr). It keep all features from twister but with enhancement in unit test and module loading.
<pre>
Usage: twisterw [--ut] @regular-twister-arguments

Arguments:
  --ut                          Build and run unit test using ztest-build-ext, this help reduce build time and ease dependency inclusions
  @regular-twister-arguments    This argument will be thrown back to twister, so it is the same as when you use twister
  --help                        Get help message from twister, use as reference to construct @regular-twister-arguments
</pre>


### Example usages for `zephyrwwb`
This tool requires a cmake file in root of the application project as an entry point to Zephyr build system. And that is all, the application should be built without issues as long as its codes done right and no special customization to Zephyr build system needed.

__Built project has a CMakeList.txt at its root__

The function `find_package()` is the entry point to Zephyr build system. The enviroment variable `ZEPHYR_ENTRY_POINT` will be set automatically by this tool based on the specified zephyr version in build command.

```cmake
# CMakeList.txt

cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED $ENV{ZEPHYR_BASE})

project(zephyr_app)
target_sources(app PRIVATE src/main.c)
```

__Run a single command to build__

```bash
# For example, build for EK RA8M1 with zephyr version 4.1.0.
# This will be built into project-root/builds/ra_ek8m1
zeyphyrwwb -b ek_ra8m1 -z v4.1.0_m1 /path/to/project/root
```

### Example usages for `twisterw`
Please view test applications in [ztest-build-ext/tests](https://github.com/htringuyen/ztest-build-ext/tree/main/tests) for the usage examples. 

The naming conventions of the test application is as follows: [app_id]-[app_name]\_[testing_type]\_[testing_way]. Where:
- `app_id`: e.g. 01, 02, etc. Apps with the same id share the same logic (usually the same source)
- `app_name`: descriptive name of the app, apps with the same id have the same `app_name`
- `testing_type`: `ut` for unit test or `it` for integration test
- `testing_way`: `ext` if using `ztest-build-ext`, `def` if using default twiter build and run way.

## Sample applications
Sample applications can be found in `samples` directory, two recommended samples to look at for getting started with Zephyr:

- `template`: recommends a project structure that is compatible with Zephyr build system. And also contains explainations and reference links.

- `ledpattern`: a sample application with leds and buttons. It can be built immediately using `zephyrwwb` for `ek_ra8m1` and `nrf52840dk/nrf52840` boars.

## Installation

### Ubuntu

#### Prerequisite:

Common tools are required such as cmake, git, device-tree-compiler, etc. All of them can be install with the below command:

```bash
wget https://apt.kitware.com/kitware-archive.sh \
sudo bash kitware-archive.sh \
sudo apt install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
```

#### Installing

In root of this repo,

```bash
# this will install zephyrww to $HOME/.zephyrww
./install.sh
```

or

```bash
# explicitly specify an installation directory
./install.sh -d <path/to/installation/dir>
```

#### Post configuration

Add the Zephyrww's bin directory to `PATH`

```bash
# .bashrc
# Default zephyrww installation dir is $HOME/.zephyrww 
export PATH="/path/to/zephyrww/install/dir:$PATH"
```

### Windows

#### Prerequisite

Common tools are required such as cmake, git, device-tree-compiler, etc. All of them can be install with the below command:

```powershell
winget install Kitware.CMake Ninja-build.Ninja oss-winget.gperf python Git.Git oss-winget.dtc wget 7zip.7zip
```
#### Installing

In root of this repo,

```powershell
# this will install zephyrww to $HOME/.zephyrww
./install.ps1
```

or

```powershell
# explicitly specify an installation directory
./install.ps1 -d <path/to/installation/dir>
```

#### Post configuration

Add the Zephyrww's bin directory to `PATH`

```powershell
# Default installation dir is $USERPROFILE\.zephyrww
$env:PATH = "$env:\path\to\zephyrww\install\dir;$env:PATH"
```
