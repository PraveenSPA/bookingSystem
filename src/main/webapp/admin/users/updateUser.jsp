<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int userId = Integer.parseInt(request.getParameter("user_id"));
    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String gender = request.getParameter("gender");
    String dob = request.getParameter("dob");

    try {
        PreparedStatement pst = con.prepareStatement(
            "UPDATE users SET full_name=?, email=?, phone=?, gender=?, dob=? WHERE user_id=?"
        );
        pst.setString(1, fullName);
        pst.setString(2, email);
        pst.setString(3, phone);
        pst.setString(4, gender);
        pst.setString(5, (dob != null && !dob.isEmpty()) ? dob : null);
        pst.setInt(6, userId);

        pst.executeUpdate();
        pst.close();

        response.sendRedirect("manageUsers.jsp?msg=updated");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
