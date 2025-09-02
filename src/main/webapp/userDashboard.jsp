<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Bus Booking - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
    body {
        font-family: 'Roboto', sans-serif;
        background: linear-gradient(135deg, #f5f7fa, #e4e7eb);
        min-height: 100vh;
    }

    .dashboard-card {
        max-width: 720px;
        margin: 80px auto;
        background: #ffffffcc; /* semi-transparent */
        padding: 40px 30px;
        border-radius: 20px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .dashboard-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 15px 35px rgba(0, 0, 0, 0.25);
    }

    .logo-container {
        text-align: center;
    }

    .logo {
        height: 130px;
        width: auto;
        border-radius: 12px;
    }

    .form-label {
        font-size: 0.95rem;
        color: #333;
    }

    .btn-outline-primary, .btn-outline-success {
        font-weight: 500;
    }

    /* Responsive adjustments */
    @media (max-width: 576px) {
        .dashboard-card {
            margin: 40px 20px;
            padding: 30px 20px;
        }
    }
</style>
    <script>
        $(document).ready(function() {
            $('#from_city, #to_city').select2({ placeholder: "Search City...", allowClear:true });
        });
        function setToday(){ document.getElementById("travel_date").value = new Date().toISOString().split('T')[0]; }
        function setTomorrow(){ let d = new Date(); d.setDate(d.getDate()+1); document.getElementById("travel_date").value = d.toISOString().split('T')[0]; }
        function showLoginModal(){ $('#loginModal').modal('show'); }
        function showRegisterModal(){ $('#registerModal').modal('show'); }
        function showForgotModal(){ $('#forgotModal').modal('show'); }
    </script>
</head>
<body>

<div class="position-absolute top-0 end-0 p-3">
    <% if(username == null){ %>
        <button class="btn btn-sm btn-outline-primary me-2" onclick="showLoginModal()">Login</button>
        <button class="btn btn-sm btn-outline-success" onclick="showRegisterModal()">Sign Up</button>
    <% } else { %>
        <span class="text-username me-2">Welcome, <%= username %></span>
    <a href="userBookings.jsp" class="btn btn-sm btn-outline-primary">My Bookings</a>
        <a href="logout.jsp" class="btn btn-sm btn-outline-danger">Logout</a>
    <% } %>
</div>


<div class="dashboard-card shadow-lg p-4 rounded-4">
    <!-- Logo -->
    <div class="logo-container mb-4">
        <img src="images/logo.png" class="logo img-fluid" alt="Logo">
    </div>

    <!-- Search Form -->
    <form method="get" action="availableBuses.jsp">
        <div class="row g-3 mb-3">
            <!-- From City -->
            <div class="col-md-6">
                <label class="form-label fw-semibold">From City</label>
                <select id="from_city" name="from_city_id" class="form-select" required>
                    <option value="">-- Select City --</option>
                    <%
                        Statement st1 = con.createStatement();
                        ResultSet rs1 = st1.executeQuery("SELECT * FROM Cities ORDER BY city_name");
                        while(rs1.next()){ %>
                            <option value="<%= rs1.getInt("city_id") %>"><%= rs1.getString("city_name") %></option>
                        <% } rs1.close(); st1.close(); %>
                </select>
            </div>

            <!-- To City -->
            <div class="col-md-6">
                <label class="form-label fw-semibold">To City</label>
                <select id="to_city" name="to_city_id" class="form-select" required>
                    <option value="">-- Select City --</option>
                    <%
                        Statement st2 = con.createStatement();
                        ResultSet rs2 = st2.executeQuery("SELECT * FROM Cities ORDER BY city_name");
                        while(rs2.next()){ %>
                            <option value="<%= rs2.getInt("city_id") %>"><%= rs2.getString("city_name") %></option>
                        <% } rs2.close(); st2.close(); %>
                </select>
            </div>
        </div>

        <div class="row g-3 mb-4 align-items-end">
            <!-- Travel Date -->
            <div class="col-md-8">
                <label class="form-label fw-semibold">Travel Date</label>
                <input type="date" id="travel_date" name="travel_date" class="form-control shadow-sm" required>
            </div>

            <!-- Quick Buttons -->
            <div class="col-md-4 d-flex gap-2">
                <button type="button" class="btn btn-outline-primary w-50" onclick="setToday()">Today</button>
                <button type="button" class="btn btn-outline-success w-50" onclick="setTomorrow()">Tomorrow</button>
            </div>
        </div>

        <!-- Submit Button -->
        <div class="text-center">
            <button type="submit" class="btn btn-success btn-lg px-5 shadow-sm">Search Buses</button>
        </div>
    </form>
</div>

<!-- Include login/register/forgot modals -->
<%@ include file="loginModal.jsp" %>
<%@ include file="registerModal.jsp" %>
<%@ include file="forgotModal.jsp" %>

</body>
</html>
