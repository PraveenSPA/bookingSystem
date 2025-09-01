<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if(role == null || !"admin".equals(role)){
        response.sendRedirect("../login.jsp");
        return;
    }

    String idStr = request.getParameter("id");
    if(idStr != null){
        int id = Integer.parseInt(idStr);

        try {
            // 1️⃣ Delete passengers linked to this booking
            PreparedStatement ps1 = con.prepareStatement("DELETE FROM booking_passengers WHERE booking_id=?");
            ps1.setInt(1, id);
            ps1.executeUpdate();
            ps1.close();

            // 2️⃣ Delete payments linked to this booking
            PreparedStatement ps2 = con.prepareStatement("DELETE FROM Payments WHERE booking_id=?");
            ps2.setInt(1, id);
            ps2.executeUpdate();
            ps2.close();

            // 3️⃣ Finally delete booking itself
            PreparedStatement ps3 = con.prepareStatement("DELETE FROM Bookings WHERE booking_id=?");
            ps3.setInt(1, id);
            int rows = ps3.executeUpdate();
            ps3.close();

            if(rows > 0){
                session.setAttribute("msg", "Booking deleted successfully!");
            } else {
                session.setAttribute("msg", "Booking not found or already deleted.");
            }

        } catch(Exception e){
            session.setAttribute("msg", "Error deleting booking: " + e.getMessage());
        }
    }
    response.sendRedirect("viewBookings.jsp");
%>
