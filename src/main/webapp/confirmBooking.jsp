<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String scheduleParam = request.getParameter("schedule_id");
    if (scheduleParam == null || scheduleParam.isEmpty()) {
        out.println("<p style='color:red'>Error: No schedule selected!</p>");
        return;
    }
    int scheduleId = Integer.parseInt(scheduleParam);

    String[] selectedSeats = request.getParameterValues("seats");
    if (selectedSeats == null || selectedSeats.length == 0) {
        out.println("<p style='color:red'>Error: No seats selected!</p>");
        return;
    }
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
        <% for(String seat : selectedSeats){ %>
            <input type="hidden" name="seats" value="<%= seat %>">
        <% } %>

        <h5 class="mb-3">Passenger Information</h5>

        <% for(String seat : selectedSeats){ %>
            <div class="card p-3 mb-3 shadow-sm">
                <h6 class="text-secondary">Seat <%= seat %></h6>

                <div class="mb-2">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="passenger_name_<%= seat %>" class="form-control" required>
                </div>

                <div class="mb-2">
                    <label class="form-label">Gender</label>
                    <select name="passenger_gender_<%= seat %>" class="form-select" required>
                        <option value="">Select</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="mb-2">
                    <label class="form-label">Age</label>
                    <input type="number" name="passenger_age_<%= seat %>" class="form-control" min="1" required>
                </div>

                <div class="mb-2">
                    <label class="form-label">Phone</label>
                    <input type="text" name="passenger_phone_<%= seat %>" class="form-control" required>
                </div>
            </div>
        <% } %>

        <button type="submit" class="btn btn-success">Proceed to Payment</button>
    </form>

</body>
</html>
