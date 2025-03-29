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

    # PC/Laptop checks
    pc_keywords = [
        'windows', 'linux', 'ubuntu', 'debian', 'fedora',
        'centos', 'macos', 'mac os', 'microsoft', 'pc',
        'desktop', 'notebook', 'laptop', 'thinkpad', 'surface'
    ]
    if any(keyword in os_info for keyword in pc_keywords):
        return "PC/Laptop"

    # Mobile Device checks
    mobile_keywords = [
        'android', 'mobile', 'phone', 'tablet', 'galaxy',
        'redmi', 'pixel', 'oneplus', 'xiaomi', 'nokia',
        'oppo', 'vivo', 'realme', 'huawei', 'honor',
        'poco', 'motorola', 'lg', 'sony', 'htc'
    ]
    if any(keyword in os_info for keyword in mobile_keywords):
        return "Mobile Device"

    # Apple Device checks
    apple_keywords = [
        'ios', 'mac', 'iphone', 'ipad', 'apple', 'imac',
        'macbook', 'airpod', 'apple tv', 'ipod', 'watchos'
    ]
    if any(keyword in os_info for keyword in apple_keywords):
        return "Apple Device"

    # Router checks
    router_keywords = [
        'router', 'modem', 'access point', 'ap', 'cisco',
        'tplink', 'netgear', 'asus', 'linksys', 'fritzbox',
        'd-link', 'ubiquiti', 'mikrotik'
    ]
    if any(keyword in os_info for keyword in router_keywords):
        return "Router"

    # IoT Device checks
    iot_keywords = [
        'iot', 'smart', 'echo', 'google home', 'nest',
        'thermostat', 'camera', 'ring', 'alexa', 'printer',
        'scanner', 'smart tv', 'roku', 'fire tv', 'chromecast',
        'philips hue', 'smart bulb', 'smart plug'
    ]
    if any(keyword in os_info for keyword in iot_keywords):
        return "IoT Device"

    # Gaming Console checks
    gaming_keywords = [
        'playstation', 'xbox', 'nintendo', 'switch', 'ps5',
        'ps4', 'xbox one', 'xbox series', 'wii', 'playstation vita'
    ]
    if any(keyword in os_info for keyword in gaming_keywords):
        return "Gaming Console"

    return "Unknown Device"

def analyse_open_ports(ports):
    """List of common ports and their protocol name"""
    port_info = {
        21: "FTP",
        22: "SSH",
        25: "SMTP",
        53: "DNS",
        80: "HTTP",
        443: "HTTPS",
        135: "RPC",
        139: "NetBIOS",
        445: "SMB",
        3389: "RDP",
        8080: "HTTP Proxy",
    }

    results = []
    for port in ports:
        if port in port_info:
            name = port_info[port]
            results.append(f"Port {port}: {name}")
        else:
            results.append(f"Port {port}: Unknown")

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


@app.route('/alive')
def health_check():
    """Endpoint for server health checks"""
    return jsonify({"status": "alive", "service": "WiFiGuard Scanner"}), 200


def run_flask_server():
    """Starts the Flask server"""
    print("Starting Flask server...")
    app.run(host='127.0.0.1', port=5000, debug=False)


if __name__ == "__main__":
    run_flask_server()
