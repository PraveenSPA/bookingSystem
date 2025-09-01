<%@ page import="java.sql.*" %>
<%@ include file="../includes/adminHeader.jsp" %>
<%@ include file="../../dbc.jsp" %>

<%
    // request params
    String selectedBus = request.getParameter("bus_id");
    String pageStr = request.getParameter("page");
    String limitStr = request.getParameter("limit");

    int pageNum = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
    int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 50;
    int offset = (pageNum - 1) * limit;
%>

<div class="container mt-4">
    <h3 class="mb-4 text-primary">Manage Seats</h3>

    <!-- Add Seat Form -->
    <div class="card p-3 mb-4">
        <h5>Add New Seat</h5>
        <form action="addSeat.jsp" method="post" class="row g-2">
            <div class="col-md-4">
                <label class="form-label">Select Bus</label>
                <select name="bus_id" class="form-select" required>
                    <option value="">-- Select Bus --</option>
                    <%
                        Statement st1 = con.createStatement();
                        ResultSet rs1 = st1.executeQuery("SELECT bus_id, bus_number FROM Buses");
                        while(rs1.next()){
                    %>
                    <option value="<%= rs1.getInt("bus_id") %>"
                        <%= (selectedBus != null && selectedBus.equals(rs1.getString("bus_id"))) ? "selected" : "" %>>
                        <%= rs1.getString("bus_number") %>
                    </option>
                    <% } rs1.close(); st1.close(); %>
                </select>
            </div>

            <div class="col-md-3">
                <label class="form-label">Seat Number</label>
                <input type="text" name="seat_number" class="form-control" placeholder="A1, B2" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Seat Type</label>
                <select name="seat_type" class="form-select">
                    <option value="Seater">Seater</option>
                    <option value="Sleeper">Sleeper</option>
                    <option value="Window">Window</option>
                    <option value="Aisle">Aisle</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label">Reserved?</label>
                <select name="is_reserved" class="form-select">
                    <option value="0">No</option>
                    <option value="1">Yes</option>
                </select>
            </div>

            <div class="col-12">
                <button type="submit" class="btn btn-success">Add Seat</button>
            </div>
        </form>
    </div>

    <!-- Filter + page size -->
    <div class="card p-3 mb-3">
        <form method="get" class="row g-2 align-items-end">
            <div class="col-md-4">
                <label class="form-label">Filter by Bus</label>
                <select name="bus_id" class="form-select" onchange="this.form.submit()">
                    <option value="">-- All Buses --</option>
                    <%
                        Statement st2 = con.createStatement();
                        ResultSet rs2 = st2.executeQuery("SELECT bus_id, bus_number FROM Buses");
                        while(rs2.next()){
                    %>
                    <option value="<%= rs2.getInt("bus_id") %>"
                        <%= (selectedBus != null && selectedBus.equals(rs2.getString("bus_id"))) ? "selected" : "" %>>
                        <%= rs2.getString("bus_number") %>
                    </option>
                    <% } rs2.close(); st2.close(); %>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label">Records per page</label>
                <select name="limit" class="form-select" onchange="this.form.submit()">
                    <option value="50" <%= (limit==50?"selected":"") %>>50</option>
                    <option value="70" <%= (limit==70?"selected":"") %>>70</option>
                    <option value="100" <%= (limit==100?"selected":"") %>>100</option>
                </select>
            </div>

            <!-- reset to first page when filter/limit changes -->
            <input type="hidden" name="page" value="1">
        </form>
    </div>

    <!-- Seat List Table -->
    <div class="card p-3">
        <div class="table-responsive">
        <table class="table table-bordered mb-0">
            <thead>
                <tr>
                    <th>ID</th><th>Bus</th><th>Seat No</th><th>Type</th><th>Reserved</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sql = "SELECT s.*, b.bus_number FROM Seats s JOIN Buses b ON s.bus_id=b.bus_id";
                    if(selectedBus != null && !selectedBus.isEmpty()){
                        sql += " WHERE s.bus_id=" + selectedBus;
                    }
                    sql += " LIMIT " + offset + "," + limit;

                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    while(rs.next()){
                %>
                <tr>
                    <td><%= rs.getInt("seat_id") %></td>
                    <td><%= rs.getString("bus_number") %></td>
                    <td><%= rs.getString("seat_number") %></td>
                    <td><%= rs.getString("seat_type") %></td>
                    <td><%= rs.getBoolean("is_reserved") ? "Yes" : "No" %></td>
                    <td>
                        <!-- edit opens modal via JS -->
                        <button type="button" class="btn btn-sm btn-warning editBtn" data-id="<%= rs.getInt("seat_id") %>">
                            Edit
                        </button>

                        <!-- delete (simple redirect) -->
                        <a href="deleteSeat.jsp?id=<%= rs.getInt("seat_id") %>" 
                           onclick="return confirm('Delete this seat?');"
                           class="btn btn-sm btn-danger">Delete</a>
                    </td>
                </tr>
                <% } rs.close(); st.close(); %>
            </tbody>
        </table>
        </div>

        <%
            // total count for pagination
            String countSql = "SELECT COUNT(*) FROM Seats";
            if(selectedBus != null && !selectedBus.isEmpty()){
                countSql += " WHERE bus_id=" + selectedBus;
            }
            Statement countSt = con.createStatement();
            ResultSet countRs = countSt.executeQuery(countSql);
            countRs.next();
            int totalRecords = countRs.getInt(1);
            int totalPages = (int)Math.ceil((double)totalRecords / limit);

            countRs.close();
            countSt.close();
            // close the connection (editSeatData.jsp will open its own connection)
            con.close();
        %>

        <!-- Pagination (horizontal scroll if many pages) -->
        <div style="overflow-x: auto; white-space: nowrap; margin-top:10px;">
            <ul class="pagination mb-0" style="display:inline-flex; min-width:max-content;">
                <% 
                    // Prev button
                    int prevPage = (pageNum > 1) ? pageNum - 1 : 1;
                %>
                <li class="page-item <%= (pageNum==1) ? "disabled" : "" %>">
                    <a class="page-link" href="manageSeats.jsp?page=<%= prevPage %>&limit=<%= limit %><%= (selectedBus!=null && !selectedBus.isEmpty() ? "&bus_id="+selectedBus : "") %>">Prev</a>
                </li>

                <% for(int i = 1; i <= totalPages; i++){ %>
                    <li class="page-item <%= (i==pageNum) ? "active" : "" %>">
                        <a class="page-link" 
                           href="manageSeats.jsp?page=<%= i %>&limit=<%= limit %><%= (selectedBus!=null && !selectedBus.isEmpty() ? "&bus_id="+selectedBus : "") %>">
                           <%= i %>
                        </a>
                    </li>
                <% } %>

                <% 
                    int nextPage = (pageNum < totalPages) ? pageNum + 1 : totalPages;
                %>
                <li class="page-item <%= (pageNum==totalPages || totalPages==0) ? "disabled" : "" %>">
                    <a class="page-link" href="manageSeats.jsp?page=<%= nextPage %>&limit=<%= limit %><%= (selectedBus!=null && !selectedBus.isEmpty() ? "&bus_id="+selectedBus : "") %>">Next</a>
                </li>
            </ul>
        </div>
    </div>
