<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.io.*, java.util.*, java.sql.*, com.opencsv.*" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bulk Upload Customers</title>

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.10.21/css/jquery.dataTables.min.css">
</head>
<body>

    <div class="container mt-5">
        <h1>Bulk Upload Customers from CSV</h1>

        <!-- CSV File Upload Form -->
        <form action="inputcsv.jsp" method="POST" enctype="multipart/form-data">
            <div class="form-group">
                <label for="csvFile">Choose a CSV file:</label>
                <input type="file" name="csvFile" id="csvFile" class="form-control" accept=".csv" required />
            </div>
            <button type="submit" class="btn btn-primary">Upload CSV</button>
        </form>

        <hr>

        <!-- Handle CSV Upload and Database Insertion -->
        <%
            // SQLite database connection details
            String dbUrl = "jdbc:sqlite:/path/to/your/customers.db"; // Update with correct path
            List<String[]> csvData = null;

            // Handle CSV upload
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                Part filePart = request.getPart("csvFile");
                String fileName = filePart.getSubmittedFileName();

                // If the file is not empty
                if (filePart != null && fileName != null && !fileName.isEmpty()) {
                    String uploadPath = application.getRealPath("/") + "uploads"; // Specify upload path
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();  // Create directory if it doesn't exist
                    }

                    String filePath = uploadPath + File.separator + fileName;
                    filePart.write(filePath);  // Save file to disk

                    // Parse the CSV file using OpenCSV
                    try {
                        CSVReader csvReader = new CSVReader(new FileReader(filePath));
                        csvData = csvReader.readAll();  // Read all rows
                        csvReader.close();

                        // Connect to the SQLite database and insert records
                        Class.forName("org.sqlite.JDBC");
                        Connection conn = DriverManager.getConnection(dbUrl);

                        // SQL query to insert customer data
                        String sql = "INSERT INTO customers (customerNo, customerName, latitude, longitude) VALUES (?, ?, ?, ?)";
                        PreparedStatement ps = conn.prepareStatement(sql);

                        // Iterate through each row in the CSV and insert into database
                        for (String[] row : csvData) {
                            if (row.length == 4) {  // Ensure row has correct columns
                                ps.setString(1, row[0]);  // customerNo
                                ps.setString(2, row[1]);  // customerName
                                ps.setString(3, row[2]);  // latitude
                                ps.setString(4, row[3]);  // longitude
                                ps.addBatch();  // Add to batch
                            }
                        }

                        // Execute batch insert
                        int[] result = ps.executeBatch();
                        if (result.length > 0) {
                            out.println("<p style='color: green;'>CSV data successfully uploaded and added to the database!</p>");
                        }

                        // Close resources
                        ps.close();
                        conn.close();
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                    }
                }
            }

            // Display uploaded CSV data in a table (if any)
            if (csvData != null && !csvData.isEmpty()) {
        %>
            <h2>Uploaded CSV Data</h2>
            <table id="csvTable" class="table table-striped table-bordered">
                <thead>
                    <tr>
                        <th>Customer No</th>
                        <th>Customer Name</th>
                        <th>Latitude</th>
                        <th>Longitude</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        // Display each row in the table
                        for (String[] row : csvData) {
                            if (row.length == 4) {  // Ensure row has correct columns
                    %>
                    <tr>
                        <td><%= row[0] %></td>
                        <td><%= row[1] %></td>
                        <td><%= row[2] %></td>
                        <td><%= row[3] %></td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        <%
            }
        %>

    </div>

    <!-- jQuery, Bootstrap JS, and DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.5.1.js"></script>
    <script src="https://cdn.datatables.net/1.10.21/js/jquery.dataTables.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>

    <script>
        $(document).ready(function() {
            // Initialize DataTable for interactive table with search, sorting, and pagination
            $('#csvTable').DataTable();
        });
    </script>

</body>
</html>
