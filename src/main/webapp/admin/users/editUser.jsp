<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<html>
<head>
    <title>Edit User</title>
</head>
<body>
<div style="margin: 20px;">
<%
    String idParam = request.getParameter("id");
    if (idParam == null || idParam.isEmpty()) {
        out.println("<h3 style='color:red;'>No user ID provided!</h3>");
    } else {
        int userId = Integer.parseInt(idParam);
        String fullName="", email="", phone="", gender="", dob="";
        try {
            PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE user_id=?");
            pst.setInt(1, userId);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                fullName = rs.getString("full_name");
                email = rs.getString("email");
                phone = rs.getString("phone");
                gender = rs.getString("gender");
                dob = (rs.getDate("dob") != null) ? rs.getDate("dob").toString() : "";
            }
            rs.close(); pst.close();
        } catch(Exception e){
            out.println("Error: " + e.getMessage());
        }
%>

    <h2>Edit User</h2>
    <form action="updateUser.jsp" method="post">
        <input type="hidden" name="user_id" value="<%= idParam %>">
        Full Name: <input type="text" name="full_name" value="<%= fullName %>" required><br><br>
        Email: <input type="email" name="email" value="<%= email %>" required><br><br>
        Phone: <input type="text" name="phone" value="<%= phone %>" required><br><br>
        Gender:
        <select name="gender">
            <option value="Male" <%= gender.equals("Male") ? "selected" : "" %>>Male</option>
            <option value="Female" <%= gender.equals("Female") ? "selected" : "" %>>Female</option>
            <option value="Other" <%= gender.equals("Other") ? "selected" : "" %>>Other</option>
        </select><br><br>
        DOB: <input type="date" name="dob" value="<%= dob %>"><br><br>
        <input type="submit" value="Update User">
    </form>

<% } %>
</div>
</body>
</html>

<%@ include file="../includes/adminFooter.jsp" %>
