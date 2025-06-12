import subprocess
import shlex
import os
import argparse
import shutil

def run_zephyr_install(zephyr_home, version, zephyr_sdk, west_conf):
    """
    Cross-platform Zephyr installation using Python instead of shell scripts
    """
    try:
        # Create directory (cross-platform)
        os.makedirs(zephyr_home, exist_ok=True)
        
        # Change to directory
        original_cwd = os.getcwd()
        os.chdir(zephyr_home)
        
        print(f"Installing Zephyr in: {zephyr_home}")
        
        # Install west
        print("Installing west...")
        subprocess.run(["pip", "install", "west"], check=True)
        
        # West init
        print("Initializing west workspace...")
        subprocess.run([
            "west", "init", "-m", 
            "https://github.com/htringuyen/zephyr.git", 
            "--mr", version, "."
        ], check=True)
        
        # West update
        print("Updating west...")
        subprocess.run(["west", "update"], check=True)
        
        # Install packages
        print("Installing west packages...")
        subprocess.run(["west", "packages", "pip", "--install"], check=True)
        
        # Install SDK
        print("Installing Zephyr SDK...")
        subprocess.run(["west", "sdk", "install", "--install-dir", zephyr_sdk], check=True)
        
        # Uninstall west
        print("Uninstalling west...")
        subprocess.run(["pip", "uninstall", "west", "-y"], check=True)
        
        # Remove west config (cross-platform)
        print("Cleaning up west config...")
        if os.path.exists(west_conf):
            if os.path.isdir(west_conf):
                shutil.rmtree(west_conf)
            else:
                os.remove(west_conf)
                
    except subprocess.CalledProcessError as e:
        print(f"Command failed with return code {e.returncode}")
        print(f"Command: {e.cmd}")
    except Exception as e:
        print(f"Installation failed: {e}")
    finally:
        # Restore original directory
        os.chdir(original_cwd)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--zephyr-version", required=True, help="Version of Zephyr to install")
    args = parser.parse_args()

    zephyrww_home = os.environ["ZEPHYRWW_HOME"];

    zephyr_version = args.zephyr_version

    if not zephyr_version.startswith("v"):
        raise ValueError("Zephyr version must start with letter v")
    
    zephyr_home = os.path.join(zephyrww_home, zephyr_version)
    if os.path.isdir(zephyr_home):
        print(f"Zephyr installation {zephyr_version} exists. Skipping installation.")
        return
    
    print(f"Zephyr installation for version {zephyr_version} does not exists.")
    print(f"Installing Zephyr version {zephyr_version}.")

    zephyr_sdk = os.path.join(zephyr_home, "zephyr-sdk")
    west_conf = os.path.join(zephyr_home, ".west")

    run_zephyr_install(zephyr_home, zephyr_version, zephyr_sdk, west_conf)

    print(f"Successfully insalled Zephyr version {zephyr_version}.")

if __name__ == "__main__":
    main()