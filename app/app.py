from flask import Flask
import os

app = Flask(__name__)

VERSION = os.environ.get("APP_VERSION", "v1")

@app.route("/")
def home():
    return f"CI/CD Pipeline is LIVE 🚀 — Version {VERSION}"

@app.route("/health")
def health():
    return {"status": "ok", "version": VERSION}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)