<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    try(
        PreparedStatement ps = con.prepareStatement("DELETE FROM Seats WHERE seat_id=?")){
        ps.setInt(1, id);
        ps.executeUpdate();
        response.sendRedirect("manageSeats.jsp");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
