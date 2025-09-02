
<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String txn = request.getParameter("txn");
if (txn == null || txn.trim().isEmpty()) {
    out.println("<p style='color:red'>Missing transaction ID.</p>");
    return;
}

PreparedStatement ps = null;
ResultSet rs = null;

String method = "", status = "", paymentDate = "";
double amount = 0.0;
int paymentId = 0;

try {
    // load payment by txn
    ps = con.prepareStatement(
        "SELECT payment_id, amount, payment_method, status, payment_date " +
        "FROM payments WHERE transaction_id=?"
    );
    ps.setString(1, txn);
    rs = ps.executeQuery();
    if (rs.next()) {
        paymentId = rs.getInt("payment_id");
        amount = rs.getDouble("amount");
        method = rs.getString("payment_method");
        status = rs.getString("status");
        paymentDate = rs.getString("payment_date");
    } else {
        out.println("<p style='color:red'>Invalid transaction ID.</p>");
        return;
    }
    rs.close(); ps.close();

    // load linked bookings
    ps = con.prepareStatement(
        "SELECT booking_id FROM payment_bookings WHERE payment_id=? ORDER BY booking_id"
    );
    ps.setInt(1, paymentId);
    rs = ps.executeQuery();

    java.util.List<Integer> bids = new java.util.ArrayList<>();
    while (rs.next()) bids.add(rs.getInt(1));
    rs.close(); ps.close();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Payment Success</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="container mt-4">
  <h2 class="text-success">Payment Successful ✅</h2>
  <div class="card p-3 mb-3">
    <div><strong>Transaction ID:</strong> <%= txn %></div>
    <div><strong>Payment Date:</strong> <%= paymentDate %></div>
    <div><strong>Method:</strong> <%= method %></div>
    <div><strong>Status:</strong> <%= status %></div>
    <div class="mt-2"><strong>Total Paid:</strong> ₹<%= String.format(java.util.Locale.US, "%.2f", amount) %></div>
    
  </div>
  <a href="userDashboard.jsp" class="btn btn-primary">Back to Home</a>
</body>
</html>

<%
} catch (Exception e) {
    out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
    e.printStackTrace();
}
%>
    