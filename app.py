import logging, os, subprocess
from flask import Flask, request, abort

app = Flask(__name__)


if __name__ != '__main__':
    gunicorn_logger = logging.getLogger('gunicorn.error')
    app.logger.handlers = gunicorn_logger.handlers
    app.logger.setLevel(gunicorn_logger.level)

@app.route("/", methods=["GET"])
def root():
    app.logger.info("Get request / recieved.")
    return "Endpoints /start, /stop, /update_config supported."

@app.route("/start", methods=["POST", "GET"])
def start():
    data = request.json
    app.logger.info("POST request /start recieved with data: %s",  data)
    operation = "start"
    cluster = data["cluster"]
    region = data["region"]
    path = os.path.join(app.root_path, "workstations.sh")
    o = subprocess.run(
        [path, operation, cluster, region], 
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    app.logger.info("Sending response: %s", o.stdout)
    return o.stdout

@app.route("/stop", methods=["POST", "GET"])
def stop():
    data = request.json
    operation = "stop"
    cluster =  data["cluster"]
    region = data["region"]
    path = os.path.join(app.root_path, "workstations.sh")
    o = subprocess.run(
        [path, operation, cluster, region], 
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    return o.stdout


@app.route("/update_config", methods=["POST", "GET"])
def update_config():
    data = request.json
    cluster =  data["cluster"]
    region = data["region"]
    config_key = data["config_key"]
    value =  data["value"]
    path = os.path.join(app.root_path, "update_config.sh")
    o = subprocess.run(
        [path, cluster, region, config_key, value ], 
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True
    )
    return o.stdout

if __name__ == "__main__":
    app.run(
        debug=True,
        host="0.0.0.0", 
        port=int(os.environ.get("PORT", 8080))
    )
