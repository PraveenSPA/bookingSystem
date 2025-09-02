<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String scheduleParam = request.getParameter("schedule_id");
if(scheduleParam == null || scheduleParam.isEmpty()){
    out.println("<p style='color:red'>Error: No schedule selected!</p>");
    return;
}
int scheduleId = Integer.parseInt(scheduleParam);

// Fetch Bus ID
PreparedStatement psBus = con.prepareStatement(
    "SELECT b.bus_id, s.fare FROM schedules s JOIN buses b ON s.bus_id=b.bus_id WHERE s.schedule_id=?"
);
psBus.setInt(1, scheduleId);
ResultSet rsBus = psBus.executeQuery();
int busId = 0;
double fare = 0.0;
if(rsBus.next()) {
    busId = rsBus.getInt("bus_id");
    fare = rsBus.getDouble("fare");
}
rsBus.close(); psBus.close();

// Fetch all seats
PreparedStatement psSeats = con.prepareStatement(
    "SELECT seat_id, seat_number, seat_type, is_reserved FROM seats WHERE bus_id=? ORDER BY CAST(seat_number AS UNSIGNED)"
);
psSeats.setInt(1, busId);
ResultSet rsSeats = psSeats.executeQuery();

// Booked seats
PreparedStatement psBooked = con.prepareStatement(
    "SELECT st.seat_number FROM bookings bk " +
    "JOIN schedule_seats ss ON bk.schedule_seat_id=ss.schedule_seat_id " +
    "JOIN seats st ON ss.seat_id=st.seat_id " +
    "WHERE bk.schedule_id=? AND bk.status='Booked' AND bk.payment_status='Paid'"
);
psBooked.setInt(1, scheduleId);
ResultSet rsBooked = psBooked.executeQuery();
java.util.Set<String> bookedSeats = new java.util.HashSet<>();
while(rsBooked.next()) bookedSeats.add(rsBooked.getString("seat_number"));
rsBooked.close(); psBooked.close();

java.util.List<String> seatsList = new java.util.ArrayList<>();
while(rsSeats.next()){
    seatsList.add(rsSeats.getString("seat_number"));
}
rsSeats.close(); psSeats.close();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Select Seats</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .seat { width:50px; height:50px; margin:3px; display:flex; align-items:center; justify-content:center;
            border:1px solid #333; cursor:pointer; border-radius:6px; font-weight:600; user-select:none;
            background:#d3d3d3; transition: transform 0.2s; }
        .available { background:#d3d3d3; }
        .booked { background:#ff4d6d; color:#fff; cursor:not-allowed; }
        .selected { outline:3px solid #ff66cc; transform:scale(1.1); }
    </style>
</head>
<body class="container mt-4">
<h2 class="mb-3 text-primary">Select Your Seats</h2>

<form id="seatForm" action="confirmBooking.jsp" method="post">
    <input type="hidden" name="schedule_id" value="<%= scheduleId %>">
    <input type="hidden" name="fare" value="<%= fare %>">

    <div class="bus-layout">
        <%
        int totalSeats = seatsList.size();
        int i = 0;
        while(i < totalSeats){
            if(i + 5 >= totalSeats){
        %>
        <div class="d-flex justify-content-center mb-2">
            <% for(int j=0; j<totalSeats-i; j++){
                String seatNum = seatsList.get(i+j);
                boolean disabled = bookedSeats.contains(seatNum);
                String cssClass = disabled ? "seat booked" : "seat available";
            %>
            <label class="<%= cssClass %>" data-seat="<%= seatNum %>">
                <input type="checkbox" name="seats" value="<%= seatNum %>" <%= disabled?"disabled":"" %> hidden>
                <%= seatNum %>
            </label>
            <% } %>
        </div>
        <%
                break;
            } else {
        %>
        <div class="d-flex justify-content-center mb-2">
            <% for(int j=0; j<4; j++){
                String seatNum = seatsList.get(i+j);
                boolean disabled = bookedSeats.contains(seatNum);
                String cssClass = disabled ? "seat booked" : "seat available";
            %>
            <label class="<%= cssClass %>" data-seat="<%= seatNum %>">
                <input type="checkbox" name="seats" value="<%= seatNum %>" <%= disabled?"disabled":"" %> hidden>
                <%= seatNum %>
            </label>
            <% } i+=4; %>
        </div>
        <% } } %>
    </div>

    <div class="mt-4">
    <!-- Make it a button, not direct submit -->
    <button type="button" class="btn btn-primary btn-lg" onclick="validateSeats()">Continue</button>
</div>

<script>
function validateSeats() {
    // check if any seat is selected
    let seats = document.querySelectorAll('input[name="seats"]:checked');
    if (seats.length === 0) {
        alert("⚠ Please select at least one seat before continuing!");
        return false; // stop here
    } else {
        // submit form manually if seat(s) selected
        document.getElementById("seatForm").submit();
    }
}
</script>
    
</form>

<script>
document.querySelectorAll('.seat input[type="checkbox"]').forEach(cb=>{
    cb.addEventListener('change',function(){
        const label=this.parentElement;
        if(this.checked) label.classList.add('selected'); else label.classList.remove('selected');
    });
});
</script>
</body>
</html>
