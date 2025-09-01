<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int busId = Integer.parseInt(request.getParameter("id"));

    try {
        // Check if bookings exist for this bus
        String checkQuery = "SELECT COUNT(*) FROM bookings b " +
                            "JOIN schedules s ON b.schedule_id = s.schedule_id " +
                            "WHERE s.bus_id=?";
        PreparedStatement psCheck = con.prepareStatement(checkQuery);
        psCheck.setInt(1, busId);
        ResultSet rs = psCheck.executeQuery();
        rs.next();
        int bookingCount = rs.getInt(1);
        rs.close();
        psCheck.close();

        if(bookingCount > 0) {
            // Prevent delete if bookings exist
            response.sendRedirect("manageBuses.jsp?error=Cannot delete bus. Bookings exist.");
        } else {
            // Delete seats first
            PreparedStatement ps1 = con.prepareStatement("DELETE FROM seats WHERE bus_id=?");
            ps1.setInt(1, busId);
            ps1.executeUpdate();
            ps1.close();

            // Delete schedules (this will also delete schedule_seats if ON DELETE CASCADE set)
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM schedules WHERE bus_id=?");
            ps2.setInt(1, busId);
            ps2.executeUpdate();
            ps2.close();

            // Finally delete bus
            PreparedStatement ps3 = con.prepareStatement("DELETE FROM buses WHERE bus_id=?");
            ps3.setInt(1, busId);
            ps3.executeUpdate();
            ps3.close();

            response.sendRedirect("manageBuses.jsp?msg=Bus deleted successfully");
        }
    } catch(Exception e) {
        out.println("Error deleting bus: " + e.getMessage());
    }
%>
