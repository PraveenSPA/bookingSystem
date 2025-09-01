<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    try(
        PreparedStatement ps = con.prepareStatement("DELETE FROM Drivers WHERE driver_id=?")){
        ps.setInt(1, id);
        ps.executeUpdate();
        response.sendRedirect("manageDrivers.jsp");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
