import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    # Demonstrating we can read infrastructure-injected variables
    env_name = os.environ.get('APP_ENV', 'Development')
    db_host = os.environ.get('DB_HOST', 'Not Connected')
    
    html = f"""
    <html>
        <head><title>CSG Innovation Team - Demo</title></head>
        <body style="font-family: sans-serif; text-align: center; margin-top: 50px;">
            <h1>Hello, PagerDuty!</h1>
            <p>This application is running in the <strong>{env_name}</strong> environment.</p>
            <p>Database Endpoint: <code>{db_host}</code></p>
            <hr>
            <p>Resource Tag: <b>csgtest</b></p>
        </body>
    </html>
    """
    return html

if __name__ == "__main__":
    # Standard port for web containers
    app.run(host='0.0.0.0', port=80)
