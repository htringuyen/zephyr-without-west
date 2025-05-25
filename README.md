# Zephyr without West

A CLI tool that build zephyr applications without using west.

## Usage
### Build options
<pre>
Usage: zephyrwwb -b &lt;board&gt; [-z &lt;zephyr-version&gt;] [-d &lt;build-dir&gt;] &lt;source-dir&gt;

Arguments:
  -b &lt;board&gt;              Board name (required)
  -z &lt;zephyr-version&gt;     Zephyr version (optional, default: latest)
  -d &lt;build-dir&gt;          Build directory (optional, default: builds/&lt;board&gt;)
  -h, --help              Show this help message
  &lt;source-dir&gt;            Source directory (required)

Examples:
  zephyrwwb -b nrf52840dk_nrf52840 ./my-project
  zephyrwwb -b esp32 -z v3.4.0 -d custom-build ./src
  zephyrwwb -z v1.0.1 -b nrf52840dk/nrf52840 .
</pre>

### Example usage
This tool requires a cmake file in root of the application project as an entry point to Zephyr build system. And that is all, the application should be built without issues as long as its codes done right and no special customization to Zephyr build system needed.

__Built project has a CMakeList.txt at its root__

The function `find_package()` is the entry point to Zephyr build system. The enviroment variable `ZEPHYR_ENTRY_POINT` will be set automatically by this tool based on the specified zephyr version in build command.

```cmake
# CMakeList.txt

cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED
    PATHS $ENV{ZEPHYR_ENTRY_POINT}
    NO_DEFAULT_PATH
)

project(ledpattern)
target_sources(app PRIVATE src/main.c)
```

__Run a single command to build__

```bash
# For example, build for EK RA8M1 with zephyr version 4.1.0.
# This will be built into project-root/builds/ra_ek8m1
zeyphyrwwb -b ek_ra8m1 -z v4.1.0 /path/to/project/root
```

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
