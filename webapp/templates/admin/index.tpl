{% extends "bootstrap/base.html" %}
{% block title %}Appointments{% endblock %}



{% block styles %}
{{super()}}
<link rel="stylesheet"
      href="/res/css/cover.css">
<link rel="stylesheet"
      href="/res/css/style.css">
{% endblock %}

{% block content %}
<div class="site-wrapper">
  <div class="site-wrapper-inner">
    <div class="cover-container">
      <div class="masthead clearfix">
        <div class="inner">
          <h3 class="masthead-brand">Admin</h3>

          <ul class="nav masthead-nav">
            <li class="active">
              <a href="/">Appointments</a>
            </li>

            <li>
              <a href="/logout">Logout</a>
            </li>

          </ul>
        </div>
      </div>
    </div>
  <div class="container">
    <div class="row">
    {% for appointment in appointments["appointments"] %}
        <div class="col-sm-4" style="border: 1px solid #ddd;">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">{{ appointment["vehicle"]["registration"] }}</h5>
                    <h6 class="card-subtitle mb-2 text-muted">{{ appointment["date"] }}</h6>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Owner: {{ appointment["vehicle"]["owner"]["last"] }}, {{ appointment["vehicle"]["owner"]["first"] }}</li>
                    <li class="list-group-item">Make: {{ appointment["vehicle"]["make"] }}</li>
                    <li class="list-group-item">Model: {{ appointment["vehicle"]["model"] }}</li>
                    <li class="list-group-item">Year: {{ appointment["vehicle"]["year"] }}</li>
                    <li class="list-group-item">Colour: {{ appointment["vehicle"]["colour"] }}</li>
                    <li class="list-group-item">Assigned to: {{ appointment["assigned"]["last"] }}, {{ appointment["assigned"]["first"] }}</li>
                </ul>
                <div class="card-body">        
                    <a href="#" class="card-link">Update</a>
                    <a href="/appointment/{{ appointment["id"] }}/delete/" class="card-link text-danger float-right">Delete</a>
                </div>
            </div>
        </div>
    {% endfor %}
    </div>
</div>
    </div>
</div>
</div>
{% endblock %}
