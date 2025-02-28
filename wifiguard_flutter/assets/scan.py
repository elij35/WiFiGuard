import ipaddress
import subprocess

import nmap
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


def run_nmap_scan(live_hosts):
    """
    Runs an Nmap scan on the list of live hosts and extracts important details.
    """
    nm = nmap.PortScanner()
    scan_results = []

    for host in live_hosts:
        print(f"Scanning {host}...")
        try:
            nm.scan(hosts=host, arguments="-O --open")
            if host in nm.all_hosts():
                mac_address = None
                open_ports = []

                # Get MAC address if available
                if 'addresses' in nm[host] and 'mac' in nm[host]['addresses']:
                    mac_address = nm[host]['addresses']['mac']

                # Get open ports
                if 'tcp' in nm[host]:
                    open_ports = list(nm[host]['tcp'].keys())

                # Get OS information (if detected)
                os_info = "Unknown OS"
                if 'osmatch' in nm[host] and nm[host]['osmatch']:
                    os_info = nm[host]['osmatch'][0]['name']

                # Store only important details
                scan_results.append({
                    "ip": host,
                    "mac": mac_address if mac_address else "Unknown MAC",
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

    # Check if nmap is installed and available
    nmap_check = subprocess.run(["which", "nmap"], capture_output=True, text=True)
    if nmap_check.returncode != 0:
        return jsonify({"error": "nmap is not installed or available on this system."}), 500

    try:
        # Step 1: Find live hosts by pinging the network
        print(f"Scanning the network {target} for live hosts...")
        live_hosts = get_live_hosts(target)

        if not live_hosts:
            return jsonify({"error": "No live hosts found in the specified network."}), 404

        # Step 2: Run Nmap scan on live hosts
        print("Running Nmap scan on live hosts...")
        scan_results = run_nmap_scan(live_hosts)

        return jsonify({"scan_result": scan_results})  # Return the scan results for all live hosts

    except Exception as e:
        return jsonify({"error": str(e)}), 500


def run_flask_server():
    # Starts the Flask server
    print("Starting Flask server...")
    app.run(host='127.0.0.1', port=5000, debug=False)


# Run the server if this script is executed directly
if __name__ == "__main__":
    run_flask_server()
