<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/adminHeader.jsp" %>

<!-- 🔹 Dashboard Content -->
<div class="container mt-5">
    <div class="row g-4 justify-content-center">

        <!-- Operators -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-primary text-white mx-auto mb-3">
                    <i class="bi bi-building-fill"></i>
                </div>
                <h5 class="card-title">Manage Operators</h5>
                <a href="operators/manageOperators.jsp" class="btn btn-primary mt-2">Open</a>
            </div>
        </div>

        <!-- Buses -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-success text-white mx-auto mb-3">
                    <i class="bi bi-bus-front-fill"></i>
                </div>
                <h5 class="card-title">Manage Buses</h5>
                <a href="buses/manageBuses.jsp" class="btn btn-success mt-2">Open</a>
            </div>
        </div>

        <!-- Routes -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-warning text-white mx-auto mb-3">
                    <i class="bi bi-geo-alt-fill"></i>
                </div>
                <h5 class="card-title">Manage Routes</h5>
                <a href="routes/manageRoutes.jsp" class="btn btn-warning mt-2">Open</a>
            </div>
        </div>

        <!-- Drivers -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-info text-white mx-auto mb-3">
                    <i class="bi bi-person-badge-fill"></i>
                </div>
                <h5 class="card-title">Manage Drivers</h5>
                <a href="drivers/manageDrivers.jsp" class="btn btn-info mt-2">Open</a>
            </div>
        </div>

        <!-- Schedules -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-danger text-white mx-auto mb-3">
                    <i class="bi bi-calendar2-event-fill"></i>
                </div>
                <h5 class="card-title">Manage Schedules</h5>
                <a href="schedules/manageSchedules.jsp" class="btn btn-danger mt-2">Open</a>
            </div>
        </div>

        <!-- Seats -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-dark text-white mx-auto mb-3">
                    <i class="bi bi-grid-3x3-gap-fill"></i>
                </div>
                <h5 class="card-title">Manage Seats</h5>
                <a href="seats/manageSeats.jsp" class="btn btn-dark mt-2">Open</a>
            </div>
        </div>

        <!-- Bookings -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-secondary text-white mx-auto mb-3">
                    <i class="bi bi-ticket-perforated-fill"></i>
                </div>
                <h5 class="card-title">View Bookings</h5>
                <a href="bookings/viewBookings.jsp" class="btn btn-secondary mt-2">Open</a>
            </div>
        </div>

        <!-- Payments -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-primary text-white mx-auto mb-3">
                    <i class="bi bi-cash-stack"></i>
                </div>
                <h5 class="card-title">Manage Payments</h5>
                <a href="payments/managePayments.jsp" class="btn btn-primary mt-2">Open</a>
            </div>
        </div>

        <!-- Users -->
        <div class="col-md-3 col-sm-6">
            <div class="card shadow text-center p-4">
                <div class="icon-circle bg-success text-white mx-auto mb-3">
                    <i class="bi bi-people-fill"></i>
                </div>
                <h5 class="card-title">Manage Users</h5>
                <a href="users/manageUsers.jsp" class="btn btn-success mt-2">Open</a>
            </div>
        </div>

    </div>
</div>

<%@ include file="includes/adminFooter.jsp" %>
