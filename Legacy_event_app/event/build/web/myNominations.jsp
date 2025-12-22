<%@ page import="java.sql.*" %>
<%@ include file="header.jsp" %>
<%
 user = (String)session.getAttribute("user");
String dbPath = application.getRealPath("/WEB-INF/nomination.db");
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
Statement st = conn.createStatement();
%>
<div class="container mt-4">
<h2>My Nominations</h2>
<table class="table table-bordered table-striped">
<thead>
<tr><th>Event</th><th>Nominee</th><th>Relation</th><th>Status</th><th>Approver</th><th>Remarks</th><th>Action Time</th></tr>
</thead>
<tbody>
<%
ResultSet rs = st.executeQuery("SELECT n.nominee_name,n.relation,n.status,n.approver,n.remarks,n.action_time,e.name as eventName " +
"FROM nominations n JOIN events e ON n.event_id=e.id WHERE n.employee='"+user+"'");
while(rs.next()){
%>
<tr>
<td><%= rs.getString("eventName") %></td>
<td><%= rs.getString("nominee_name") %></td>
<td><%= rs.getString("relation") %></td>
<td><%= rs.getString("status") %></td>
<td><%= rs.getString("approver") %></td>
<td><%= rs.getString("remarks") %></td>
<td><%= rs.getString("action_time") %></td>
</tr>
<%
}
rs.close(); st.close(); conn.close();
%>
</tbody>
</table>
</div>
