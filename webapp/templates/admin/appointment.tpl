{% extends "bootstrap/base.html" %}
{% block title %}Appointments{% endblock %}
{% import "bootstrap/utils.html" as utils %}

{% block scripts %}
{{ super() }}
<script type="text/javascript" src="/res/js/moment.min.js"></script>
<script type="text/javascript" src="/res/js/transition.js"></script>
<script type="text/javascript" src="/res/js/collapse.js"></script>
<script type="text/javascript" src="/res/js/bootstrap-datetimepicker.min.js"></script>

<script type="text/javascript">
    $(function () {
        $('#datetimepicker1').datetimepicker({
            format: "ddd, DD MMM YYYY HH:mm:ss"
        });
    });
</script>

<script src="/res/js/bootbox.min.js"></script>
<script>
    $(document).on("click", ".delete-link", function(e) {
        var lHref = $(this).attr('data-href');
        bootbox.confirm({
            message: "Are you sure you want to delete this appointment?",
            buttons: {
                confirm: {
                    label: "Yes",
                    className: "btn-success"
                },
                cancel: {
                    label: "No",
                    className: "btn-danger"
                }
            },
            callback: function(result) {
                if (result) {
                    window.location.href = lHref;
                }
            }
        });
    });
</script>

{% endblock %}

{% block styles %}
{{ super() }}
<link href="/res/css/bootstrap-datetimepicker.min.css" rel="stylesheet">
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
                <form method="POST">
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Owner: {{ appointment["appointment"]["vehicle"]["owner"]["last"] }}, {{ appointment["appointment"]["vehicle"]["owner"]["first"] }}</li>
                    <li class="list-group-item">Make: {{ appointment["appointment"]["vehicle"]["make"] }}</li>
                    <li class="list-group-item">Model: {{ appointment["appointment"]["vehicle"]["model"] }}</li>
                    <li class="list-group-item">Year: {{ appointment["appointment"]["vehicle"]["year"] }}</li>
                    <li class="list-group-item">Colour: {{ appointment["appointment"]["vehicle"]["colour"] }}</li>
                    <li class="list-group-item">
                        <div class="form-group">
                            <label for="assigned">Assigned to</label>
                            <select class="form-control" name="assigned">
                                {% for mechanic in mechanics["mechanics"] %}
                                    <option value="{{ mechanic["id"] }}"
                                    {% if appointment["appointment"]["assigned"]["username"] == mechanic["username"] %}
                                        selected
                                    {% endif %}
                                    >{{ mechanic["last"] }}, {{ mechanic["first"] }}</option>
                                {% endfor %}
                            </select>
                        </div>
                    </li>
                    <li class="list-group-item">
                        <div class="form-group">
                            <label for="datetimepicker1">Date</label>
                            <div class='input-group date' id='datetimepicker1'>
                                <input type='text' class="form-control" value="{{ appointment["appointment"]["date"] }}" name="date"/>
                                <span class="input-group-addon">
                                    <span class="glyphicon glyphicon-calendar"></span>
                                </span>
                            </div>
                        </div>
                    </li>
                </ul>
                <div class="panel-body">
                    <button class="btn btn-info btn-default" type="update">Update</button>
                    <a data-href="/appointment/{{ appointment["appointment"]["id"] }}/delete/" class="delete-link text-danger float-right">Delete</a>
                </div>
                </form>
        </div>
    </div>
</div>

{% endblock %}
