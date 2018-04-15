from flask import Flask
from flask_bootstrap import Bootstrap

app = Flask(__name__)
app.config["BASE_URL"] = "https://dev.cute.enterprises/api/"
app.secret_key = "this should be really secret"
Bootstrap(app)

from webapp import views
