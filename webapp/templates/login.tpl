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
                <form method="POST">
                    {% for field in form %}
                        {% if field.type != "SubmitField" %}
                            <div class="form-group">
                                {{ field.label }}
                                {{ field(class_="form-control") }}
                                {% if field.errors %}
                                    <ul class="errors">
                                        {% for error in field.errors %}
                                            <li>{{ error }}</li>
                                        {% endfor %}
                                    </ul>
                                {% endif %}
                            </div>
                        {% else %}
                            <button class="btn btn-info btn-default" type="{{ field.label.data }}">{{ form.action }}</button>
                        {%- endif %}
                    {%- endfor %}
                </form>
            </div>
        </div>
    </div>
{% endblock %}
