<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // ✅ Use session user_id directly
    Integer userId = (Integer) session.getAttribute("user_id");
    if(userId == null){
        out.println("<p class='text-danger'>Please login to view your bookings.</p>");
        return;
    }

    // Get date filters
    String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");

    // SQL to fetch bookings with route/cities/payment
    String sql = "SELECT b.booking_id, b.booking_date, b.status AS booking_status, " +
                 "b.payment_status, b.seats_booked, " +
                 "s.departure_datetime, s.arrival_datetime, s.fare, " +
                 "r.distance_km, r.estimated_time, " +
                 "c_from.city_name AS from_city, c_to.city_name AS to_city, " +
                 "p.amount, p.payment_method, p.status AS payment_status_final " +
                 "FROM bookings b " +
                 "JOIN schedules s ON b.schedule_id = s.schedule_id " +
                 "JOIN routes r ON s.route_id = r.route_id " +
                 "JOIN cities c_from ON r.from_city_id = c_from.city_id " +
                 "JOIN cities c_to ON r.to_city_id = c_to.city_id " +
                 "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                 "WHERE b.user_id = ?";

    if(fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()){
        sql += " AND DATE(b.booking_date) BETWEEN ? AND ? ";
    }

    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, userId);
    if(fromDate != null && toDate != null && !fromDate.isEmpty() && !toDate.isEmpty()){
        ps.setString(2, fromDate);
        ps.setString(3, toDate);
    }

    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Bookings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <style>
        .status-Booked { color: #0d6efd; font-weight: 600; }
        .status-Completed { color: #198754; font-weight: 600; }
        .status-Cancelled { color: #dc3545; font-weight: 600; }
        .payment-Pending { color: #ffc107; font-weight: 600; }
        .payment-Paid { color: #198754; font-weight: 600; }
        .payment-Refunded { color: #dc3545; font-weight: 600; }
    </style>
</head>
<body class="container mt-4">

<h2 class="mb-3 text-primary">My Booking History</h2>

<!-- Date Filter -->
<form method="get" class="row g-3 mb-3">
    <div class="col-auto">
        <label class="form-label">From</label>
        <input type="date" name="fromDate" value="<%= (fromDate!=null?fromDate:"") %>" class="form-control">
    </div>
    <div class="col-auto">
        <label class="form-label">To</label>
        <input type="date" name="toDate" value="<%= (toDate!=null?toDate:"") %>" class="form-control">
    </div>
    <div class="col-auto align-self-end">
        <button type="submit" class="btn btn-primary">Filter</button>
        <a href="userBookings.jsp" class="btn btn-secondary">Reset</a>
    </div>
</form>

<!-- Bookings Table -->
<table id="bookingsTable" class="table table-bordered table-striped">
    <thead class="table-dark">
        <tr>
            <th>Booking ID</th>
            <th>Booking Date</th>
            <th>Journey</th>
            <th>Departure</th>
            <th>Arrival</th>
            <th>Seats</th>
            <th>Fare</th>
            <th>Status</th>
            <th>Payment Method</th>
            <th>Payment Status</th>
        </tr>
    </thead>
    <tbody>
    <%
        while(rs.next()){
            String bookingStatus = rs.getString("booking_status");
            String paymentStatus = rs.getString("payment_status_final") != null ? rs.getString("payment_status_final") : rs.getString("payment_status");
    %>
        <tr>
            <td><%= rs.getInt("booking_id") %></td>
            <td><%= rs.getTimestamp("booking_date") %></td>
            <td><%= rs.getString("from_city") %> → <%= rs.getString("to_city") %></td>
            <td><%= rs.getTimestamp("departure_datetime") %></td>
            <td><%= rs.getTimestamp("arrival_datetime") %></td>
            <td><%= rs.getInt("seats_booked") %></td>
            <td>₹<%= rs.getDouble("fare") %></td>
            <td class="status-<%= bookingStatus %>"><%= bookingStatus %></td>
            <td><%= rs.getString("payment_method") != null ? rs.getString("payment_method") : "-" %></td>
            <td class="payment-<%= paymentStatus %>"><%= paymentStatus %></td>
        </tr>
    <%
        }
        rs.close(); ps.close(); con.close();
    %>
    </tbody>
</table>

<script>
$(document).ready(function(){
    $('#bookingsTable').DataTable({
        "pageLength": 5,
        "lengthChange": false,
        "ordering": true,
        "searching": true
    });
});
</script>

</body>
</html>
