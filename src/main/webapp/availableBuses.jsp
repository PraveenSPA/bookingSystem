<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String username = (String) session.getAttribute("username");
String redirectURL = request.getRequestURI() + "?" + request.getQueryString();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Available Buses</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showLoginModal() {
            $('#loginModal').modal('show');
            $('#loginModal input[name="redirect"]').val('<%= redirectURL %>');
        }
    </script>
</head>
<body class="container mt-5">
<h2 class="mb-4 text-primary">Available Buses</h2>

<%
PreparedStatement ps = null;
ResultSet rs = null;
try {
    String fromCityParam = request.getParameter("from_city_id");
    String toCityParam   = request.getParameter("to_city_id");
    String travelDate    = request.getParameter("travel_date");

    if (fromCityParam == null || toCityParam == null || travelDate == null) {
%>
    <div class="alert alert-danger">⚠ Missing search parameters. Please go back and try again.</div>
<%
    } else {
        int fromCity = Integer.parseInt(fromCityParam);
        int toCity   = Integer.parseInt(toCityParam);

        String sql = "SELECT s.schedule_id, b.bus_number, b.bus_type, s.departure_datetime, s.arrival_datetime, s.fare " +
                     "FROM Schedules s " +
                     "JOIN Routes r ON s.route_id = r.route_id " +
                     "JOIN Buses b ON s.bus_id = b.bus_id " +
                     "WHERE r.from_city_id=? AND r.to_city_id=? AND DATE(s.departure_datetime)=? " +
                     "ORDER BY s.departure_datetime ASC";

        ps = con.prepareStatement(sql);
        ps.setInt(1, fromCity);
        ps.setInt(2, toCity);
        ps.setString(3, travelDate);

        rs = ps.executeQuery();
        if (!rs.isBeforeFirst()) {
%>
    <div class="alert alert-warning">🚍 No buses found for the selected route and date.</div>
<%
        } else {
%>
    <table class="table table-bordered table-hover">
        <thead class="table-dark">
            <tr>
                <th>Bus Number</th><th>Type</th><th>Departure</th><th>Arrival</th><th>Fare</th><th>Action</th>
            </tr>
        </thead>
        <tbody>
<%
            while(rs.next()){
                int scheduleId = rs.getInt("schedule_id");
%>
            <tr>
                <td><%= rs.getString("bus_number") %></td>
                <td><%= rs.getString("bus_type") %></td>
                <td><%= rs.getTimestamp("departure_datetime") %></td>
                <td><%= rs.getTimestamp("arrival_datetime") %></td>
                <td>₹ <%= rs.getDouble("fare") %></td>
                <td>
<%
                if(username != null){
%>
                    <a href="selectSeats.jsp?schedule_id=<%= scheduleId %>" class="btn btn-success btn-sm">Select Seat</a>
<%
                } else {
%>
                    <button class="btn btn-primary btn-sm" onclick="showLoginModal()">Sign In to Book</button>
<%
                }
%>
                </td>
            </tr>
<%
            }
%>
        </tbody>
    </table>
<%
        }
    }
} catch(Exception e){
%>
    <div class="alert alert-danger">❌ Error fetching buses: <%= e.getMessage() %></div>
<%
} finally {
    if(rs!=null) try{ rs.close(); } catch(Exception ignore){}
    if(ps!=null) try{ ps.close(); } catch(Exception ignore){}
}
%>

<!-- Login Modal -->
<%@ include file="loginModal.jsp" %>
</body>
</html>
