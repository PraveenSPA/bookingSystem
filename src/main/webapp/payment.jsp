<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String idsParam = request.getParameter("booking_ids");
if (idsParam == null || idsParam.trim().isEmpty()) {
    out.println("<p style='color:red'>No bookings selected!</p>");
    return;
}

String[] idParts = idsParam.split(",");
List<Integer> bookingIds = new ArrayList<>();
for (String p : idParts) {
    try { bookingIds.add(Integer.parseInt(p.trim())); } catch(Exception ex){}
}
if (bookingIds.isEmpty()) {
    out.println("<p style='color:red'>Invalid booking IDs!</p>");
    return;
}

// Build IN clause
String inClause = String.join(",", Collections.nCopies(bookingIds.size(), "?"));

// Compute total fare from DB
double totalAmount = 0.0;
PreparedStatement psSum = con.prepareStatement(
    "SELECT SUM(ss.fare) AS totalFare " +
    "FROM bookings b JOIN schedule_seats ss ON b.schedule_seat_id=ss.schedule_seat_id " +
    "WHERE b.booking_id IN (" + inClause + ")"
);
for (int i=0; i<bookingIds.size(); i++) psSum.setInt(i+1, bookingIds.get(i));
ResultSet rsSum = psSum.executeQuery();
if (rsSum.next()) totalAmount = rsSum.getDouble("totalFare");
rsSum.close(); psSum.close();

// Fetch journey info from first booking
PreparedStatement psInfo = con.prepareStatement(
  "SELECT c1.city_name AS from_city, c2.city_name AS to_city, " +
  "s.departure_datetime, s.arrival_datetime, bu.bus_number, bu.bus_type " +
  "FROM bookings b " +
  "JOIN schedules s ON b.schedule_id=s.schedule_id " +
  "JOIN routes r ON s.route_id=r.route_id " +
  "JOIN cities c1 ON r.from_city_id=c1.city_id " +
  "JOIN cities c2 ON r.to_city_id=c2.city_id " +
  "JOIN buses bu ON s.bus_id=bu.bus_id " +
  "WHERE b.booking_id=? LIMIT 1"
);
psInfo.setInt(1, bookingIds.get(0));
ResultSet rsInfo = psInfo.executeQuery();

String fromCity="", toCity="", dep="", arr="", busNum="", busType="";
if (rsInfo.next()) {
    fromCity = rsInfo.getString("from_city");
    toCity   = rsInfo.getString("to_city");
    dep      = rsInfo.getTimestamp("departure_datetime").toString();
    arr      = rsInfo.getTimestamp("arrival_datetime").toString();
    busNum   = rsInfo.getString("bus_number");
    busType  = rsInfo.getString("bus_type");
}
rsInfo.close(); psInfo.close();

int seatCount = bookingIds.size();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Payment</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
  <h2 class="mb-3">Payment</h2>

  <div class="card p-3 mb-3">
    <h5>Trip Details</h5>
    <div><strong>From:</strong> <%= fromCity %> &nbsp; <strong>To:</strong> <%= toCity %></div>
    <div><strong>Departure:</strong> <%= dep %> &nbsp; <strong>Arrival:</strong> <%= arr %></div>
    <div><strong>Bus:</strong> <%= busNum %> (<%= busType %>)</div>
    <div><strong>Seats:</strong> <%= seatCount %></div>
    <div class="mt-2 alert alert-info">
    <strong>Total Amount Payable:</strong> ₹<%= String.format(java.util.Locale.US, "%.2f", totalAmount) %></div>
  </div>

  <form action="processPayment.jsp" method="post">
    <input type="hidden" name="booking_ids" value="<%= idsParam %>">
    <input type="hidden" name="amount" value="<%= totalAmount %>">

    <div class="mb-3">
      <label class="form-label">Payment Method</label>
      <select name="payment_method" class="form-select" required>
        <option value="UPI">UPI</option>
        <option value="Credit Card">Credit Card</option>
        <option value="Debit Card">Debit Card</option>
        <option value="NetBanking">NetBanking</option>
        <option value="Wallet">Wallet</option>
      </select>
    </div>

    <button type="submit" class="btn btn-success btn-lg">Confirm & Pay</button>
  </form>
</body>
</html>
