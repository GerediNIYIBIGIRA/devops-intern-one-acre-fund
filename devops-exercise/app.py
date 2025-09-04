from flask import Flask, jsonify, request
import psutil
import datetime
import os
import socket

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify({
        'message': 'Hello DevOps! - Flask Application Running Successfully',
        'timestamp': datetime.datetime.now().isoformat(),
        'status': 'healthy',
        'version': '1.0.0',
        'environment': os.environ.get('FLASK_ENV', 'development')
    })

@app.route('/health')
def health():
    try:
        memory_info = psutil.virtual_memory()
        disk_info = psutil.disk_usage('/')
        
        return jsonify({
            'status': 'healthy',
            'timestamp': datetime.datetime.now().isoformat(),
            'system_info': {
                'hostname': socket.gethostname(),
                'memory_usage_percent': memory_info.percent,
                'memory_available_gb': round(memory_info.available / (1024**3), 2),
                'disk_usage_percent': disk_info.percent,
                'cpu_usage_percent': psutil.cpu_percent(interval=1),
                'load_average': os.getloadavg() if hasattr(os, 'getloadavg') else 'N/A'
            }
        })
    except Exception as e:
        return jsonify({
            'status': 'unhealthy',
            'error': str(e),
            'timestamp': datetime.datetime.now().isoformat()
        }), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
