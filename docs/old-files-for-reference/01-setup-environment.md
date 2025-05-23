# Setup enviroment

## Step 1: Install OS-wide dependencies

### What to do ?

-   Install dependencies such as `python`, `cmake`, `device-tree-compiler`, etc.

### How to do ?

Details in: [Zephyr's guide # install-dependencies](https://docs.zephyrproject.org/latest/develop/getting_started/index.html#install-dependencies)

#### For ubuntu

<pre>
wget https://apt.kitware.com/kitware-archive.sh \
sudo bash kitware-archive.sh \
sudo apt install --no-install-recommends git cmake ninja-build gperf \
  ccache dfu-util device-tree-compiler wget \
  python3-dev python3-pip python3-setuptools python3-tk python3-wheel xz-utils file \
  make gcc gcc-multilib g++-multilib libsdl2-dev libmagic1
</pre>

#### For windows
<pre>
# prerequisite: winget already installed
winget install Kitware.CMake Ninja-build.Ninja oss-winget.gperf python Git.Git oss-winget.dtc wget 7zip.7zip
</pre>


## Step 2: Create python enviroment for this repo

### What to do ?

-   Create an isolated python virtual environment for this repo. All data related to the virtual environment will be placed in `.venv` directory, which contains python packages, etc. Later, we can clean up the environment as easily as delete the `.venv` directory.

-   Activate the enviroment for accessing packages/libs inside it

### How to do ?

Reference: [Zephyr's guide # install-python-dependencies](https://docs.zephyrproject.org/latest/develop/getting_started/index.html#get-zephyr-and-install-python-dependencies)

#### For ubuntu
<pre>
# install python3-venv if not exist
sudo apt install python3-venv

# create a virtual enviroment managing packaged isolatedly
python3 -m venv ./.venv

# activate the enviroment
source ./.venv/bin/activate
</pre>

#### For windows (powershell)
<pre>
# create a virtual enviroment managing packaged isolatedly
python -m venv .\.venv

# activate the enviroment
.\.venv\Scripts\Activate.ps1
</pre>

## Step 3: Download zephyr libraries and toolchains

### What to do ?

-   Download all dependencies of Zephyr build system (libs, toolchains, etc) into a directory, in this case, the directory `./packages`.

### How to do ?

Install and use `west` as a mean to download the required dependencies then uninstall it.

__Important__: we must uninstall `west` after the work done, otherwise zephyr build system will detect `west` and that may cause to unexpected behaviors.

#### For ubuntu
<pre>
# create a direcotry containing zephyr's dependencies
mkdir ./packages

export DEPS_HOME="./packages"

# use `west` as a mean to achieve our goal
pip install west

# run a series of  west command to download dependecies
west init . \
west update \
west packages pip --install \
west sdk install --install-dir $DEPS_HOME

# everything done, uninstall west
pip uninstall west
</pre>

#### For windows
<pre>
# Create a directory containing Zephyr's dependencies
mkdir .\packages

# Set the DEPS_HOME environment variable
$env:DEPS_HOME = ".\packages"

# Use 'west' as a means to achieve our goal
pip install west

# Run a series of west commands to download dependencies
west init .
west update
west packages pip --install
west sdk install --install-dir $env:DEPS_HOME

# Everything done, uninstall west
pip uninstall west
</pre>

