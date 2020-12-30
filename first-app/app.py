from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello World!"

@app.route("/home")
def naya():
    return "Aa gaye idhar?.."

@app.route("/<string:name>")
def hello(name):
    #capitalize the name.. sanjit => Sanjit
    name = name.capitalize()
    return f"<h1>Hello {name}</h1>"
