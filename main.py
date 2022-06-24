from flask import Flask
from route.app import results_app

project = Flask("JNTUA")

project.register_blueprint(results_app, url_prefix="/covid")


if __name__ == "__main__":
    # Thread(target=start_worker, daemon=True).start()
    project.run(host="0.0.0.0", port=8000, debug=True)
