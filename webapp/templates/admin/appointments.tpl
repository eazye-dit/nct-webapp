{% extends "bootstrap/base.html" %}
{% block title %}Appointments{% endblock %}
{% import "bootstrap/utils.html" as utils %}

{% block scripts %}
{{super()}}

<script src="/res/js/bootbox.min.js"></script>
<script>
    $(document).on("click", ".text-danger", function(e) {
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
        <li class="active"><a href="#">Appointments <span class="sr-only">(current)</span></a></li>
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
    {% for appointment in appointments["appointments"] %}
        <div class="col-sm-4">
            <div class="panel panel-default">
                 <div class="panel-heading">
                    <h3 class="panel-title">{{ appointment["vehicle"]["registration"] }}</h5>
                    <h6 class="mb-2 text-muted">{{ appointment["date"] }}</h6>
                </div>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Owner: {{ appointment["vehicle"]["owner"]["last"] }}, {{ appointment["vehicle"]["owner"]["first"] }}</li>
                    <li class="list-group-item">Make: {{ appointment["vehicle"]["make"] }}</li>
                    <li class="list-group-item">Model: {{ appointment["vehicle"]["model"] }}</li>
                    <li class="list-group-item">Year: {{ appointment["vehicle"]["year"] }}</li>
                    <li class="list-group-item">Colour: {{ appointment["vehicle"]["colour"] }}</li>
                    <li class="list-group-item">Assigned to {{ appointment["assigned"]["last"] }}, {{ appointment["assigned"]["first"] }}</li>
                </ul>
                <div class="panel-body">
                    <a href="/appointment/{{ appointment["id"] }}/">Update</a>
                    <a data-href="/appointment/{{ appointment["id"] }}/delete/" class="delete-link text-danger float-right">Delete</a>
                </div>
            </div>
        </div>
    {% endfor %}
    </div>
</div>
{% endblock %}
