<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
    String name = request.getParameter("operator_name");
    String contact = request.getParameter("contact_number");

    try {
        PreparedStatement ps = con.prepareStatement("INSERT INTO Operators(operator_name, contact_number) VALUES (?,?)");
        ps.setString(1, name);
        ps.setString(2, contact);
        ps.executeUpdate();
        response.sendRedirect("manageOperators.jsp");
    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if(con != null) con.close();
    }
%>
