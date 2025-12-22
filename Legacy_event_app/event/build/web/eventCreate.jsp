<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
String msg="";
if(request.getMethod().equalsIgnoreCase("POST")){
    String name = request.getParameter("name");
    String category = request.getParameter("category");
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");
    int maxPeople = Integer.parseInt(request.getParameter("maxPeople"));
    double perHead = Double.parseDouble(request.getParameter("perHead"));
    double totalAmount = maxPeople*perHead;

    String dbPath = application.getRealPath("/WEB-INF/nomination.db");
    Class.forName("org.sqlite.JDBC");
    Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
    PreparedStatement ps = conn.prepareStatement(
        "INSERT INTO events(name,category,from_date,to_date,max_people,per_head,total_amount,status) VALUES(?,?,?,?,?,?,?,?)"
    );
    ps.setString(1,name); ps.setString(2,category); ps.setString(3,fromDate); ps.setString(4,toDate);
    ps.setInt(5,maxPeople); ps.setDouble(6,perHead); ps.setDouble(7,totalAmount); ps.setString(8,"OPEN");
    ps.executeUpdate();
    ps.close(); conn.close();
    msg="Event created successfully!";
}
%>
<div class="container mt-4">
<h2>Create New Event</h2>
<form method="post">
<div class="form-row">
<div class="form-group col-md-4">
<input type="text" name="name" class="form-control" placeholder="Event Name" required>
</div>
<div class="form-group col-md-4">
<select name="category" class="form-control">
<option>Recreational</option>
<option>Training</option>
<option>Outbound</option>
<option>Family Picnic</option>
</select>
</div>
<div class="form-group col-md-2">
<input type="date" name="fromDate" class="form-control" required>
</div>
<div class="form-group col-md-2">
<input type="date" name="toDate" class="form-control" required>
</div>
</div>
<div class="form-row">
<div class="form-group col-md-3">
<input type="number" name="maxPeople" class="form-control" placeholder="Max People" required>
</div>
<div class="form-group col-md-3">
<input type="number" name="perHead" step="0.01" class="form-control" placeholder="Per Head Amount" required>
</div>
<div class="form-group col-md-3">
<input type="number" class="form-control" placeholder="Total Amount (auto)" value="" disabled>
</div>
<div class="form-group col-md-3">
<button class="btn btn-primary">Create Event</button>
</div>
</div>
<div class="text-success"><%= msg %></div>
</form>
</div>
