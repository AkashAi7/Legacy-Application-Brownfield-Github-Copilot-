<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="header.jsp" %>

<%
 user = (String)session.getAttribute("user");
String dbPath = application.getRealPath("/WEB-INF/nomination.db");
Class.forName("org.sqlite.JDBC");
Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
Statement st = conn.createStatement();
String message = "";

// Handle row-by-row submission
if(request.getParameter("rowSubmit")!=null){
    String nominee = request.getParameter("nominee_name");
    String relation = request.getParameter("relation");
    String eventId = request.getParameter("event_id");
    if(nominee!=null && !nominee.isEmpty()){
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO nominations(event_id, employee, nominee_name, relation, status) VALUES (?,?,?,?,'PENDING')"
        );
        ps.setInt(1,Integer.parseInt(eventId));
        ps.setString(2,user);
        ps.setString(3,nominee);
        ps.setString(4,relation);
        ps.executeUpdate(); ps.close();
        message="Row added successfully!";
    }
}
%>

<div class="container mt-5">
    <div class="card shadow">
        <div class="card-header bg-primary text-white">
            <h3>Nominate Self / Dependents</h3>
        </div>
        <div class="card-body">
            <div class="alert alert-info"><%= message %></div>

            <!-- Row-by-row form -->
            <form method="post">
                <input type="hidden" name="rowSubmit" value="1">
                <div class="form-row mb-3">
                    <div class="col"><input class="form-control" name="nominee_name" placeholder="Nominee Name" required></div>
                    <div class="col"><input class="form-control" name="relation" placeholder="Relation (self/child/spouse)" required></div>
                    <div class="col">
                        <select name="event_id" class="form-control">
                        <%
                        ResultSet rsEvents = st.executeQuery("SELECT id, name FROM events WHERE status='OPEN'");
                        while(rsEvents.next()){
                        %>
                            <option value="<%= rsEvents.getInt("id") %>"><%= rsEvents.getString("name") %></option>
                        <%
                        } rsEvents.close();
                        %>
                        </select>
                    </div>
                    <div class="col"><button class="btn btn-primary btn-block">Add Nominee</button></div>
                </div>
            </form>

            <hr>

            <!-- CSV textarea option -->
            <form method="post">
                <div class="form-group">
                    <label>Paste CSV (nominee_name,relation)</label>
                    <textarea class="form-control" name="csvText" rows="4" placeholder="e.g. John,self&#10;Mary,child"></textarea>
                </div>
                <button class="btn btn-success">Upload CSV</button>
            </form>

            <hr>

            <h5 class="mb-3">Your Current Nominations</h5>
            <table class="table table-striped table-bordered table-hover">
                <thead class="thead-dark">
                    <tr>
                        <th>Event</th>
                        <th>Nominee</th>
                        <th>Relation</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                ResultSet rsNom = st.executeQuery(
                    "SELECT n.nominee_name,n.relation,n.status,e.name as eventName " +
                    "FROM nominations n JOIN events e ON n.event_id=e.id WHERE n.employee='"+user+"'"
                );
                while(rsNom.next()){
                %>
                    <tr>
                        <td><%= rsNom.getString("eventName") %></td>
                        <td><%= rsNom.getString("nominee_name") %></td>
                        <td><%= rsNom.getString("relation") %></td>
                        <td><span class="<%= rsNom.getString("status").equals("PENDING")?"badge badge-warning":"badge badge-success" %>"><%= rsNom.getString("status") %></span></td>
                    </tr>
                <%
                }
                rsNom.close(); st.close(); conn.close();
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>
