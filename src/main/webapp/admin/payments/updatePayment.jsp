<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    String msg = "";
    int paymentId = 0;
    ResultSet rs = null;
    PreparedStatement ps = null;

    // ✅ Handle update form submission
    if("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            int bookingId = Integer.parseInt(request.getParameter("booking_id"));
            String method = request.getParameter("payment_method");
            String txnId = request.getParameter("transaction_id");
            String status = request.getParameter("status");

            // Update payment
            ps = con.prepareStatement(
                "UPDATE Payments SET payment_method=?, transaction_id=?, status=? WHERE booking_id=?"
            );
            ps.setString(1, method);
            ps.setString(2, txnId);
            ps.setString(3, status);
            ps.setInt(4, bookingId);
            ps.executeUpdate();
            msg = "✅ Payment updated successfully!";
        } catch(Exception e){
            msg = "❌ Error updating payment: " + e.getMessage();
        }
    }

    // ✅ Fetch payment details for display
    try {
        int bookingId = Integer.parseInt(request.getParameter("booking_id"));
        ps = con.prepareStatement(
            "SELECT p.*, u.full_name, u.email " +
            "FROM Payments p " +
            "JOIN Bookings b ON p.booking_id = b.booking_id " +
            "JOIN Users u ON b.user_id = u.user_id " +
            "WHERE p.booking_id=?"
        );
        ps.setInt(1, bookingId);
        rs = ps.executeQuery();
    } catch(Exception e){
        msg = "❌ Error fetching payment: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Payment</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-4">

    <% if(!msg.isEmpty()){ %>
        <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <h3 class="mb-4 text-primary">Update Payment</h3>
    <div class="card p-3">
        <% if(rs != null && rs.next()){ %>
        <form method="post">
            <input type="hidden" name="booking_id" value="<%= rs.getInt("booking_id") %>">

            <p><b>User:</b> <%= rs.getString("full_name") %> (<%= rs.getString("email") %>)</p>
            <p><b>Amount:</b> ₹<%= rs.getBigDecimal("amount") %></p>
            <p><b>Txn ID:</b> <%= rs.getString("transaction_id") %></p>
            <p><b>Date:</b> <%= rs.getTimestamp("payment_date") %></p>

            <div class="mb-3">
                <label class="form-label">Payment Method</label>
                <input type="text" name="payment_method" value="<%= rs.getString("payment_method") %>" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Transaction ID</label>
                <input type="text" name="transaction_id" value="<%= rs.getString("transaction_id") %>" class="form-control" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Status</label>
                <select name="status" class="form-select" required>
                    <option value="Success" <%= rs.getString("status").equals("Success")?"selected":"" %>>Success</option>
                    <option value="Failed" <%= rs.getString("status").equals("Failed")?"selected":"" %>>Failed</option>
                    <option value="Pending" <%= rs.getString("status").equals("Pending")?"selected":"" %>>Pending</option>
                    <option value="Refunded" <%= rs.getString("status").equals("Refunded")?"selected":"" %>>Refunded</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary">Update</button>
            <a href="managePayments.jsp" class="btn btn-secondary">Cancel</a>
        </form>
        <% } else { %>
            <p class="text-danger">No payment found for this booking.</p>
        <% } %>
    </div>
</div>
</body>
</html>

<%
    if(rs != null) rs.close();
    if(ps != null) ps.close();
    if(con != null) con.close();
%>
