<%@ page import="java.sql.*" %>
<%
if(request.getMethod().equalsIgnoreCase("POST")){
    String uname = request.getParameter("username");
    String pwd = request.getParameter("password");
    String dbPath = application.getRealPath("/WEB-INF/nomination.db");
    Class.forName("org.sqlite.JDBC");
    Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
    PreparedStatement ps = conn.prepareStatement("SELECT role FROM users WHERE username=? AND password=?");
    ps.setString(1, uname);
    ps.setString(2, pwd);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
        session.setAttribute("user", uname);
        session.setAttribute("role", rs.getString("role"));
        if("ADMIN".equals(rs.getString("role"))) response.sendRedirect("eventCreate.jsp");
        else if("CREATOR".equals(rs.getString("role"))) response.sendRedirect("nominate.jsp");
        else if("APPROVER".equals(rs.getString("role"))) response.sendRedirect("approveList.jsp");
    } else {
        request.setAttribute("msg", "Invalid username or password");
    }
    rs.close(); ps.close(); conn.close();
}
%>
<!DOCTYPE html>
<html>
<head>
<title>Event Nomination - Login</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
<h2>Login</h2>
<form method="post">
<div class="form-group">
<input type="text" name="username" class="form-control" placeholder="Username" required>
</div>
<div class="form-group">
<input type="password" name="password" class="form-control" placeholder="Password" required>
</div>
<button class="btn btn-primary">Login</button>
<div class="mt-2 text-danger"><%= request.getAttribute("msg")!=null ? request.getAttribute("msg") : "" %></div>
</form>
</div>
</body>
</html>
