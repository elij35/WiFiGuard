from flask import Flask, request, jsonify
import subprocess

app = Flask(__name__)


@app.route('/scan', methods=['POST'])
def scan_network():
    data = request.json
    target = data.get('target', '192.168.0.1')  # Default scan target

    try:
        result = subprocess.run(["nmap", "-sn", target], capture_output=True, text=True)
        return jsonify({"scan_result": result.stdout})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
