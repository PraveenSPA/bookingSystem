<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    response.setContentType("text/plain");

    int bus_id = Integer.parseInt(request.getParameter("bus_id"));
    String bus_number = request.getParameter("bus_number");
    String bus_type = request.getParameter("bus_type");
    int capacity = Integer.parseInt(request.getParameter("capacity"));
    int operator_id = Integer.parseInt(request.getParameter("operator_id"));

    try {
        String sql = "UPDATE Buses SET bus_number=?, bus_type=?, capacity=?, operator_id=? WHERE bus_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, bus_number);
        ps.setString(2, bus_type);
        ps.setInt(3, capacity);
        ps.setInt(4, operator_id);
        ps.setInt(5, bus_id);

        ps.executeUpdate();
        out.print("success");   // ✅ Return only success
    } catch(Exception e) {
        out.print("error: " + e.getMessage());
    } finally {
        if(con != null) con.close();
    }
%>
