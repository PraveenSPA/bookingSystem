<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<%
    String role1 = (String) session.getAttribute("role");
    if(role1 == null || !"admin".equals(role1)){
        response.sendRedirect("../login.jsp");
        return;
    }

    // Pagination
    String pageStr = request.getParameter("page");
    int pageNum = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
    int limit = 10;
    int offset = (pageNum - 1) * limit;

    // Count total records
    int totalRecords = 0;
    Statement countSt = con.createStatement();
    ResultSet countRs = countSt.executeQuery("SELECT COUNT(*) FROM Payments");
    if(countRs.next()) totalRecords = countRs.getInt(1);
    countRs.close(); countSt.close();
    int totalPages = (int)Math.ceil((double)totalRecords / limit);

    // Main query
    String sql = "SELECT p.payment_id, p.amount, p.payment_method, p.transaction_id, " +
                 "p.payment_date, p.status, u.full_name, u.email " +
                 "FROM Payments p " +
                 "JOIN Bookings b ON p.booking_id = b.booking_id " +
                 "JOIN Users u ON b.user_id = u.user_id " +
                 "ORDER BY p.payment_id DESC " +
                 "LIMIT " + offset + ", " + limit;
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(sql);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Payments</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-4">
    <h3 class="mb-4 text-primary">Manage Payments</h3>
    <% if(session.getAttribute("msg") != null){ %>
        <div class="alert alert-info"><%= session.getAttribute("msg") %></div>
        <% session.removeAttribute("msg"); %>
    <% } %>

    <div class="card p-3">
        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>User</th>
                    <th>Email</th>
                    <th>Amount</th>
                    <th>Method</th>
                    <th>Txn ID</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while(rs.next()){
                %>
                <tr>
                    <td><%= rs.getInt("payment_id") %></td>
                    <td><%= rs.getString("full_name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td>₹<%= rs.getBigDecimal("amount") %></td>
                    <td><%= rs.getString("payment_method") %></td>
                    <td><%= rs.getString("transaction_id") %></td>
                    <td><%= rs.getTimestamp("payment_date") %></td>
                    <td>
                        <span class="badge 
                            <%= rs.getString("status").equals("Success") ? "bg-success" : 
                                rs.getString("status").equals("Failed") ? "bg-danger" :
                                rs.getString("status").equals("Refunded") ? "bg-warning" : "bg-secondary" %>">
                            <%= rs.getString("status") %>
                        </span>
                    </td>
                    <td>
                        <a href="updatePayment.jsp?id=<%= rs.getInt("payment_id") %>" 
                           class="btn btn-sm btn-primary">Update</a>
                    </td>
                </tr>
                <%
                    }
                    rs.close(); st.close();
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
