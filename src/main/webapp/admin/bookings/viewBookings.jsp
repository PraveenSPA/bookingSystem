<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String pageStr = request.getParameter("page");
    int pageNum = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
    int limit = 10;
    int offset = (pageNum - 1) * limit;

    // Count total bookings
    int totalRecords = 0;
    Statement countSt = con.createStatement();
    ResultSet countRs = countSt.executeQuery("SELECT COUNT(*) FROM Bookings");
    if (countRs.next()) totalRecords = countRs.getInt(1);
    countRs.close(); 
    countSt.close();

    int totalPages = (int) Math.ceil((double) totalRecords / limit);

    // Main query with cities
    String sql = "SELECT bk.booking_id, bk.booking_date, bk.status AS booking_status, bk.payment_status, " +
                 "u.full_name, u.email, u.phone, " +
                 "b.bus_number, b.bus_type, " +
                 "fc.city_name AS from_city, tc.city_name AS to_city, " +
                 "s.departure_datetime, s.arrival_datetime, s.fare AS schedule_fare, s.status AS schedule_status, " +
                 "st.seat_number " +
                 "FROM Bookings bk " +
                 "JOIN Users u ON bk.user_id = u.user_id " +
                 "JOIN Schedules s ON bk.schedule_id = s.schedule_id " +
                 "JOIN Buses b ON s.bus_id = b.bus_id " +
                 "JOIN Routes r ON s.route_id = r.route_id " +
                 "JOIN Cities fc ON r.from_city_id = fc.city_id " +
                 "JOIN Cities tc ON r.to_city_id = tc.city_id " +
                 "JOIN Schedule_Seats ss ON bk.schedule_seat_id = ss.schedule_seat_id " +
                 "JOIN Seats st ON ss.seat_id = st.seat_id " +
                 "ORDER BY bk.booking_id DESC " +
                 "LIMIT " + offset + ", " + limit;

    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(sql);
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Bookings</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">
    <h3 class="mb-4 text-primary">Manage Bookings</h3>

    <div class="card p-3">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Bus</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Seat</th>
                    <th>Fare</th>
                    <th>Status</th>
                    <th>Payment</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("booking_id") %></td>
                    <td><%= rs.getString("full_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("bus_number") %> (<%= rs.getString("bus_type") %>)</td>
                    <td><%= rs.getString("from_city") %> → <%= rs.getString("to_city") %></td>
                    <td><%= rs.getTimestamp("departure_datetime") %></td>
                    <td><%= rs.getTimestamp("arrival_datetime") %></td>
                    <td><%= rs.getString("seat_number") %></td>
                    <td><%= rs.getBigDecimal("schedule_fare") %></td>
                    <td><%= rs.getString("booking_status") %></td>
                    <td><%= rs.getString("payment_status") %></td>
                    <td>
                        <a href="deleteBooking.jsp?id=<%= rs.getInt("booking_id") %>"
                           onclick="return confirm('Are you sure you want to delete this booking?');"
                           class="btn btn-sm btn-danger">Delete</a>
                    </td>
                </tr>
                <%
                    } // ✅ close while loop
                    rs.close();
                    st.close();
                %>
            </tbody>
        </table>

        <!-- Pagination -->
        <nav>
            <ul class="pagination justify-content-center">
                <li class="page-item <%= (pageNum == 1) ? "disabled" : "" %>">
                    <a class="page-link" href="?page=<%= pageNum - 1 %>">Prev</a>
                </li>
                <li class="page-item disabled">
                    <span class="page-link">Page <%= pageNum %> of <%= totalPages %></span>
                </li>
                <li class="page-item <%= (pageNum >= totalPages) ? "disabled" : "" %>">
                    <a class="page-link" href="?page=<%= pageNum + 1 %>">Next</a>
                </li>
            </ul>
        </nav>
    </div>
</div>
</body>
</html>