</div>

<!-- Edit Seat Modal (single modal instance, filled by AJAX) -->
<div class="modal fade" id="editSeatModal" tabindex="-1" aria-labelledby="editSeatLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="editSeatLabel">Edit Seat</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <!-- include page/limit/bus_id so update redirects back to same view -->
        <form action="updateSeat.jsp" method="post" id="editSeatForm">
          <input type="hidden" name="seat_id" id="seat_id">
          <input type="hidden" name="page" id="modal_page" value="<%= pageNum %>">
          <input type="hidden" name="limit" id="modal_limit" value="<%= limit %>">
          <input type="hidden" name="bus_id" id="modal_bus_id" value="<%= (selectedBus!=null?selectedBus:"") %>">

          <div class="mb-3">
            <label class="form-label">Seat Number</label>
            <input type="text" name="seat_number" id="seat_number" class="form-control" required>
          </div>

          <div class="mb-3">
            <label class="form-label">Seat Type</label>
            <select name="seat_type" id="seat_type" class="form-select">
              <option value="Seater">Seater</option>
              <option value="Sleeper">Sleeper</option>
              <option value="Window">Window</option>
              <option value="Aisle">Aisle</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label">Reserved?</label>
            <select name="is_reserved" id="is_reserved" class="form-select">
              <option value="0">No</option>
              <option value="1">Yes</option>
            </select>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" form="editSeatForm" class="btn btn-success">Update</button>
      </div>
    </div>
  </div>
</div>

<!-- JS: load seat data via AJAX and open modal -->
<script>
document.addEventListener("DOMContentLoaded", function(){
  var editButtons = document.querySelectorAll(".editBtn");
  editButtons.forEach(function(btn){
    btn.addEventListener("click", function(){
      var id = this.getAttribute("data-id");
      if(!id) return;

      fetch("editSeat.jsp?id=" + encodeURIComponent(id), {cache: "no-store"})
        .then(function(res){
          if(!res.ok) throw new Error("Network response was not OK ("+res.status+")");
          return res.json();
        })
        .then(function(data){
          // fill modal fields
          document.getElementById("seat_id").value = data.seat_id;
          document.getElementById("seat_number").value = data.seat_number;
          document.getElementById("seat_type").value = data.seat_type;
          document.getElementById("is_reserved").value = data.is_reserved;

          // show modal (requires bootstrap JS loaded)
          var modalEl = document.getElementById("editSeatModal");
          var bsModal = new bootstrap.Modal(modalEl);
          bsModal.show();
        })
        .catch(function(err){
          console.error("Failed to load seat data:", err);
          alert("Error loading seat data. Open browser console for details.");
        });
    });
  });
});
</script>

<%@ include file="../includes/adminFooter.jsp" %>

