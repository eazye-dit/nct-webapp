{% extends "bootstrap/base.html" %}
{% block title %}Appointments{% endblock %}
{% import "bootstrap/utils.html" as utils %}

{% block styles %}
{{ super() }}
<link rel="stylesheet" href="/res/css/utils.css">

{% endblock %}

{% block content %}
<nav class="navbar navbar-inverse">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#">NCT</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
      <ul class="nav navbar-nav">
        <li><a href="/">Home</a></li>
        <li class="active"><a href="/appointments/">Appointments <span class="sr-only">(current)</span></a></li>
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">New... <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="/new/appointment/">Appointment</a></li>
            <li><a href="/new/mechanic/">Mechanic</a></li>
            <li><a href="/new/vehicle/">Vehicle</a></li>
            <li><a href="/new/owner/">Owner</a></li>
          </ul>
        </li>
      </ul>
      <form class="navbar-form navbar-left">
        <div class="form-group">
          <input type="text" class="form-control" placeholder="Search (has no use)">
        </div>
        <button type="submit" class="btn btn-default">Submit</button>
      </form>
      <ul class="nav navbar-nav navbar-right">
        <li class="dropdown">
          <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Controls <span class="caret"></span></a>
          <ul class="dropdown-menu">
            <li><a href="/logout">Logout</a></li>
          </ul>
        </li>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
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

    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">{{ appointment["appointment"]["vehicle"]["registration"] }}</h5>
            </div>
            <ul class="list-group list-group-flush">
                <li class="list-group-item">Owner: {{ appointment["appointment"]["vehicle"]["owner"]["last"] }}, {{ appointment["appointment"]["vehicle"]["owner"]["first"] }}</li>
                <li class="list-group-item">Make: {{ appointment["appointment"]["vehicle"]["make"] }}</li>
                <li class="list-group-item">Model: {{ appointment["appointment"]["vehicle"]["model"] }}</li>
                <li class="list-group-item">Year: {{ appointment["appointment"]["vehicle"]["year"] }}</li>
                <li class="list-group-item">Colour: {{ appointment["appointment"]["vehicle"]["colour"] }}</li>
                <li class="list-group-item">Appointment date: {{ appointment["appointment"]["date"] }}</li>
                <li class="list-group-item">Test completed: {{ appointment["appointment"]["completed"] }}</li>
                <li class="list-group-item">Test performed by: {{ appointment["appointment"]["assigned"]["last"] }}, {{ appointment["appointment"]["assigned"]["first"] }}</li>
            </ul>
        </div>
        <table class="table table-striped table-hover">
            <tr>
                <th>Test step</th>
                <th>Points of failure</th>
                <th>Comment</th>
            </tr>
        {% for result in appointment["test"]["results"] %}
            <tr>
                <td>{{ result["step"]["id"] }} - {{ result["step"]["name"] }}</td>
            {% if result["failures"]| length > 0 %}
                <td>
                {% for failure in result["failures"] %}
                <b>{{ failure["item"] }}</b>: {{ failure["name"] }}<br />
                {% endfor %}
                </td>
            {% else %}
                <td>No failures</td>
            {% endif %}
                {% if result["comment"] %}<td>{{ result["comment"] }}</td>{% else %}<td>No comment</td>{% endif %}
            </tr>
        {% endfor %}
        </table>
    </div>
</div>

{% endblock %}
