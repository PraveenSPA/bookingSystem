<%@ page contentType="application/json" pageEncoding="UTF-8" import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    PreparedStatement ps = con.prepareStatement(
        "SELECT r.*, c1.city_name AS from_city, c2.city_name AS to_city " +
        "FROM Routes r JOIN Cities c1 ON r.from_city_id=c1.city_id " +
        "JOIN Cities c2 ON r.to_city_id=c2.city_id WHERE r.route_id=?"
    );
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
        out.print("{");
        out.print("\"route_id\":"+rs.getInt("route_id")+",");
        out.print("\"from_city\":\""+rs.getString("from_city")+"\",");
        out.print("\"to_city\":\""+rs.getString("to_city")+"\",");
        out.print("\"distance_km\":\""+rs.getBigDecimal("distance_km")+"\",");
        out.print("\"estimated_time\":\""+rs.getString("estimated_time")+"\"");
        out.print("}");
    }
    rs.close(); ps.close();
%>
