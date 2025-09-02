<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String scheduleParam = request.getParameter("schedule_id");
double fare = Double.parseDouble(request.getParameter("fare"));
String[] selectedSeats = request.getParameterValues("seats");

if (scheduleParam == null || scheduleParam.isEmpty() || selectedSeats == null) {
    out.println("<p style='color:red'>Error: Missing data!</p>");
    return;
}
int scheduleId = Integer.parseInt(scheduleParam);
double totalAmount = fare * selectedSeats.length;
%>

<!DOCTYPE html>
<html>
<head>
    <title>Confirm Booking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-4">
<h2 class="text-primary mb-3">Confirm Booking</h2>

<form action="processBooking.jsp" method="post">
    <input type="hidden" name="schedule_id" value="<%= scheduleId %>">
    <input type="hidden" name="fare" value="<%= fare %>">
    <input type="hidden" name="amount" value="<%= totalAmount %>">

    <% for(String seat : selectedSeats){ %>
        <input type="hidden" name="seats" value="<%= seat %>">
        <div class="card p-3 mb-3 shadow-sm">
            <h6 class="text-secondary">Seat <%= seat %></h6>

            <div class="mb-2">
                <label class="form-label">Full Name</label>
                <input type="text" name="passenger_name_<%= seat %>" class="form-control" required pattern="^[A-Za-z ]{6,50}$" title="6-50 letters only">
            </div>

            <div class="mb-2">
                <label class="form-label">Gender</label>
                <select name="passenger_gender_<%= seat %>" class="form-select" required>
                    <option value="">Select</option>
                    <option>Male</option><option>Female</option><option>Other</option>
                </select>
            </div>

            <div class="mb-2">
                <label class="form-label">Age</label>
                <input type="number" name="passenger_age_<%= seat %>" class="form-control" min="1" max="100" required title="Age must be between 1-100">
            </div>

            <div class="mb-2">
                <label class="form-label">Phone</label>
                <input type="text" name="passenger_phone_<%= seat %>" class="form-control" maxlength="10" required pattern="^[6-9][0-9]{9}$" title="10-digit phone starting with 6-9">
            </div>

        </div>
    <% } %>

    <div class="alert alert-info"><strong>Total Fare:</strong> ₹<%= String.format("%.2f", totalAmount) %></div>
    <button type="submit" class="btn btn-success">Proceed to Payment</button>
</form>
</body>
</html>
