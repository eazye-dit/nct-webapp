from wtforms import Form, TextField, PasswordField, SubmitField, SelectField, validators

class LoginForm(Form):
    action = "Login"
    username = TextField("Username")
    password = PasswordField("Password")
    submit = SubmitField("Login")
