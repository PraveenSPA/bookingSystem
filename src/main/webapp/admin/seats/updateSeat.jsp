<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("seat_id"));
    String seatNumber = request.getParameter("seat_number");
    String seatType = request.getParameter("seat_type");
    int isReserved = Integer.parseInt(request.getParameter("is_reserved"));

    PreparedStatement ps = con.prepareStatement(
        "UPDATE Seats SET seat_number=?, seat_type=?, is_reserved=? WHERE seat_id=?");
    ps.setString(1, seatNumber);
    ps.setString(2, seatType);
    ps.setInt(3, isReserved);
    ps.setInt(4, id);

    ps.executeUpdate();
    ps.close();
    con.close();

    // redirect back to manageSeats with preserved paging/filter
    String pageNum = request.getParameter("page");
    String limit = request.getParameter("limit");
    String busId = request.getParameter("bus_id");

    if(pageNum == null) pageNum = "1";
    if(limit == null) limit = "50";

    String redirect = "manageSeats.jsp?page=" + pageNum + "&limit=" + limit;
    if(busId != null && !busId.isEmpty()){
        redirect += "&bus_id=" + URLEncoder.encode(busId, "UTF-8");
    }
    response.sendRedirect(redirect);
%>
