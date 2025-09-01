<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String uname = (String) session.getAttribute("username");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
    <style>
        body { background: #f4f6f9; }
        .card {
            transition: transform 0.2s ease-in-out;
            border-radius: 15px;
            min-height: 220px;
        }
        .card:hover { transform: scale(1.05); }
        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
        }
    </style>
</head>
<body>

<!-- 🔹 Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">
    <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" style="height:70px;">
</a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/operators/manageOperators.jsp">Operators</a>
                </li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/buses/manageBuses.jsp">Buses</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/routes/manageRoutes.jsp">Routes</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/drivers/manageDrivers.jsp">Drivers</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/schedules/manageSchedules.jsp">Schedules</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/seats/manageSeats.jsp">Seats</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/bookings/viewBookings.jsp">Bookings</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/payments/managePayments.jsp">Payments</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/admin/users/manageUsers.jsp">Users</a></li>
            </ul>
            <div class="d-flex align-items-center">
                <span class="text-white me-3">Welcome, <%= uname %></span>
                <a href="../logout.jsp" class="btn btn-danger btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

