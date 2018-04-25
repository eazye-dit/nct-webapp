from webapp import app
from flask import render_template, send_from_directory, request, url_for, redirect, flash
import requests as r

def check_user():
    if 'session' in request.cookies:
        roles = call_api('whoami')["roles"]
        if "Administrator" in roles:
            return "admin"
        elif "Mechanic" in roles:
            return "mechanic"
    return False

@app.route('/')
def index():
    check = check_user()
    if check:
       appointments = call_api("{}/appointments".format(check))
       return render_template('{}/index.tpl'.format(check), appointments=appointments)
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

@app.route('/appointment/<id>')
def appointment(id):
    check = check_user()
    if check and check == "admin":
        appointment = call_api("{}/appointment/{}/".format(check, id))
        return render_template("{}/appointment.tpl".format(check), appointment=appointment)
    else:
        flash("Unauthorized")
        return redirect(url_for('index'))

@app.route('/appointment/<id>/delete/')
def delete_appointment(id):
    check = check_user()
    if check and check == "admin":
        response = call_api("{}/appointment/{}/".format(check, id), method="delete")
        return redirect(url_for('index'))
    else:
        flash("Unauthorized")
        return redirect(url_for('index'))

@app.route('/res/<path:path>')
def send_css(path):
    a = 0
    return send_from_directory('resources', path)

def call_api(url, method="get", **kwargs):
    if "payload" in kwargs:
        payload = kwargs["payload"]
    else:
        payload = None
    url += "/"
    session = r.Session()
    if 'session' in request.cookies:
        session.cookies["session"] = request.cookies["session"]
    else:
        return False
    if payload:
        resp = getattr(session, method)(app.config["BASE_URL"] + url, json=payload)
    else:
        resp = getattr(session, method)(app.config["BASE_URL"] + url)
    return resp.json()

