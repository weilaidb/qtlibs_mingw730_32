import sys
sys.path.append('/usr/local/lib/python3.6/site-packages')

from flask import Flask
import vsearch
# from vsearch import search4letters

app = Flask(__name__)


@app.route('/')
def hello() -> str:
    return 'Hello world from Flask!'


@app.route('/search4')
def do_search() -> str:
    return str(search4letters('life, the universe, and everything', 'eiru,!'))


app.run(host="0.0.0.0",port=8080)
