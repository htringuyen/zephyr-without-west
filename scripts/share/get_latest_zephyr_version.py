import urllib.request
import urllib.error
import json

def get_latest_zephyr_version() -> str:
    try:
        # GitHub API endpoint for Zephyr releases
        url = "https://api.github.com/repos/zephyrproject-rtos/zephyr/releases/latest"
                
        # Create request with user agent (GitHub API requires it)
        req = urllib.request.Request(url)
        req.add_header('User-Agent', 'Python-urllib/3.x')
        
        # Make the request
        with urllib.request.urlopen(req, timeout=10) as response:
            if response.status != 200:
                raise Exception(f"HTTP {response.status}: {response.reason}")
            
            # Parse JSON response
            data = json.loads(response.read().decode('utf-8'))
            
        tag_name = data.get('tag_name')
        
        if tag_name and tag_name.startswith('v'):
            return tag_name
        else:
            raise Exception(f"Unexpected tag format: {tag_name}")
            
    except urllib.error.HTTPError as e:
        raise Exception(f"HTTP error fetching latest version: {e.code} {e.reason}")
    except urllib.error.URLError as e:
        raise Exception(f"Network error fetching latest version: {e.reason}")
    except json.JSONDecodeError as e:
        raise Exception(f"Error parsing GitHub response JSON: {e}")
    except Exception as e:
        if "Unexpected tag format" in str(e):
            raise e
        raise Exception(f"Error fetching latest version: {e}")

def main():
    print(get_latest_zephyr_version())

if __name__ == "__main__":
    main()