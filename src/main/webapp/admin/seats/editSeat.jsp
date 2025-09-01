<%@ page contentType="application/json" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = con.prepareStatement("SELECT * FROM Seats WHERE seat_id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        String json = "{"
            + "\"seat_id\":" + rs.getInt("seat_id") + ","
            + "\"seat_number\":\"" + rs.getString("seat_number") + "\","
            + "\"seat_type\":\"" + rs.getString("seat_type") + "\","
            + "\"is_reserved\":" + (rs.getBoolean("is_reserved") ? 1 : 0)
            + "}";
        out.print(json);
    }

    rs.close();
    ps.close();
    con.close();
%>
