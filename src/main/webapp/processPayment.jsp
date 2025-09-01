<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String idsParam = request.getParameter("booking_ids");
String method   = request.getParameter("payment_method");
String amountParam = request.getParameter("amount");

if (idsParam == null || idsParam.trim().isEmpty()) {
    out.println("<p style='color:red'>Invalid booking!</p>");
    return;
}
if (method == null || method.isEmpty()) {
    out.println("<p style='color:red'>Payment method required!</p>");
    return;
}

String[] idParts = idsParam.split(",");
List<Integer> bookingIds = new ArrayList<>();
for (String p : idParts) {
    try { bookingIds.add(Integer.parseInt(p.trim())); } catch(Exception ex){}
}
if (bookingIds.isEmpty()) {
    out.println("<p style='color:red'>Invalid booking!</p>");
    return;
}

// We'll recompute total from DB (trust server over client)
String inClause = String.join(",", java.util.Collections.nCopies(bookingIds.size(), "?"));
double grandTotal = 0.0;

Connection conn = null;
try {
    conn = con;
    conn.setAutoCommit(false);

    // Get each booking's seat fare
    PreparedStatement psEach = conn.prepareStatement(
        "SELECT b.booking_id, ss.fare " +
        "FROM bookings b JOIN schedule_seats ss ON b.schedule_seat_id=ss.schedule_seat_id " +
        "WHERE b.booking_id IN (" + inClause + ")"
    );
    for (int i=0;i<bookingIds.size();i++) psEach.setInt(i+1, bookingIds.get(i));
    ResultSet rsEach = psEach.executeQuery();

    Map<Integer, Double> fareByBooking = new HashMap<>();
    while (rsEach.next()) {
        int bid = rsEach.getInt("booking_id");
        double f = rsEach.getDouble("fare");
        fareByBooking.put(bid, f);
        grandTotal += f;
    }
    rsEach.close(); psEach.close();

    // Fake gateway transaction id
    String txnId = "TXN" + System.currentTimeMillis();

    // Insert one payment row per booking_id (schema requires booking_id in Payments)
    PreparedStatement psPay = conn.prepareStatement(
        "INSERT INTO payments (booking_id, amount, payment_method, transaction_id, status) VALUES (?,?,?,?,?)"
    );
    for (Integer bid : bookingIds) {
        psPay.setInt(1, bid);
        psPay.setDouble(2, fareByBooking.getOrDefault(bid, 0.0));
        psPay.setString(3, method);
        psPay.setString(4, txnId);
        psPay.setString(5, "Success");
        psPay.executeUpdate();
    }
    psPay.close();

    // Update bookings to Booked/Paid
    PreparedStatement psUpd = conn.prepareStatement(
        "UPDATE bookings SET status='Booked', payment_status='Paid' WHERE booking_id IN (" + inClause + ")"
    );
    for (int i=0;i<bookingIds.size();i++) psUpd.setInt(i+1, bookingIds.get(i));
    psUpd.executeUpdate();
    psUpd.close();

    // Mark seats as booked
    PreparedStatement psSeat = conn.prepareStatement(
        "UPDATE schedule_seats ss " +
        "JOIN bookings b ON ss.schedule_seat_id=b.schedule_seat_id " +
        "SET ss.is_booked=1 " +
        "WHERE b.booking_id IN (" + inClause + ")"
    );
    for (int i=0;i<bookingIds.size();i++) psSeat.setInt(i+1, bookingIds.get(i));
    psSeat.executeUpdate();
    psSeat.close();

    conn.commit();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Payment Success</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
  <h2 class="text-success">Payment Successful ✅</h2>
  <p><strong>Transaction ID:</strong> <%= "TXN" + System.currentTimeMillis() %></p>
  <p><strong>Bookings:</strong> <%= idsParam %></p>
  <p><strong>Total Paid:</strong> ₹<%= String.format(java.util.Locale.US, "%.2f", grandTotal) %></p>
  <div class="mt-3">
    <a href="dashboard.jsp" class="btn btn-primary">Back to Home</a>
  </div>
</body>
</html>

<%
} catch (Exception e) {
    if (conn != null) conn.rollback();
    out.println("<p style='color:red'>Payment Error: " + e.getMessage() + "</p>");
    e.printStackTrace();
} finally {
    if (conn != null) conn.setAutoCommit(true);
}
%>
