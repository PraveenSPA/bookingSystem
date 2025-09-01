<%@ page import="java.sql.*" %>
<%@ include file="../includes/adminHeader.jsp" %>
<%@ include file="../../dbc.jsp" %>

<%
    String pageStr = request.getParameter("page");
    String limitStr = request.getParameter("limit");
    String search = request.getParameter("search");

    int pageNum = (pageStr != null) ? Integer.parseInt(pageStr) : 1;
    int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 10;
    int offset = (pageNum - 1) * limit;

    // Count total drivers
    String countSql = "SELECT COUNT(*) FROM Drivers";
    if (search != null && !search.isEmpty()) {
        countSql += " WHERE driver_name LIKE '%" + search + "%' OR license_number LIKE '%" + search + "%'";
    }
    Statement countSt = con.createStatement();
    ResultSet countRs = countSt.executeQuery(countSql);
    countRs.next();
    int totalDrivers = countRs.getInt(1);
    countRs.close(); countSt.close();

    int totalPages = (int)Math.ceil((double)totalDrivers / limit);
%>

<div class="container mt-4">
    <h3 class="mb-4 text-primary">Manage Drivers</h3>

    <!-- Add Driver -->
    <div class="card p-3 mb-4">
        <h5>Add New Driver</h5>
        <form action="addDriver.jsp" method="post" class="row g-3">
            <div class="col-md-4">
                <label class="form-label">Name</label>
                <input type="text" name="driver_name" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">DOB</label>
                <input type="date" name="dob" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Joining Date</label>
                <input type="date" name="joining_date" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Phone</label>
                <input type="text" name="phone" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control">
            </div>
            <div class="col-md-4">
                <label class="form-label">Address</label>
                <input type="text" name="address" class="form-control">
            </div>
            <div class="col-md-4">
                <label class="form-label">License No</label>
                <input type="text" name="license_number" class="form-control" required>
            </div>
            <div class="col-md-4">
                <label class="form-label">License Type</label>
                <select name="license_type" class="form-select" required>
                    <option value="LMV">LMV</option>
                    <option value="HMV">HMV</option>
                    <option value="Commercial">Commercial</option>
                    <option value="Passenger">Passenger</option>
                </select>
            </div>
            <div class="col-md-4">
                <label class="form-label">License Expiry</label>
                <input type="date" name="license_expiry" class="form-control" required>
            </div>
            <div class="col-md-6">
                <label class="form-label">Emergency Contact Name</label>
                <input type="text" name="emergency_contact_name" class="form-control">
            </div>
            <div class="col-md-6">
                <label class="form-label">Emergency Contact Phone</label>
                <input type="text" name="emergency_contact_phone" class="form-control">
            </div>
            <div class="col-md-12">
                <label class="form-label">Remarks</label>
                <textarea name="remarks" class="form-control"></textarea>
            </div>
            <div class="col-md-12">
                <button type="submit" class="btn btn-success">Add Driver</button>
            </div>
        </form>
    </div>

    <!-- Search -->
    <form method="get" class="mb-3">
        <div class="input-group">
            <input type="text" name="search" class="form-control" placeholder="Search driver or license"
                   value="<%= (search!=null?search:"") %>">
            <button class="btn btn-primary">Search</button>
        </div>
    </form>

    <!-- Driver Table -->
    <div class="card p-3">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th><th>Name</th><th>Phone</th><th>License</th><th>Status</th><th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sql = "SELECT * FROM Drivers";
                    if(search != null && !search.isEmpty()){
                        sql += " WHERE driver_name LIKE '%" + search + "%' OR license_number LIKE '%" + search + "%'";
                    }
                    sql += " LIMIT " + offset + "," + limit;

                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery(sql);
                    while(rs.next()){
                %>
                <tr>
                    <td><%= rs.getInt("driver_id") %></td>
                    <td><%= rs.getString("driver_name") %></td>
                    <td><%= rs.getString("phone") %></td>
                    <td><%= rs.getString("license_number") %> (<%= rs.getString("license_type") %>)</td>
                    <td><%= rs.getString("status") %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning editBtn" data-id="<%= rs.getInt("driver_id") %>">Edit</button>
                        <a href="deleteDriver.jsp?id=<%= rs.getInt("driver_id") %>" onclick="return confirm('Delete this driver?');" class="btn btn-sm btn-danger">Delete</a>
                    </td>
                </tr>
                <% } rs.close(); st.close(); %>
            </tbody>
        </table>

        <!-- Pagination -->
        <div style="overflow-x:auto; white-space:nowrap;">
            <nav>
                <ul class="pagination">
                    <% if(pageNum > 1){ %>
                        <li class="page-item">
                            <a class="page-link" href="manageDrivers.jsp?page=<%= (pageNum-1) %>&limit=<%= limit %><%= (search!=null?"&search="+search:"") %>">Prev</a>
                        </li>
                    <% } else { %>
                        <li class="page-item disabled"><span class="page-link">Prev</span></li>
                    <% } %>

                    <% for(int i=1; i<=totalPages; i++){ %>
                        <li class="page-item <%= (i==pageNum)?"active":"" %>">
                            <a class="page-link" href="manageDrivers.jsp?page=<%=i%>&limit=<%=limit%><%= (search!=null?"&search="+search:"") %>">
                                <%= i %>
                            </a>
                        </li>
                    <% } %>

                    <% if(pageNum < totalPages){ %>
                        <li class="page-item">
                            <a class="page-link" href="manageDrivers.jsp?page=<%= (pageNum+1) %>&limit=<%= limit %><%= (search!=null?"&search="+search:"") %>">Next</a>
                        </li>
                    <% } else { %>
                        <li class="page-item disabled"><span class="page-link">Next</span></li>
                    <% } %>
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Edit Modal -->
<div class="modal fade" id="editDriverModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title">Edit Driver</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <form action="updateDriver.jsp" method="post" id="editDriverForm">
          <input type="hidden" name="driver_id" id="driver_id">
          <div class="mb-3"><label>Name</label><input type="text" name="driver_name" id="driver_name" class="form-control" required></div>
          <div class="mb-3"><label>DOB</label><input type="date" name="dob" id="dob" class="form-control" required></div>
          <div class="mb-3"><label>Joining Date</label><input type="date" name="joining_date" id="joining_date" class="form-control" required></div>
          <div class="mb-3"><label>Phone</label><input type="text" name="phone" id="phone" class="form-control" required></div>
          <div class="mb-3"><label>Email</label><input type="email" name="email" id="email" class="form-control"></div>
          <div class="mb-3"><label>Address</label><input type="text" name="address" id="address" class="form-control"></div>
          <div class="mb-3"><label>License Number</label><input type="text" name="license_number" id="license_number" class="form-control" required></div>
          <div class="mb-3">
            <label>License Type</label>
            <select name="license_type" id="license_type" class="form-select" required>
              <option value="LMV">LMV</option>
              <option value="HMV">HMV</option>
              <option value="Commercial">Commercial</option>
              <option value="Passenger">Passenger</option>
            </select>
          </div>
          <div class="mb-3"><label>License Expiry</label><input type="date" name="license_expiry" id="license_expiry" class="form-control" required></div>
          <div class="mb-3"><label>Emergency Contact Name</label><input type="text" name="emergency_contact_name" id="emergency_contact_name" class="form-control"></div>
          <div class="mb-3"><label>Emergency Contact Phone</label><input type="text" name="emergency_contact_phone" id="emergency_contact_phone" class="form-control"></div>
          <div class="mb-3"><label>Status</label>
            <select name="status" id="status" class="form-select">
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
              <option value="Suspended">Suspended</option>
              <option value="Retired">Retired</option>
            </select>
          </div>
          <div class="mb-3"><label>Remarks</label><textarea name="remarks" id="remarks" class="form-control"></textarea></div>
        </form>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="submit" form="editDriverForm" class="btn btn-success">Update</button>
      </div>
    </div>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function(){
  document.querySelectorAll(".editBtn").forEach(btn=>{
    btn.addEventListener("click", function(){
      let id = this.getAttribute("data-id");
      fetch("editDriver.jsp?id=" + id, {cache:"no-store"})
        .then(res=>res.json())
        .then(data=>{
          document.getElementById("driver_id").value = data.driver_id;
          document.getElementById("driver_name").value = data.driver_name;
          document.getElementById("dob").value = data.dob;
          document.getElementById("joining_date").value = data.joining_date;
          document.getElementById("phone").value = data.phone;
          document.getElementById("email").value = data.email;
          document.getElementById("address").value = data.address;
          document.getElementById("license_number").value = data.license_number;
          document.getElementById("license_type").value = data.license_type;
          document.getElementById("license_expiry").value = data.license_expiry;
          document.getElementById("emergency_contact_name").value = data.emergency_contact_name;
          document.getElementById("emergency_contact_phone").value = data.emergency_contact_phone;
          document.getElementById("status").value = data.status;
          document.getElementById("remarks").value = data.remarks;
          new bootstrap.Modal(document.getElementById("editDriverModal")).show();
        })
        .catch(err=>alert("Error: "+err));
    });
  });
});
</script>

<%@ include file="../includes/adminFooter.jsp" %>
