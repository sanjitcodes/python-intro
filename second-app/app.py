from flask import Flask, render_template

app = Flask(__name__)

@app.route("/")
def index():
    headline = "Yo Welcome.."
    return render_template("index.html", headline=headline)

@app.route("/bye")
def bye():
    headline = "Khatam, bye bye, Tata, Goodbye, gaya :D"
    return render_template("index.html", headline = headline) 
