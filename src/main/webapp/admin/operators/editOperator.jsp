<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = "";
    String contact = "";

    try {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM Operators WHERE operator_id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            name = rs.getString("operator_name");
            contact = rs.getString("contact_number");
        }
        rs.close();
        ps.close();
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Operator</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
    <h3 class="text-primary mb-4">Edit Operator</h3>
    <form action="updateOperator.jsp" method="post" class="card p-4 shadow">
        <input type="hidden" name="id" value="<%= id %>">
        <div class="mb-3">
            <label>Operator Name</label>
            <input type="text" name="operator_name" class="form-control" value="<%= name %>" required>
        </div>
        <div class="mb-3">
            <label>Contact Number</label>
            <input type="text" name="contact_number" class="form-control" value="<%= contact %>">
        </div>
        <button type="submit" class="btn btn-primary">Update</button>
        <a href="manageOperators.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</body>
</html>
