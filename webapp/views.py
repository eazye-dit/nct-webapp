from webapp import app, forms
from flask import render_template, jsonify, send_from_directory, request, url_for, redirect, flash
import requests as r
from datetime import datetime

def check_user():
    if 'nct_session' in request.cookies:
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
       return render_template('{}/index.tpl'.format(check))
    return redirect(url_for('login'))

@app.route('/appointments/')
def appointments():
    check = check_user()
    if check and check == "admin":
        appointments = call_api("admin/appointments".format(check))
        return render_template('admin/appointments.tpl'.format(check), appointments=appointments)
    return redirect(url_for('index'))

@app.route('/login/', methods=["GET", "POST"])
def login():
    check = check_user()
    if check:
        return redirect(url_for('index'))
    form = forms.LoginForm(request.form)
    if request.method == "POST" and form.validate():
        session = r.Session()
        payload = {
            "username": form.username.data,
            "password": form.password.data
        }

        resp = session.post(app.config["BASE_URL"] + "login/", data=payload)

        if resp.status_code == 200:
            redir = redirect(url_for('index'))
            response = app.make_response(redir)
            response.set_cookie('nct_session', value=session.cookies["session"])
            return response
        else:
            flash("Login failed")
    return render_template('login.tpl', form=form)

@app.route('/logout/')
def logout():
    response = app.make_response(redirect(url_for('index')))
    response.set_cookie('nct_session', expires=0)
    return response

@app.route('/appointment/<id>/', methods=["GET", "POST"])
def appointment(id):
    check = check_user()
    if not check or not check == "admin":
        flash("Unauthorized")
        return redirect(url_for('index'))
    appointment = call_api("{}/appointment/{}/".format(check, id))
    if request.method == "POST":
        form = request.form
        date = datetime.strptime(form["date"], "%a, %d %b %Y %H:%M:%S")
        datestr = date.strftime("%Y-%m-%d %H:%M")
        assigned = form["assigned"]
        vehicle = appointment["appointment"]["vehicle"]["registration"]
        payload = {"date": datestr, "assigned": assigned, "vehicle": vehicle}
        resp = call_api("{}/appointment/{}/".format(check, id), method="post", payload=payload)
        if resp["status"] != 200:
            flash(resp["message"])
        return redirect(url_for('appointment', id=id))
    mechanics = call_api("{}/mechanics/".format(check))
    return render_template("{}/appointment.tpl".format(check), appointment=appointment, mechanics=mechanics)

@app.route('/appointment/<id>/delete/')
def delete_appointment(id):
    check = check_user()
    if check and check == "admin":
        response = call_api("{}/appointment/{}/".format(check, id), method="delete")
        return redirect(url_for('appointments'))
    else:
        flash("Unauthorized")
        return redirect(url_for('index'))

@app.route('/new/appointment/', methods=["GET", "POST"])
def new_appointment():
    check = check_user()
    if not check or not check == "admin":
        flash("Unauthorized")
        return redirect(url_for('index'))
    mechanics = call_api("{}/mechanics/".format(check))
    mech_list = []
    for mechanic in mechanics["mechanics"]:
        mech_list.append((mechanic["id"], "{}, {}".format(mechanic["last"], mechanic["first"])))
    form = forms.AppointmentForm(request.form)
    form.assigned.choices = mech_list
    if request.method == "POST":
        date = datetime.strptime(form.date.data, "%a, %d %b %Y %H:%M:%S")
        datestr = date.strftime("%Y-%m-%d %H:%M")
        payload = {"date": datestr, "assigned": form.assigned.data, "vehicle": form.vehicle.data}
        resp = call_api("{}/new/appointment/".format(check), method="post", payload=payload)
        if resp["status"] != 200:
            flash(resp["message"])
        else:
            flash("Appointment successfully created")
            return redirect(url_for('appointment', id=resp["appointment"]["id"]))
    return render_template('admin/form.tpl', form=form)

@app.route('/new/mechanic/', methods=["GET", "POST"])
def new_mechanic():
    check = check_user()
    if not check or not check == "admin":
        flash("Unauthorized")
        return redirect(url_for('index'))

    form = forms.MechanicForm(request.form)
    if request.method == "POST" and form.validate():
        payload = {
            "username": form.username.data,
            "password": form.password.data,
            "f_name": form.f_name.data,
            "l_name": form.l_name.data
        }
        resp = call_api("{}/new/mechanic/".format(check), method="post", payload=payload)
        if resp["status"] != 200:
            flash(resp["message"])
        else:
            flash("Mechanic successfully registered")
            return redirect(url_for('index'))
    return render_template('admin/form.tpl', form=form)

@app.route('/new/vehicle/', methods=["GET", "POST"])
def new_vehicle():
    check = check_user()
    if not check or not check == "admin":
        flash("Unauthorized")
        return redirect(url_for('index'))

    form = forms.VehicleForm(request.form)
    if request.method == "POST" and form.validate():
        owner = call_api('/admin/search/?owner={}'.format(form.owner.data))
        if owner["status"] == 200:
            owner_id = owner["owner"]["id"]
        else:
            flash(owner["message"])
            return render_template('admin/form.tpl', form=form)
        payload = {
            "owner": owner_id,
            "registration": form.registration.data,
            "make": form.make.data,
            "model": form.model.data,
            "year": form.year.data,
            "vin": form.vin.data,
            "colour": form.colour.data
        }
        resp = call_api("/admin/new/vehicle/", method="post", payload=payload)
        if resp["status"] != 200:
            flash(resp["message"])
        else:
            #flash("Vehicle successfully registered")
            return redirect(url_for('index'))
    return render_template('admin/form.tpl', form=form)

@app.route('/new/owner/', methods=["GET", "POST"])
def new_owner():
    check = check_user()
    if not check or not check == "admin":
        flash("Unauthorized")
        return redirect(url_for('index'))

    form = forms.OwnerForm(request.form)
    if request.method == "POST" and form.validate():
        payload = {
            "f_name": form.f_name.data,
            "l_name": form.l_name.data,
            "phone": form.phone.data
        }
        resp = call_api("/admin/new/owner/", method="post", payload=payload)
        if resp["status"] != 200:
            flash(resp["message"])
        else:
            flash("Owner successfully registered")
            return redirect(url_for('index'))
    return render_template('admin/form.tpl', form=form)

@app.route('/res/<path:path>')
def send_css(path):
    return send_from_directory('resources', path)

def call_api(url, method="get", **kwargs):
    if "payload" in kwargs:
        payload = kwargs["payload"]
    else:
        payload = None
    url += "/"
    session = r.Session()
    if 'nct_session' in request.cookies:
        session.cookies["session"] = request.cookies["nct_session"]
    else:
        return False
    if payload:
        resp = getattr(session, method)(app.config["BASE_URL"] + url, json=payload)
    else:
        resp = getattr(session, method)(app.config["BASE_URL"] + url)
    return resp.json()

