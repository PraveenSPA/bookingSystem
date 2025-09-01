<%@ page import="java.sql.*" %>
<%@ include file="../includes/adminHeader.jsp" %>
<%@ include file="../../dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<div class="container mt-4">

    <!-- Logo -->
    

    <h3 class="mb-4 text-primary"><span><img src="../../images/logo.png" alt="Logo" style="height:70px;"></span>Schedules</h3>

    <!-- Add Schedule Button -->
    <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addScheduleModal">
        + Add New Schedule
    </button>

    <!-- Schedule List -->
    <div class="card p-3">
        <h5>Schedule List</h5>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th><th>Route</th><th>Bus</th><th>Driver</th>
                    <th>Departure</th><th>Arrival</th><th>Fare</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    int currentPage = 1, recordsPerPage = 10;
                    if(request.getParameter("page") != null) {
                        currentPage = Integer.parseInt(request.getParameter("page"));
                    }
                    int start = (currentPage-1) * recordsPerPage;

                    String sql = "SELECT s.schedule_id, c1.city_name AS from_city, c2.city_name AS to_city, " +
                                 "b.bus_number, d.driver_name, s.departure_datetime, s.arrival_datetime, " +
                                 "s.fare, s.status " +
                                 "FROM Schedules s " +
                                 "JOIN Routes r ON s.route_id=r.route_id " +
                                 "JOIN Cities c1 ON r.from_city_id=c1.city_id " +
                                 "JOIN Cities c2 ON r.to_city_id=c2.city_id " +
                                 "JOIN Buses b ON s.bus_id=b.bus_id " +
                                 "LEFT JOIN Drivers d ON s.driver_id=d.driver_id " +
                                 "LIMIT ?,?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, start);
                    ps.setInt(2, recordsPerPage);
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()){
                %>
                <tr>
                    <td><%= rs.getInt("schedule_id") %></td>
                    <td><%= rs.getString("from_city") %> → <%= rs.getString("to_city") %></td>
                    <td><%= rs.getString("bus_number") %></td>
                    <td><%= rs.getString("driver_name")!=null?rs.getString("driver_name"):"-" %></td>
                    <td><%= rs.getString("departure_datetime") %></td>
                    <td><%= rs.getString("arrival_datetime") %></td>
                    <td>₹<%= rs.getDouble("fare") %></td>
                    <td><%= rs.getString("status") %></td>
                    <td>
                        <button class="btn btn-sm btn-warning" 
                                onclick="openEditModal(<%= rs.getInt("schedule_id") %>)">Edit</button>
                        <a href="deleteSchedule.jsp?id=<%= rs.getInt("schedule_id") %>" 
                           onclick="return confirm('Delete this schedule?');"
                           class="btn btn-sm btn-danger">Delete</a>
                    </td>
                </tr>
                <% } rs.close(); ps.close(); %>
            </tbody>
        </table>

        <!-- Pagination -->
        <%
            Statement stCount = con.createStatement();
            ResultSet rsCount = stCount.executeQuery("SELECT COUNT(*) FROM Schedules");
            rsCount.next();
            int totalRecords = rsCount.getInt(1);
            int totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
            rsCount.close(); stCount.close();

            int maxLinks = 5;
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, startPage + maxLinks - 1);
        %>

        <nav>
            <ul class="pagination">
                <li class="page-item <%= (currentPage==1?"disabled":"") %>">
                    <a class="page-link" href="manageSchedules.jsp?page=<%= currentPage-1 %>">Prev</a>
                </li>
                <%
                    for(int i=startPage; i<=endPage; i++){
                        if(i == currentPage){
                %>
                    <li class="page-item active"><span class="page-link"><%= i %></span></li>
                <%
                        } else {
                %>
                    <li class="page-item"><a class="page-link" href="manageSchedules.jsp?page=<%= i %>"><%= i %></a></li>
                <%
                        }
                    }
                %>
                <li class="page-item <%= (currentPage==totalPages?"disabled":"") %>">
                    <a class="page-link" href="manageSchedules.jsp?page=<%= currentPage+1 %>">Next</a>
                </li>
            </ul>
        </nav>
    </div>
