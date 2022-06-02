
from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello() -> str:
    return 'Hello world from Flask!!!!!!!!!!'


app.run(host="0.0.0.0",port=8080)
