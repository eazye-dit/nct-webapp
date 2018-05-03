from wtforms import Form, TextField, PasswordField, SubmitField, SelectField, validators, IntegerField

class LoginForm(Form):
    action = "Login"
    username = TextField("Username")
    password = PasswordField("Password")
    submit = SubmitField("Login")

class AppointmentForm(Form):
    action = "Create new appointment"
    date = TextField("Date")
    vehicle = TextField("Vehicle")
    assigned = SelectField("Mechanic")
    submit = SubmitField("Create")

class OwnerForm(Form):
    action = "Register new owner"
    f_name = TextField("First name", [validators.required(), validators.length(max=30)])
    l_name = TextField("Last name", [validators.required(), validators.length(max=30)])
    phone = TextField("Phone number", [validators.length(max=20)])
    submit = SubmitField("Register")

class VehicleForm(Form):
    action = "Register new vehicle"
    registration = TextField("Registration", [validators.required(), validators.length(min=4, max=11)])
    vin = TextField("VIN", [validators.required(), validators.length(max=17, min=17)])
    owner = TextField("Owner name", [validators.required()])
    make = TextField("Make", [validators.required()])
    model = TextField("Model", [validators.required()])
    year = IntegerField("Year", [validators.required(), validators.length(max=4, min=4)])
    colour = TextField("Colour", [validators.required()])
    submit = SubmitField("Register")

class MechanicForm(Form):
    action = "Register new mechanic"
    username = TextField("Username", [validators.required(), validators.length(max=20)])
    password = PasswordField("Password", [
        validators.DataRequired(),
        validators.EqualTo('confirm', message="Passwords must match")
    ])
    confirm = PasswordField("Repeat password")
    f_name = TextField("First name", [validators.required(), validators.length(max=30)])
    l_name = TextField("Last name", [validators.required(), validators.length(max=30)])
    submit = SubmitField("Register")
