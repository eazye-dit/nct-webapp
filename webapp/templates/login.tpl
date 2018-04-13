{% extends "bootstrap/base.html" %}
{% block title %}Login{% endblock %}

{% block styles %}
{{super()}}
<link rel="stylesheet"
      href="/res/css/style.css">
{% endblock %}

{% block content %}
<div class="container">
    <div class="login-container">
            <div id="output"></div>
            <div class="avatar"></div>
            <div class="form-box">
                <form action="/login/" method="POST">
                    <input name="username" type="text" placeholder="username">
                    <input type="password" placeholder="password" name="password">
                    <button class="btn btn-info btn-block login" type="submit">Login</button>
                </form>
            </div>
        </div>
</div>
{% endblock %}
