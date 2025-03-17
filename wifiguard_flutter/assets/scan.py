import ipaddress
import nmap
import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)


def ping_host(ip):
    """
    Pings a given IP address to check if it's up.
    Returns True if the host is up, False otherwise.
    """
    try:
        # Ping the host (send 1 packet, wait 1 second)
        response = subprocess.run(
            ['ping', '-c', '1', '-W', '1', ip],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE
        )
        return response.returncode == 0
    except Exception as e:
        print(f"Error pinging {ip}: {e}")
        return False


def get_live_hosts(network):
    """
    Scans a given network for live hosts by pinging each IP in the range.
    """
    live_hosts = []
    # Get the list of all possible IPs in the given network
    network = ipaddress.ip_network(network)
    for ip in network.hosts():
        if ping_host(str(ip)):
            live_hosts.append(str(ip))
    return live_hosts


def get_device_type(os_info):
    """
    Determines the device type based on OS information.
    """
    if 'Windows' in os_info:
        return 'PC/Laptop'
    elif 'Linux' in os_info:
        return 'PC/Laptop'
    elif 'Android' in os_info:
        return 'Mobile Device'
    elif 'iOS' in os_info or 'Mac' in os_info:
        return 'Apple Device'
    else:
        return 'Unknown Device'


def run_nmap_scan(live_hosts):
    """
    Runs an Nmap scan on the list of live hosts and extracts device type, OS, and service details.
    """
    nm = nmap.PortScanner()
    scan_results = []

    for host in live_hosts:
        print(f"Scanning {host}...")
        try:
            nm.scan(hosts=host, arguments="-O -sV --open")  # `-sV` gets service info

            if host in nm.all_hosts():
                mac_address = nm[host]['addresses'].get('mac', "Unknown MAC")
                device_type = "Unknown Device"
                os_info = "Unknown OS"
                open_ports = []

                # Extract device type from OS class
                if 'osclass' in nm[host] and nm[host]['osclass']:
                    device_type = nm[host]['osclass'][0].get('type', 'Unknown Device')

                # Extract OS details
                if 'osmatch' in nm[host] and nm[host]['osmatch']:
                    os_info = nm[host]['osmatch'][0]['name']

                # Get open ports
                if 'tcp' in nm[host]:
                    open_ports = list(nm[host]['tcp'].keys())

                # Store all details
                scan_results.append({
                    "ip": host,
                    "mac": mac_address,
                    "device_type": device_type,
                    "os": os_info,
                    "open_ports": open_ports if open_ports else "No open ports"
                })

        except Exception as e:
            print(f"Error scanning {host}: {e}")

    return scan_results


@app.route('/scan', methods=['POST'])
def scan_network():
    data = request.json
    # Default scan target (Currently just the router for sorting out frontend for faster scanning)
    target = data.get('target', '192.168.0.1')
    device_filter = data.get('filter', None)  # Optional filter for device type

    # Check if nmap is installed and available
    nmap_check = subprocess.run(["which", "nmap"], capture_output=True, text=True)
    if nmap_check.returncode != 0:
        return jsonify({"error": "nmap is not installed or available on this system."}), 500

    try:
        print(f"Scanning the network {target} for live hosts...")
        live_hosts = get_live_hosts(target)

        if not live_hosts:
            return jsonify({"error": "No live hosts found in the specified network."}), 404

        print("Running Nmap scan on live hosts...")
        scan_results = run_nmap_scan(live_hosts)

        if device_filter:
            scan_results = [device for device in scan_results if
                            device['device_type'] == device_filter]

        return jsonify({"scan_result": scan_results})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def run_flask_server():
    # Starts the Flask server
    print("Starting Flask server...")
    app.run(host='127.0.0.1', port=5000, debug=False)


# Run the server if this script is executed directly
if __name__ == "__main__":
    run_flask_server()
