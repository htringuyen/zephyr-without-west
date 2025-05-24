#!/usr/bin/env python3
import os
import sys
import shutil
import argparse
from pathlib import Path
import subprocess

def show_usage():
    print("""
Usage: install.py [-d <ZEPHYRWW_HOME>]

Arguments:
  -d <ZEPHYRWW_HOME>      Installation directory (optional, default: $HOME/.zephyrww)
  -h, --help              Show this help message

Examples:
  python install.py
  python install.py -d /opt/zephyrww
  python install.py -d ~/my-zephyr-tools
""")

def parse_args():
    parser = argparse.ArgumentParser(add_help=False)
    parser.add_argument('-d', metavar='ZEPHYRWW_HOME', type=str, help='Installation directory')
    parser.add_argument('-h', '--help', action='store_true', help='Show help')
    args, extras = parser.parse_known_args()

    if args.help:
        show_usage()
        sys.exit(0)

    if extras:
        print(f"Error: Unexpected argument(s): {' '.join(extras)}")
        show_usage()
        sys.exit(1)

    zephyrww_home = Path(args.d).expanduser() if args.d else Path.home() / ".zephyrww"
    return zephyrww_home

def replace_dir(target_path):
    if os.path.isdir(target_path):
        shutil.rmtree(target_path)
    os.makedirs(target_path)

def main():
    installer_root = os.environ["INSTALLER_ROOT"]
    zephyrww_home = parse_args()

    print(f"Installation directory: {zephyrww_home}")
    if os.path.isdir(zephyrww_home):
        print("Warning: Intallation directory already exists")
    os.makedirs(zephyrww_home, exist_ok=True)

    # Install scripts
    scripts_dst = os.path.join(zephyrww_home, "scripts")
    if os.path.isdir(scripts_dst):
        print("Warning: Overriding existing scripts directory")
    replace_dir(scripts_dst)
    if os.name == "nt":
        shutil.copytree(os.path.join(installer_root, "scripts", "share"), scripts_dst, dirs_exist_ok=True)
        shutil.copytree(os.path.join(installer_root, "scripts", "windows"), scripts_dst, dirs_exist_ok=True)
    else:
        shutil.copytree(os.path.join(installer_root, "scripts", "share"), scripts_dst, dirs_exist_ok=True)
        shutil.copytree(os.path.join(installer_root, "scripts", "linux"), scripts_dst, dirs_exist_ok=True)

    # Install bin
    bin_dst = os.path.join(zephyrww_home, "bin")
    if os.path.isdir(bin_dst):
        print("Warning: Overriding existing bin directory")
    replace_dir(bin_dst)
    if os.name == "nt":
        shutil.copytree(os.path.join(installer_root, "bin", "windows"), bin_dst, dirs_exist_ok=True)
    else:
        shutil.copytree(os.path.join(installer_root, "bin", "linux"), bin_dst, dirs_exist_ok=True)

    # Install Python virtual environment
    venv_path = os.path.join(zephyrww_home, ".venv")
    if not os.path.isdir(venv_path):
        # print(f"Creating virtual environment in {venv_path}...")
        subprocess.check_call([sys.executable, "-m", "venv", str(venv_path)])
    else:
        print(f"Warning: Virtual environment already exists at {venv_path}, skipping creation.")

if __name__ == "__main__":
    main()
