<%@ page import="java.sql.*" %>
<%@ include file="../includes/adminHeader.jsp" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));

    // Fetch schedule details
    String sql = "SELECT * FROM Schedules WHERE schedule_id=?";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(!rs.next()){
        out.println("<div class='alert alert-danger'>Schedule not found!</div>");
        return;
    }
%>

<div class="container mt-4">
    <h3 class="mb-4 text-primary">Edit Schedule</h3>

    <form action="updateSchedule.jsp" method="post">
        <input type="hidden" name="schedule_id" value="<%= rs.getInt("schedule_id") %>">

        <div class="row">
            <!-- Route -->
            <div class="col-md-3 mb-2">
                <label>Route</label>
                <select name="route_id" class="form-control" required>
                    <%
                        Statement st1 = con.createStatement();
                        ResultSet rs1 = st1.executeQuery("SELECT r.route_id, c1.city_name AS from_city, c2.city_name AS to_city FROM Routes r JOIN Cities c1 ON r.from_city_id=c1.city_id JOIN Cities c2 ON r.to_city_id=c2.city_id");
                        while(rs1.next()){
                            int rid = rs1.getInt("route_id");
                    %>
                        <option value="<%= rid %>" <%= (rid==rs.getInt("route_id"))?"selected":"" %>>
                            <%= rs1.getString("from_city") %> → <%= rs1.getString("to_city") %>
                        </option>
                    <% } %>
                </select>
            </div>

            <!-- Bus -->
            <div class="col-md-3 mb-2">
                <label>Bus</label>
                <select name="bus_id" class="form-control" required>
                    <%
                        Statement st2 = con.createStatement();
                        ResultSet rs2 = st2.executeQuery("SELECT bus_id, bus_number FROM Buses");
                        while(rs2.next()){
                            int bid = rs2.getInt("bus_id");
                    %>
                        <option value="<%= bid %>" <%= (bid==rs.getInt("bus_id"))?"selected":"" %>>
                            <%= rs2.getString("bus_number") %>
                        </option>
                    <% } %>
                </select>
            </div>

            <!-- Driver -->
            <div class="col-md-3 mb-2">
                <label>Driver</label>
                <select name="driver_id" class="form-control">
                    <option value="">-- None --</option>
                    <%
                        Statement st3 = con.createStatement();
                        ResultSet rs3 = st3.executeQuery("SELECT driver_id, driver_name FROM Drivers WHERE status='Active'");
                        while(rs3.next()){
                            int did = rs3.getInt("driver_id");
                    %>
                        <option value="<%= did %>" <%= (rs.getInt("driver_id")==did)?"selected":"" %>>
                            <%= rs3.getString("driver_name") %>
                        </option>
                    <% } %>
                </select>
            </div>

            <!-- Departure -->
            <div class="col-md-3 mb-2">
                <label>Departure</label>
                <input type="datetime-local" name="departure_datetime" 
                       value="<%= rs.getString("departure_datetime").replace(" ","T") %>" 
                       class="form-control" required>
            </div>

            <!-- Arrival -->
            <div class="col-md-3 mb-2">
                <label>Arrival</label>
                <input type="datetime-local" name="arrival_datetime" 
                       value="<%= (rs.getString("arrival_datetime")!=null)?rs.getString("arrival_datetime").replace(" ","T"):"" %>" 
                       class="form-control">
            </div>

            <!-- Fare -->
            <div class="col-md-3 mb-2">
                <label>Fare</label>
                <input type="number" step="0.01" name="fare" value="<%= rs.getDouble("fare") %>" class="form-control" required>
            </div>

            <!-- Status -->
            <div class="col-md-3 mb-2">
                <label>Status</label>
                <select name="status" class="form-control">
                    <option value="Scheduled" <%= rs.getString("status").equals("Scheduled")?"selected":"" %>>Scheduled</option>
                    <option value="Delayed" <%= rs.getString("status").equals("Delayed")?"selected":"" %>>Delayed</option>
                    <option value="Cancelled" <%= rs.getString("status").equals("Cancelled")?"selected":"" %>>Cancelled</option>
                    <option value="Completed" <%= rs.getString("status").equals("Completed")?"selected":"" %>>Completed</option>
                </select>
            </div>
        </div>

        <button type="submit" class="btn btn-primary mt-3">Update Schedule</button>
        <a href="manageSchedules.jsp" class="btn btn-secondary mt-3">Cancel</a>
    </form>
</div>

<%
    con.close();
%>

<%@ include file="../includes/adminFooter.jsp" %>

