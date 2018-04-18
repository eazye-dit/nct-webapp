from webapp import app
from flask import render_template, send_from_directory, request, url_for, redirect, flash
import requests as r

@app.route('/')
def index():
    if 'session' in request.cookies:
        roles = call_api('whoami')["roles"]
        if "Administrator" in roles:
            appointments = call_api("admin/appointments")
            return render_template('admin/index.tpl', appointments=appointments)
        elif "Mechanic" in roles:
            appointments = call_api("mechanic/appointments")
            return render_template('mechanic/index.tpl', appointments=appointments)
    return render_template('login.tpl')

@app.route('/login/', methods=["POST"])
def login():
    session = r.Session()
    payload = {
        "username": request.form.get("username"),
        "password": request.form.get("password")
    }

    resp = session.post(app.config["BASE_URL"] + "login/", data=payload)

    if resp.status_code == 200:
        redir = redirect(url_for('index'))
        response = app.make_response(redir)
        response.set_cookie('session', value=session.cookies["session"])
        return response
    elif resp.status_code == 400:
        flash("Login failed")
        return redirect(url_for('index'))

@app.route('/logout/')
def logout():
    response = app.make_response(redirect(url_for('index')))
    response.set_cookie('session', expires=0)
    return response

@app.route('/res/<path:path>')
def send_css(path):
    a = 0
    return send_from_directory('resources', path)

def call_api(url):
    url += "/"
    session = r.Session()
    if 'session' in request.cookies:
        session.cookies["session"] = request.cookies["session"]
    else:
        return False
    resp = session.get(app.config["BASE_URL"] + url)
    return resp.json()