</div>

<!-- Add Schedule Modal -->
<div class="modal fade" id="addScheduleModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="addSchedule.jsp" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Add New Schedule</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
            <div class="row">
                <!-- Route -->
                <div class="col-md-6 mb-2">
                    <label>Route</label>
                    <select name="route_id" class="form-control" required>
                        <option value="">-- Select Route --</option>
                        <%
                            Statement st1 = con.createStatement();
                            ResultSet rs1 = st1.executeQuery("SELECT r.route_id, c1.city_name AS from_city, c2.city_name AS to_city FROM Routes r JOIN Cities c1 ON r.from_city_id=c1.city_id JOIN Cities c2 ON r.to_city_id=c2.city_id");
                            while(rs1.next()){
                        %>
                        <option value="<%= rs1.getInt("route_id") %>">
                            <%= rs1.getString("from_city") %> → <%= rs1.getString("to_city") %>
                        </option>
                        <% } rs1.close(); st1.close(); %>
                    </select>
                </div>

                <!-- Bus -->
                <div class="col-md-6 mb-2">
                    <label>Bus</label>
                    <select name="bus_id" class="form-control" required>
                        <option value="">-- Select Bus --</option>
                        <%
                            Statement st2 = con.createStatement();
                            ResultSet rs2 = st2.executeQuery("SELECT bus_id, bus_number FROM Buses");
                            while(rs2.next()){
                        %>
                        <option value="<%= rs2.getInt("bus_id") %>"><%= rs2.getString("bus_number") %></option>
                        <% } rs2.close(); st2.close(); %>
                    </select>
                </div>

                <!-- Driver -->
                <div class="col-md-6 mb-2">
                    <label>Driver</label>
                    <select name="driver_id" class="form-control">
                        <option value="">-- Select Driver --</option>
                        <%
                            Statement st3 = con.createStatement();
                            ResultSet rs3 = st3.executeQuery("SELECT driver_id, driver_name FROM Drivers WHERE status='Active'");
                            while(rs3.next()){
                        %>
                        <option value="<%= rs3.getInt("driver_id") %>"><%= rs3.getString("driver_name") %></option>
                        <% } rs3.close(); st3.close(); %>
                    </select>
                </div>

                <!-- Departure -->
                <div class="col-md-6 mb-2">
                    <label>Departure</label>
                    <input type="datetime-local" name="departure_datetime" class="form-control" required>
                </div>

                <!-- Arrival -->
                <div class="col-md-6 mb-2">
                    <label>Arrival</label>
                    <input type="datetime-local" name="arrival_datetime" class="form-control">
                </div>

                <!-- Fare -->
                <div class="col-md-6 mb-2">
                    <label>Fare</label>
                    <input type="number" step="0.01" name="fare" class="form-control" required>
                </div>

                <!-- Status -->
                <div class="col-md-6 mb-2">
                    <label>Status</label>
                    <select name="status" class="form-control">
                        <option value="Scheduled">Scheduled</option>
                        <option value="Delayed">Delayed</option>
                        <option value="Cancelled">Cancelled</option>
                        <option value="Completed">Completed</option>
                    </select>
                </div>
            </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Add Schedule</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- Edit Schedule Modal -->
<div class="modal fade" id="editScheduleModal" tabindex="-1">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-body" id="editScheduleContent">
        <!-- AJAX content loads here -->
      </div>
    </div>
  </div>
</div>

<script>
function openEditModal(scheduleId){
    fetch("editSchedule.jsp?id=" + scheduleId)
      .then(resp => resp.text())
      .then(data => {
          document.getElementById("editScheduleContent").innerHTML = data;
          new bootstrap.Modal(document.getElementById('editScheduleModal')).show();
      });
}
</script>

<%@ include file="../includes/adminFooter.jsp" %>
