<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<html>
<head>
    <title>Manage Users</title>
</head>
<body>
<div style="margin: 20px;">
    <h2>Manage Users</h2>
    <a href="../adminDashboard.jsp">⬅ Back to Dashboard</a>
    <br><br>

    <table border="1" cellpadding="8" cellspacing="0">
        <tr style="background:#f2f2f2;">
            <th>ID</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Gender</th>
            <th>DOB</th>
            <th>Actions</th>
        </tr>
        <%
            try {
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery("SELECT * FROM users");
                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("full_name") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("phone") %></td>
            <td><%= rs.getString("gender") %></td>
            <td><%= rs.getDate("dob") != null ? rs.getDate("dob").toString() : "" %></td>
            <td>
                <a href="editUser.jsp?id=<%= rs.getInt("user_id") %>">Edit</a> |
                <a href="deleteUser.jsp?id=<%= rs.getInt("user_id") %>" 
                   onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
            </td>
        </tr>
        <%
                }
                rs.close();
                st.close();
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            }
        %>
    </table>
</div>
</body>
</html>

<%@ include file="../includes/adminFooter.jsp" %>
