<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String scheduleParam = request.getParameter("schedule_id");
if (scheduleParam == null || scheduleParam.isEmpty()) {
    out.println("<p style='color:red'>Error: No schedule selected!</p>");
    return;
}
int scheduleId = Integer.parseInt(scheduleParam);

// Find bus for this schedule
PreparedStatement psBus = con.prepareStatement(
    "SELECT b.bus_id FROM schedules s JOIN buses b ON s.bus_id=b.bus_id WHERE s.schedule_id=?"
);
psBus.setInt(1, scheduleId);
ResultSet rsBus = psBus.executeQuery();
int busId = 0;
if (rsBus.next()) busId = rsBus.getInt("bus_id");
rsBus.close(); psBus.close();

// All seats (numeric order)
PreparedStatement psSeats = con.prepareStatement(
    "SELECT seat_id, seat_number, seat_type, is_reserved " +
    "FROM seats WHERE bus_id=? ORDER BY CAST(seat_number AS UNSIGNED)"
);
psSeats.setInt(1, busId);
ResultSet rsSeats = psSeats.executeQuery();

// Booked seats for this schedule (paid/confirmed)
PreparedStatement psBooked = con.prepareStatement(
    "SELECT st.seat_number " +
    "FROM bookings bk " +
    "JOIN schedule_seats ss ON bk.schedule_seat_id=ss.schedule_seat_id " +
    "JOIN seats st ON ss.seat_id=st.seat_id " +
    "WHERE bk.schedule_id=? AND bk.status='Booked' AND bk.payment_status='Paid'"
);
psBooked.setInt(1, scheduleId);
ResultSet rsBooked = psBooked.executeQuery();
java.util.Set<String> bookedSeats = new java.util.HashSet<>();
while (rsBooked.next()) bookedSeats.add(rsBooked.getString("seat_number"));
rsBooked.close(); psBooked.close();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Select Seats</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    .seat {
      width:50px; height:50px; margin:5px; display:inline-flex;
      align-items:center; justify-content:center;
      border:1px solid #333; cursor:pointer; border-radius:8px;
      font-weight:600; color:#f4f4f4; user-select:none;
    }
    .available { background:#28a745; } /* green */
    .booked    { background:#ff4d6d; cursor:not-allowed; } /* pink */
    .reserved  { background:#999; cursor:not-allowed; }
    .selected  { outline:3px solid #ff66cc; }

    .bus-row { display:flex; justify-content:center; margin-bottom:10px; }
    .aisle   { width:40px; }
    .legend .box{width:18px;height:18px;display:inline-block;border-radius:4px;margin-right:6px;border:1px solid #333;}
  </style>
</head>
<body class="container mt-4">
  <h2 class="mb-3 text-primary">Select Your Seats</h2>

  <div class="legend mb-3">
    <span class="box" style="background:#28a745"></span> Available
    &nbsp;&nbsp;<span class="box" style="background:#ff4d6d"></span> Booked
    &nbsp;&nbsp;<span class="box" style="background:#999"></span> Reserved
    &nbsp;&nbsp;<span class="box" style="outline:3px solid #ff66cc"></span> Selected
  </div>

  <form id="seatForm" action="processBooking.jsp" method="post">
    <input type="hidden" name="schedule_id" value="<%= scheduleId %>">

    <div class="bus-layout">
      <%
        int seatCount = 0;
        while (rsSeats.next()) {
          String seatNum = rsSeats.getString("seat_number");
          boolean isReserved = rsSeats.getBoolean("is_reserved");

          String cssClass = "seat available";
          boolean disabled = false;
          if (isReserved) { cssClass = "seat reserved"; disabled = true; }
          else if (bookedSeats.contains(seatNum)) { cssClass = "seat booked"; disabled = true; }

          if (seatCount % 4 == 0) { %><div class="bus-row"><% }
          if (seatCount % 4 == 2) { %><div class="aisle"></div><% } %>

          <label class="<%= cssClass %>" data-seat="<%= seatNum %>">
            <input type="checkbox" name="seats" value="<%= seatNum %>" <%= disabled ? "disabled" : "" %> hidden>
            <%= seatNum %>
          </label>

          <%
            seatCount++;
            if (seatCount % 4 == 0) { %></div><% }
        }
        if (seatCount % 4 != 0) { %></div><% }
        rsSeats.close(); psSeats.close();
      %>
    </div>

    <hr class="my-4"/>

    <h5 class="mb-3">Passenger Details</h5>
    <div id="passengerContainer" class="row g-3">
      <!-- JS will inject one block per selected seat -->
    </div>

    <div class="mt-4">
      <button type="submit" class="btn btn-success btn-lg" id="proceedBtn" disabled>Proceed to Payment</button>
    </div>
  </form>

  <script>
    const labels = document.querySelectorAll('.seat input[type="checkbox"]');
    const passengerContainer = document.getElementById('passengerContainer');
    const proceedBtn = document.getElementById('proceedBtn');

    function renderPassengers() {
      passengerContainer.innerHTML = '';
      const checked = Array.from(document.querySelectorAll('.seat input[type="checkbox"]:checked'))
                           .map(cb => cb.value)
                           .sort((a,b)=>parseInt(a)-parseInt(b));
      checked.forEach(seat => {
        const block = document.createElement('div');
        block.className = 'col-12';
        block.innerHTML = `
          <div class="card p-3">
            <div class="row g-2 align-items-end">
              <div class="col-12 col-md-2">
                <label class="form-label mb-1">Seat</label>
                <input type="text" class="form-control" value="${seat}" readonly>
              </div>
              <div class="col-12 col-md-4">
                <label class="form-label mb-1">Full Name</label>
                <input type="text" class="form-control" required name="passenger_name_${seat}">
              </div>
              <div class="col-12 col-md-2">
                <label class="form-label mb-1">Gender</label>
                <select class="form-select" required name="passenger_gender_${seat}">
                  <option value="">Choose...</option>
                  <option>Male</option>
                  <option>Female</option>
                  <option>Other</option>
                </select>
              </div>
              <div class="col-6 col-md-2">
                <label class="form-label mb-1">Age</label>
                <input type="number" min="1" max="120" class="form-control" required name="passenger_age_${seat}">
              </div>
              <div class="col-6 col-md-2">
                <label class="form-label mb-1">Phone</label>
                <input type="text" class="form-control" required name="passenger_phone_${seat}">
              </div>
            </div>
          </div>`;
        passengerContainer.appendChild(block);
      });
      proceedBtn.disabled = checked.length === 0;
    }

    labels.forEach(cb => {
      cb.addEventListener('change', function(){
        const label = this.parentElement;
        if (this.checked) label.classList.add('selected'); else label.classList.remove('selected');
        renderPassengers();
      });
    });
  </script>
</body>
</html>
