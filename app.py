from flask import Flask
app = Flask(name)

@app.route("/")
def index():
    return "<h1>Shruti Shinde</h1>"
if _name_ == 'main':
    app.run(host='0.0.0.0', port=5000,deburg=True)