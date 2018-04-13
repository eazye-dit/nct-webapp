{% extends "bootstrap/base.html" %}
{% block title %}Index{% endblock %}

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
          <h3 class="masthead-brand">Mechanic</h3>
          <ul class="nav masthead-nav">
            <li class="active">
              <a href="/" target=
              "_blank">Home</a>
            </li>

            <li>
              <a href="/logout">Logout</a>
            </li>

          </ul>
        </div>
      </div>

      <div class="inner cover">
        <h1 class="cover-heading">Welcome >:)</h1>

        <p class="lead">Something something here</p>
        <p class="lead"><a class="btn btn-lg btn-info" href="#">Learn
        more</a></p>
      </div>
    </div>
</div>
</div>
{% endblock %}
