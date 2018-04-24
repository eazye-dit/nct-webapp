{% extends "bootstrap/base.html" %}
{% block title %}Index{% endblock %}



#d1{
	float:left
}


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
              <a href="/" target=
              "_blank">Home</a>
            </li>

            <li>
              <a href="/logout">Logout</a>
            </li>

          </ul>
        </div>
      </div>

      <div class="inner cover" style="border: 1px groove black" id="d1" > 
		{% for appointment in appointments["appointments"] %}
		
		<p> {{ appointment["assigned"]["last"], appointment["date"], appointment["vehicle"]["registration"] }} </p> 

		
		{% endfor%}
      </div>
	  
	  
	  
    </div>
</div>
</div>
{% endblock %}
