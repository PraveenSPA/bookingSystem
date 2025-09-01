<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    String sql = "UPDATE Schedules SET route_id=?, bus_id=?, driver_id=?, departure_datetime=?, arrival_datetime=?, fare=?, status=? WHERE schedule_id=?";
    try(
        PreparedStatement ps = con.prepareStatement(sql)){

        ps.setInt(1, Integer.parseInt(request.getParameter("route_id")));
        ps.setInt(2, Integer.parseInt(request.getParameter("bus_id")));
        String driver = request.getParameter("driver_id");
        if(driver==null || driver.equals("")) ps.setNull(3, java.sql.Types.INTEGER);
        else ps.setInt(3, Integer.parseInt(driver));
        ps.setString(4, request.getParameter("departure_datetime"));
        ps.setString(5, request.getParameter("arrival_datetime"));
        ps.setDouble(6, Double.parseDouble(request.getParameter("fare")));
        ps.setString(7, request.getParameter("status"));
        ps.setInt(8, Integer.parseInt(request.getParameter("schedule_id")));

        ps.executeUpdate();
        response.sendRedirect("manageSchedules.jsp");
    } catch(Exception e){
        out.println("Error: "+e.getMessage());
    }
%>
