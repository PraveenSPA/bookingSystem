<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    String idParam = request.getParameter("id");
    if (idParam != null) {
        int userId = Integer.parseInt(idParam);
        try {
            PreparedStatement pst = con.prepareStatement("DELETE FROM users WHERE user_id=?");
            pst.setInt(1, userId);
            pst.executeUpdate();
            pst.close();
            response.sendRedirect("manageUsers.jsp?msg=deleted");
        } catch(Exception e){
            out.println("Error: " + e.getMessage());
        }
    } else {
        out.println("Invalid User ID!");
    }
%>
