<%@ page import="java.sql.*" %>
<%
    // Path to the SQLite DB inside WEB-INF
    String dbPath = application.getRealPath("/WEB-INF/nomination.db");
    
    try {
        // Load SQLite JDBC driver
        Class.forName("org.sqlite.JDBC");
        
        // Connect (creates file automatically if missing)
        Connection c = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        Statement st = c.createStatement();
        
        // --- USERS TABLE ---
        st.execute("CREATE TABLE IF NOT EXISTS users (" +
                   "username TEXT PRIMARY KEY, " +
                   "password TEXT, " +
                   "role TEXT)");
        
        // Insert default users if not exist
        st.execute("INSERT OR IGNORE INTO users VALUES('admin','admin','ADMIN')");
        st.execute("INSERT OR IGNORE INTO users VALUES('emp1','emp1','CREATOR')");
        st.execute("INSERT OR IGNORE INTO users VALUES('approver','approver','APPROVER')");
        
        // --- EVENTS TABLE ---
        st.execute("CREATE TABLE IF NOT EXISTS events (" +
                   "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                   "name TEXT, " +
                   "category TEXT, " +
                   "from_date TEXT, " +
                   "to_date TEXT, " +
                   "max_people INTEGER, " +
                   "per_head REAL, " +
                   "total_amount REAL, " +
                   "status TEXT)");
        
        // --- NOMINATIONS TABLE ---
        st.execute("CREATE TABLE IF NOT EXISTS nominations (" +
                   "id INTEGER PRIMARY KEY AUTOINCREMENT, " +
                   "event_id INTEGER, " +
                   "employee TEXT, " +
                   "nominee_name TEXT, " +
                   "relation TEXT, " +
                   "status TEXT, " +
                   "approver TEXT, " +
                   "remarks TEXT, " +
                   "action_time TEXT)");
        
        // Close connection
        c.close();
        
        out.println("<h3 style='color:green'>Database and tables initialized successfully!</h3>");
        out.println("<p>Default users: admin/admin, emp1/emp1, approver/approver</p>");
        out.println("<p>Now you can proceed to <a href='login.jsp'>Login</a></p>");
    } catch(Exception e){
        out.println("<h3 style='color:red'>Database setup failed!</h3>");
        out.println("<pre>" + e + "</pre>");
    }
%>
