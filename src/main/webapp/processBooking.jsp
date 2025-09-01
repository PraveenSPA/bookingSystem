<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String scheduleParam = request.getParameter("schedule_id");
if (scheduleParam == null || scheduleParam.isEmpty()) {
    out.println("<p style='color:red'>Error: Schedule missing!</p>");
    return;
}
int scheduleId = Integer.parseInt(scheduleParam);

String[] seats = request.getParameterValues("seats");
if (seats == null || seats.length == 0) {
    out.println("<p style='color:red'>Error: No seats selected!</p>");
    return;
}

// In real app, user_id from session
int userId = 1;

Connection conn = null;
PreparedStatement psFindSS = null;
PreparedStatement psInsertSS = null;
PreparedStatement psBooking = null;
PreparedStatement psPassenger = null;

List<Integer> bookingIds = new ArrayList<>();

try {
    conn = con;
    conn.setAutoCommit(false);

    // prepare insert booking
    psBooking = conn.prepareStatement(
        "INSERT INTO bookings (user_id, schedule_id, schedule_seat_id, status, payment_status) VALUES (?,?,?,?,?)",
        Statement.RETURN_GENERATED_KEYS
    );

    for (String seat : seats) {
        // 1) find schedule_seat_id for this seat
        psFindSS = conn.prepareStatement(
            "SELECT ss.schedule_seat_id " +
            "FROM schedule_seats ss " +
            "JOIN seats st ON ss.seat_id=st.seat_id " +
            "WHERE ss.schedule_id=? AND st.seat_number=?"
        );
        psFindSS.setInt(1, scheduleId);
        psFindSS.setString(2, seat);
        ResultSet rs = psFindSS.executeQuery();

        int scheduleSeatId = 0;
        if (rs.next()) scheduleSeatId = rs.getInt(1);
        rs.close();
        psFindSS.close();

        // 2) if not present, create schedule seat row
        if (scheduleSeatId == 0) {
            psInsertSS = conn.prepareStatement(
                "INSERT INTO schedule_seats (schedule_id, seat_id, is_booked, fare) " +
                "SELECT ?, st.seat_id, 0, COALESCE(s.fare, 0) " +
                "FROM seats st JOIN schedules s ON s.bus_id=st.bus_id " +
                "WHERE s.schedule_id=? AND st.seat_number=?",
                Statement.RETURN_GENERATED_KEYS
            );
            psInsertSS.setInt(1, scheduleId);
            psInsertSS.setInt(2, scheduleId);
            psInsertSS.setString(3, seat);
            psInsertSS.executeUpdate();
            ResultSet rsk = psInsertSS.getGeneratedKeys();
            if (rsk.next()) scheduleSeatId = rsk.getInt(1);
            rsk.close();
            psInsertSS.close();
        }

        // 3) insert booking as Pending (not paid yet)
        psBooking.setInt(1, userId);
        psBooking.setInt(2, scheduleId);
        psBooking.setInt(3, scheduleSeatId);
        psBooking.setString(4, "Pending");
        psBooking.setString(5, "Pending");
        psBooking.executeUpdate();

        ResultSet bkKeys = psBooking.getGeneratedKeys();
        int bookingId = 0;
        if (bkKeys.next()) bookingId = bkKeys.getInt(1);
        bkKeys.close();
        bookingIds.add(bookingId);

        // 4) passenger row
        psPassenger = conn.prepareStatement(
            "INSERT INTO booking_passengers (booking_id, seat_number, name, gender, age, phone) VALUES (?,?,?,?,?,?)"
        );
        psPassenger.setInt(1, bookingId);
        psPassenger.setString(2, seat);
        psPassenger.setString(3, request.getParameter("passenger_name_" + seat));
        psPassenger.setString(4, request.getParameter("passenger_gender_" + seat));
        psPassenger.setInt(5, Integer.parseInt(request.getParameter("passenger_age_" + seat)));
        psPassenger.setString(6, request.getParameter("passenger_phone_" + seat));
        psPassenger.executeUpdate();
        psPassenger.close();
    }

    conn.commit();

    // redirect to payment with all booking_ids
    StringBuilder sb = new StringBuilder();
    for (int i=0;i<bookingIds.size();i++) {
        if (i>0) sb.append(",");
        sb.append(bookingIds.get(i));
    }
    response.sendRedirect("payment.jsp?booking_ids=" + sb.toString());

} catch (Exception e) {
    if (conn != null) conn.rollback();
    out.println("<p style='color:red'>Error: "+e.getMessage()+"</p>");
    e.printStackTrace();
} finally {
    if (psFindSS != null) psFindSS.close();
    if (psInsertSS != null) psInsertSS.close();
    if (psBooking != null) psBooking.close();
    if (psPassenger != null) psPassenger.close();
    if (conn != null) conn.setAutoCommit(true);
}
%>
