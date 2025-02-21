import subprocess

from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/scan', methods=['POST'])
def scan_network():
    data = request.json
    target = data.get('target', '192.168.0.1')  # Default scan target for now to test integration

    # Check if nmap is available
    nmap_check = subprocess.run(["which", "nmap"], capture_output=True, text=True)
    if nmap_check.returncode != 0:
        return jsonify({"error": "nmap is not installed or available on this system."}), 500

    try:
        # Running the nmap scan
        result = subprocess.run(["nmap", "-sn", target], capture_output=True, text=True)
        if result.returncode != 0:
            return jsonify({"error": "nmap scan failed.", "details": result.stderr}), 500
        return jsonify({"scan_result": result.stdout})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


def run_flask_server():
    print("Starting Flask server on Android...")
    app.run(host='127.0.0.1', port=5000, debug=False)


# Ensure this function is accessible from Chaquopy
if __name__ == "__main__":
    run_flask_server()
