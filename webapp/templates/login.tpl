{% extends "bootstrap/base.html" %}
{% block title %}Login{% endblock %}
{% import "bootstrap/utils.html" as utils %}

{% block styles %}
{{super()}}
<link rel="stylesheet"
      href="/res/css/style.css">
{% endblock %}

{% block content %}
<div class="container">
    {%- with messages = get_flashed_messages(with_categories=True) %}
    {%- if messages %}
        <div class="row">
            <div class="col-md-12">
                {{utils.flashed_messages(messages)}}
            </div>
        </div>
    {%- endif %}
    {%- endwith %}
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
