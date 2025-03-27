import ipaddress
import socket
from concurrent.futures import ThreadPoolExecutor, as_completed

import nmap
import scapy.all as scapy
from flask import Flask, request, jsonify

app = Flask(__name__)
executor = ThreadPoolExecutor(
    max_workers=50)  # Increased workers for better faster execution of network scans


def passive_scan():
    """Uses ARP to identify devices"""
    try:
        return [entry[1].psrc for entry in scapy.arping("192.168.0.0/24", verbose=False)[
            0]]  # Passive ARP scan scanning entire network
    except:
        return []


def get_live_hosts(network):
    """Pings hosts and returns active ones"""
    live_hosts = set(passive_scan())

    def ping_host(ip):
        try:
            with socket.create_connection((ip, 80), timeout=1):  # Reduced timeout for faster ping
                return ip
        except:
            return None

    network = ipaddress.ip_network(network)
    futures = [executor.submit(ping_host, str(ip)) for ip in network.hosts()]
    for future in as_completed(futures):
        if result := future.result():
            live_hosts.add(result)

    return list(live_hosts)


def get_device_type(os_info):
    """Returns device type based on the OS"""
    os_info = os_info.lower()
    if "windows" in os_info or "linux" in os_info:
        return "PC/Laptop"
    if "android" in os_info:
        return "Mobile Device"
    if "ios" in os_info or "mac" in os_info:
        return "Apple Device"
    return "Unknown Device"


def analyse_open_ports(ports):
    """List of ports and their descriptions for home user's to understand"""
    port_info = {
        21: ("FTP", "High Risk", "Used for file transfers but lacks encryption."),
        22: ("SSH", "Low Risk", "Used for secure remote access."),
        25: ("SMTP", "Medium Risk", "Used to send emails, but attackers may abuse it."),
        53: ("DNS", "Low Risk", "Translates web addresses to IPs."),
        80: ("HTTP", "Medium Risk", "Handles websites but sends data without encryption."),
        443: ("HTTPS", "Safe", "Encrypted web traffic."),
        445: ("SMB", "Critical Risk", "Used for sharing files on networks."),
        3389: ("RDP", "High Risk", "Used for Remote desktop access."),
        8080: ("HTTP Proxy", "Medium Risk", "Often used for web services."),
    }

    results = [
        f"Port {port} ({port_info.get(port, ('Unknown', 'Unknown', 'No details'))[0]}) - "
        f"{port_info.get(port, ('Unknown', 'Unknown', 'No details'))[1]}. "
        f"{port_info.get(port, ('Unknown', 'Unknown', 'No details'))[2]}"
        for port in ports
    ]

    return results


def run_nmap_scan(live_hosts):
    """Runs the Nmap scan"""
    nm = nmap.PortScanner()
    nmap_args = "-T3 --min-parallelism 50 --max-retries 1 -O -sV --open"  # Nmap command used for scanning the network
    scan_results = []

    futures = {executor.submit(nm.scan, host, arguments=nmap_args): host for host in live_hosts}
    for future in as_completed(futures):
        host = futures[future]
        try:
            result = future.result()
            if host in nm.all_hosts():
                mac = nm[host].get("addresses", {}).get("mac", "Unknown MAC")
                os_info = nm[host].get("osmatch", [{}])[0].get("name", "Unknown OS")
                open_ports = list(nm[host].get("tcp", {}).keys())

                scan_results.append({
                    "ip": host,
                    "mac": mac,
                    "device_type": get_device_type(os_info),
                    "os": os_info,
                    "open_ports": analyse_open_ports(open_ports),
                })
        except Exception as e:
            print(f"Error scanning {host}: {e}")

    return scan_results


@app.route('/scan', methods=['POST'])
def scan_network():
    """Handles network scanning"""
    target = request.json.get("target", "192.168.0.1")
    try:
        live_hosts = get_live_hosts(target)
        if not live_hosts:
            return jsonify({"error": "No active devices found"}), 404
        return jsonify({"scan_result": run_nmap_scan(live_hosts)})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def run_flask_server():
    """Starts the Flask server"""
    print("Starting Flask server...")
    app.run(host='127.0.0.1', port=5000, debug=False)


if __name__ == "__main__":
    run_flask_server()
