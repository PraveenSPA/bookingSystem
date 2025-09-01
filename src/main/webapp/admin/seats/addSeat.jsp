<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    String sql = "INSERT INTO Seats (bus_id, seat_number, seat_type, is_reserved) VALUES (?,?,?,?)";

    try(
        PreparedStatement ps = con.prepareStatement(sql)){

        ps.setInt(1, Integer.parseInt(request.getParameter("bus_id")));
        ps.setString(2, request.getParameter("seat_number"));
        ps.setString(3, request.getParameter("seat_type"));
        ps.setBoolean(4, "1".equals(request.getParameter("is_reserved")));

        ps.executeUpdate();
        response.sendRedirect("manageSeats.jsp");
    } catch(Exception e){
        out.println("Error: " + e.getMessage());
    }
%>
