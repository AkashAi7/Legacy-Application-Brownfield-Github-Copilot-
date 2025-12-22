<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Event Nomination</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- Bootstrap CSS CDN -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Optional: Bootstrap JS and jQuery -->
<script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <a class="navbar-brand" href="#">Event Nomination</a>
  <button class="navbar-toggler" type="button" data-toggle="collapse" 
          data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" 
          aria-label="Toggle navigation">
    <span class="navbar-toggler-icon"></span>
  </button>

<%
String user = (String)session.getAttribute("user");
if(user == null){ response.sendRedirect("login.jsp"); }
String role = (String)session.getAttribute("role");
%>


  
  <div class="collapse navbar-collapse" id="navbarNav">
    <ul class="navbar-nav mr-auto">
      <% if("ADMIN".equals(role)){ %>
        <li class="nav-item"><a class="nav-link" href="eventCreate.jsp">Create Event</a></li>
      <% } %>
      <% if("CREATOR".equals(role)){ %>
        <li class="nav-item"><a class="nav-link" href="nominate.jsp">Nominate</a></li>
        <li class="nav-item"><a class="nav-link" href="myNominations.jsp">My Nominations</a></li>
      <% } %>
      <% if("APPROVER".equals(role)){ %>
        <li class="nav-item"><a class="nav-link" href="approveList.jsp">Pending Approvals</a></li>
      <% } %>
    </ul>
    <ul class="navbar-nav">
      <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout (<%=user%>)</a></li>
    </ul>
  </div>
</nav>
