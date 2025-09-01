<%@ page import="java.sql.*" %>
<%@ include file="../includes/adminHeader.jsp" %>
<%@ include file="../../dbc.jsp" %>

<%
    String pageStr = request.getParameter("page");
    String limitStr = request.getParameter("limit");
    String searchCity = request.getParameter("city");

    int pageNum = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
    int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 10;
    int offset = (pageNum - 1) * limit;

    // Count total routes
    String countSql = "SELECT COUNT(*) FROM Routes r " +
                      "JOIN Cities c1 ON r.from_city_id=c1.city_id " +
                      "JOIN Cities c2 ON r.to_city_id=c2.city_id";
    if (searchCity != null && !searchCity.isEmpty()) {
        countSql += " WHERE c1.city_name LIKE '%" + searchCity + "%' OR c2.city_name LIKE '%" + searchCity + "%'";
    }

    Statement countSt = con.createStatement();
    ResultSet countRs = countSt.executeQuery(countSql);
    countRs.next();
    int totalRoutes = countRs.getInt(1);
    countRs.close(); countSt.close();

    int totalPages = (int)Math.ceil((double)totalRoutes / limit);
%>

<div class="container mt-4">
    <h3 class="mb-4 text-primary">Manage Routes</h3>

    <!-- Add Route -->
    <div class="card p-3 mb-4">
        <h5>Add New Route</h5>
        <form action="addRoute.jsp" method="post" class="row g-3">
            <div class="col-md-4">
                <label class="form-label">From City</label>
                <select name="from_city_id" class="form-select" required>
                    <option value="">-- Select City --</option>
                    <%
                        Statement stCity = con.createStatement();
                        ResultSet rsCity = stCity.executeQuery("SELECT * FROM Cities ORDER BY city_name");
                        while(rsCity.next()){
                    %>
                        <option value="<%= rsCity.getInt("city_id") %>"><%= rsCity.getString("city_name") %></option>
                    <% } rsCity.close(); stCity.close(); %>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">To City</label>
                <select name="to_city_id" class="form-select" required>
                    <option value="">-- Select City --</option>
                    <%
                        Statement stCity2 = con.createStatement();
                        ResultSet rsCity2 = stCity2.executeQuery("SELECT * FROM Cities ORDER BY city_name");
                        while(rsCity2.next()){
                    %>
                        <option value="<%= rsCity2.getInt("city_id") %>"><%= rsCity2.getString("city_name") %></option>
                    <% } rsCity2.close(); stCity2.close(); %>
                </select>
            </div>
            <div class="col-md-2">
                <label class="form-label">Distance (km)</label>
                <input type="text" name="distance_km" class="form-control" required>
            </div>
            <div class="col-md-2">
                <label class="form-label">Est. Time</label>
                <input type="time" name="estimated_time" class="form-control" required>
            </div>
            <div class="col-md-12">
                <button type="submit" class="btn btn-success">Add Route</button>
            </div>
        </form>
    </div>

    <!-- Search -->
    <form method="get" class="mb-3">
        <div class="input-group">
            <input type="text" name="city" class="form-control" placeholder="Search by city" value="<%= (searchCity!=null?searchCity:"") %>">
            <button class="btn btn-primary">Search</button>
        </div>
    </form>

    <!-- Routes Table -->
    <div class="card p-3">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th><th>From City</th><th>To City</th><th>Distance</th><th>Est. Time</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sql = "SELECT r.route_id, c1.city_name AS from_city, c2.city_name AS to_city, " +
                                 "r.distance_km, r.estimated_time FROM Routes r " +
                                 "JOIN Cities c1 ON r.from_city_id=c1.city_id " +
                                 "JOIN Cities c2 ON r.to_city_id=c2.city_id";
                    if(searchCity != null && !searchCity.isEmpty()){
                        sql += " WHERE c1.city_name LIKE '%" + searchCity + "%' OR c2.city_name LIKE '%" + searchCity + "%'";
                    }
                    sql += " LIMIT " + offset + "," + limit;

                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    while(rs.next()){
                %>
                <tr>
                    <td><%= rs.getInt("route_id") %></td>
                    <td><%= rs.getString("from_city") %></td>
                    <td><%= rs.getString("to_city") %></td>
                    <td><%= rs.getBigDecimal("distance_km") %></td>
                    <td><%= rs.getString("estimated_time") %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning editBtn" data-id="<%= rs.getInt("route_id") %>">Edit</button>
                        <a href="deleteRoute.jsp?id=<%= rs.getInt("route_id") %>" onclick="return confirm('Delete this route?');" class="btn btn-sm btn-danger">Delete</a>
                    </td>
                </tr>
                <% } rs.close(); st.close(); %>
            </tbody>
        </table>

        <!-- Pagination -->
        <div style="overflow-x:auto; white-space:nowrap;">
            <nav>
                <ul class="pagination">
                    <% for(int i=1; i<=totalPages; i++){ %>
                        <li class="page-item <%= (i==pageNum)?"active":"" %>">
                            <a class="page-link" href="manageRoutes.jsp?page=<%=i%>&limit=<%=limit%><%= (searchCity!=null?"&city="+searchCity:"") %>">
                                <%= i %>
                            </a>
                        </li>
                    <% } %>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editRouteModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Edit Route</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form action="updateRoute.jsp" method="post" id="editRouteForm">
          <input type="hidden" name="route_id" id="route_id">

          <div class="mb-3">
            <label>From City</label>
            <input type="text" id="from_city" name="from_city" class="form-control" readonly>
          </div>
          <div class="mb-3">
            <label>To City</label>
            <input type="text" id="to_city" name="to_city" class="form-control" readonly>
          </div>
          <div class="mb-3">
            <label>Distance (km)</label>
            <input type="text" name="distance_km" id="distance_km" class="form-control" required>
          </div>
          <div class="mb-3">
            <label>Estimated Time</label>
            <input type="time" name="estimated_time" id="estimated_time" class="form-control" required>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" form="editRouteForm" class="btn btn-success">Update</button>
      </div>
    </div>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function(){
  document.querySelectorAll(".editBtn").forEach(btn=>{
    btn.addEventListener("click", function(){
      let id = this.getAttribute("data-id");
      fetch("editRoute.jsp?id=" + id, {cache:"no-store"})
        .then(res=>res.json())
        .then(data=>{
          document.getElementById("route_id").value = data.route_id;
          document.getElementById("from_city").value = data.from_city;
          document.getElementById("to_city").value = data.to_city;
          document.getElementById("distance_km").value = data.distance_km;
          document.getElementById("estimated_time").value = data.estimated_time;
          new bootstrap.Modal(document.getElementById("editRouteModal")).show();
        })
        .catch(err=>alert("Error loading route data: "+err));
    });
  });
});
</script>

<%@ include file="../includes/adminFooter.jsp" %>
