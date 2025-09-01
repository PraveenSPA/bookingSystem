<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("route_id"));
    String distance = request.getParameter("distance_km");
    String estTime = request.getParameter("estimated_time");

    PreparedStatement ps = con.prepareStatement(
        "UPDATE Routes SET distance_km=?, estimated_time=? WHERE route_id=?"
    );
    ps.setBigDecimal(1, new java.math.BigDecimal(distance));
    ps.setString(2, estTime);
    ps.setInt(3, id);
    ps.executeUpdate();
    ps.close();

    response.sendRedirect("manageRoutes.jsp");
%>
