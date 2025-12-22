<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>

<%
 user = (String)session.getAttribute("user");
String dbPath = application.getRealPath("/WEB-INF/nomination.db");
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
Statement st = conn.createStatement();
String msg="";
if(request.getParameter("action")!=null){
    String action = request.getParameter("action"); // APPROVE / REJECT
    String id = request.getParameter("id");
    String remarks = request.getParameter("remarks");
    if("REJECT".equals(action) && (remarks==null || remarks.trim().isEmpty())){
        msg="Remarks required for rejection!";
    } else {
        String sql = "UPDATE nominations SET status=?, approver=?, remarks=?, action_time=? WHERE id=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, action.equals("APPROVE")?"APPROVED":"REJECTED");
        ps.setString(2, user);
        ps.setString(3, remarks);
        ps.setString(4, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        ps.setInt(5, Integer.parseInt(id));
        ps.executeUpdate(); ps.close();
        msg="Action recorded successfully!";
    }
}
%>

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-danger text-white">
            <h3>Pending Approvals</h3>
        </div>
        <div class="card-body">
            <div class="text-success mb-3"><%= msg %></div>

            <table class="table table-bordered table-striped table-hover">
                <thead class="thead-dark">
                    <tr>
                        <th>Event</th>
                        <th>Nominee</th>
                        <th>Relation</th>
                        <th>Employee</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                ResultSet rs = st.executeQuery(
                    "SELECT n.id,n.nominee_name,n.relation,n.status,n.employee,e.name as eventName " +
                    "FROM nominations n JOIN events e ON n.event_id=e.id WHERE n.status='PENDING'"
                );
                while(rs.next()){
                %>
                    <tr>
                        <td><%= rs.getString("eventName") %></td>
                        <td><%= rs.getString("nominee_name") %></td>
                        <td><%= rs.getString("relation") %></td>
                        <td><%= rs.getString("employee") %></td>
                        <td><span class="badge badge-warning"><%= rs.getString("status") %></span></td>
                        <td>
                            <form method="post" class="form-inline">
                                <input type="hidden" name="id" value="<%= rs.getInt("id") %>">
                                <input type="text" name="remarks" class="form-control form-control-sm mb-1 mr-1" placeholder="Remarks (required if reject)">
                                <button name="action" value="APPROVE" class="btn btn-success btn-sm mb-1 mr-1">Approve</button>
                                <button name="action" value="REJECT" class="btn btn-danger btn-sm mb-1">Reject</button>
                            </form>
                        </td>
                    </tr>
                <%
                }
                rs.close(); st.close(); conn.close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
