<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("operator_name");
    String contact = request.getParameter("contact_number");

    try {
        PreparedStatement ps = con.prepareStatement("UPDATE Operators SET operator_name=?, contact_number=? WHERE operator_id=?");
        ps.setString(1, name);
        ps.setString(2, contact);
        ps.setInt(3, id);
        ps.executeUpdate();
        response.sendRedirect("manageOperators.jsp");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
