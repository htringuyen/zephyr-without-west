# Zephyr without West

A CLI tool that build zephyr applications without using west.

## Usage
### Command line options
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

### Required entry point cmake
This tool requires a cmake file in root of the application project as an entry point to Zephyr build system. And that is all, the application should be built without issues as long as its codes done right and no special customization to Zephyr build system needed.

```cmake
# CMakeList.txt

cmake_minimum_required(VERSION 3.20.0)

# required cmake call
find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_DIR})

project(template-app)
target_sources(app PRIVATE src/main.c)
```

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
</pre>
```

#### Installing

In root of this repo,

```bash
# this will install zephyrww to $HOME/.zephyrww
./install.sh
```

or

```bash
# you can explicitly specify an installation directory
./install.sh -d <path/to/installation/dir>
```

#### Post configuration

Add the Zephyrww bin directory to `PATH`
```bash
# .bashrc
export ZEPHYRWW_HOME="$HOME/.zephyrww"
export PATH="$ZEPHYRWW_HOME/bin:$PATH"
```

## Sample applications
Sample applications can be found in `samples` directory, two recommended samples to look at for getting started with Zephyr:

- `template`: recommends a project structure that is compatible with Zephyr build system. And also contains explainations and reference links.

- `ledpattern`: a sample application with led and button. It has instructions for building the app with zephyrww.
