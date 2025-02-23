import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)


@app.route('/scan', methods=['POST'])
def scan_network():
    # Handles incoming scan requests and executes an nmap scan.
    data = request.json
    target = data.get('target', '192.168.0.1')  # Default scan target

    # Check if nmap is installed and available
    nmap_check = subprocess.run(["which", "nmap"], capture_output=True, text=True)
    if nmap_check.returncode != 0:
        return jsonify({"error": "nmap is not installed or available on this system."}), 500

    try:
        # Run nmap scan in ping mode (-sn)
        result = subprocess.run(["nmap", "-sn", target], capture_output=True, text=True)
        if result.returncode != 0:
            return jsonify({"error": "nmap scan failed.", "details": result.stderr}), 500

        return jsonify({"scan_result": result.stdout})  # Return scan results
    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Return error if any


def run_flask_server():
    # Starts the Flask server on Android.
    print("Starting Flask server on Android...")
    app.run(host='127.0.0.1', port=5000, debug=False)


# Run the server if this script is executed directly
if __name__ == "__main__":
    run_flask_server()
