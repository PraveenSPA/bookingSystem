<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<%
    int pageSize = 5;  
    int pageNum = 1;      
    if(request.getParameter("page") != null){
        pageNum = Integer.parseInt(request.getParameter("page"));   // ✅ fixed
    }

    int offset = (pageNum - 1) * pageSize;
    int totalRecords = 0, totalPages = 0;

    try {
        Statement countSt = con.createStatement();
        ResultSet countRs = countSt.executeQuery("SELECT COUNT(*) FROM Buses");
        if(countRs.next()){
            totalRecords = countRs.getInt(1);
        }
        totalPages = (int)Math.ceil(totalRecords * 1.0 / pageSize);
        countRs.close();
        countSt.close();
    } catch(Exception e){ out.println("Error counting: " + e.getMessage()); }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Buses</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-4">

    <!-- 🔹 Logo and Heading -->
    <div class="d-flex align-items-center mb-4">
        <img src="../../images/logo.png" alt="Logo" width="60" class="me-2">
        <h3 class="text-primary">Buses</h3>
    </div>

    <!-- 🔹 Add New Bus Button (Modal Trigger) -->
    <button class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addBusModal">
        + Add New Bus
    </button>

    <!-- 🔹 Buses Table -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th><th>Bus Number</th><th>Type</th><th>Capacity</th><th>Operator</th><th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            try {
                String query = "SELECT b.bus_id, b.bus_number, b.bus_type, b.capacity, o.operator_id, o.operator_name " +
                               "FROM Buses b JOIN Operators o ON b.operator_id=o.operator_id " +
                               "LIMIT ? OFFSET ?";
                PreparedStatement ps = con.prepareStatement(query);
                ps.setInt(1, pageSize);
                ps.setInt(2, offset);
                ResultSet rs = ps.executeQuery();

                while(rs.next()){
        %>
            <tr>
                <td><%= rs.getInt("bus_id") %></td>
                <td><%= rs.getString("bus_number") %></td>
                <td><%= rs.getString("bus_type") %></td>
                <td><%= rs.getInt("capacity") %></td>
                <td><%= rs.getString("operator_name") %></td>
                <td>
                    <!-- 🔹 Edit button triggers Edit Modal -->
                    <button class="btn btn-warning btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#editBusModal"
                            data-id="<%= rs.getInt("bus_id") %>"
                            data-number="<%= rs.getString("bus_number") %>"
                            data-type="<%= rs.getString("bus_type") %>"
                            data-capacity="<%= rs.getInt("capacity") %>"
                            data-operator="<%= rs.getInt("operator_id") %>">
                        Edit
                    </button>

                    <a href="deleteBus.jsp?id=<%= rs.getInt("bus_id") %>" 
                       class="btn btn-danger btn-sm" 
                       onclick="return confirm('Are you sure you want to delete this bus?');">
                       Delete
                    </a>
                </td>
            </tr>
        <%
                }
                rs.close();
                ps.close();
            } catch(Exception e) {
                out.println("Error: " + e.getMessage());
            } 
        %>
        </tbody>
    </table>

    <!-- 🔹 Pagination Controls -->
<nav>
    <ul class="pagination">
        <li class="page-item <%= (pageNum <= 1) ? "disabled" : "" %>">
            <a class="page-link" href="manageBuses.jsp?page=<%= pageNum-1 %>">Prev</a>
        </li>

        <% for(int i=1; i<=totalPages; i++){ %>
            <li class="page-item <%= (i==pageNum) ? "active" : "" %>">
                <a class="page-link" href="manageBuses.jsp?page=<%= i %>"><%= i %></a>
            </li>
        <% } %>

        <li class="page-item <%= (pageNum >= totalPages) ? "disabled" : "" %>">
            <a class="page-link" href="manageBuses.jsp?page=<%= pageNum+1 %>">Next</a>
        </li>
    </ul>
</nav>
    

<!-- 🔹 Add Bus Modal -->
<div class="modal fade" id="addBusModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="insertBus.jsp" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Add New Bus</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <div class="row mb-3">
            <div class="col-md-4">
              <input type="text" name="bus_number" class="form-control" placeholder="Bus Number" required>
            </div>
            <div class="col-md-4">
              <select name="bus_type" class="form-control" required>
                <option value="">-- Select Type --</option>
                <option>AC Sleeper</option>
                <option>AC Seater</option>
                <option>Non-AC Seater</option>
                <option>Volvo</option>
                <option>Luxury</option>
              </select>
            </div>
            <div class="col-md-4">
              <input type="number" name="capacity" class="form-control" placeholder="Capacity" required>
            </div>
          </div>

          <div class="mb-3">
            <select name="operator_id" class="form-control" required>
              <option value="">-- Select Operator --</option>
              <%
                try {
                    Statement st = con.createStatement();
                    ResultSet rsOps = st.executeQuery("SELECT operator_id, operator_name FROM Operators");
                    while(rsOps.next()){
              %>
              <option value="<%= rsOps.getInt("operator_id") %>">
                <%= rsOps.getString("operator_name") %>
              </option>
              <%
                    }
                    rsOps.close();
                    st.close();
                } catch(Exception e) {
                    out.println("Error loading operators: " + e.getMessage());
                }
              %>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-success">Save</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 🔹 Edit Bus Modal -->
<div class="modal fade" id="editBusModal" tabindex="-1" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <form action="updateBus.jsp" method="post">
        <div class="modal-header">
          <h5 class="modal-title">Edit Bus</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="bus_id" id="editBusId">

          <div class="mb-3">
            <input type="text" name="bus_number" id="editBusNumber" class="form-control" required>
          </div>
          <div class="mb-3">
            <select name="bus_type" id="editBusType" class="form-control" required>
              <option>AC Sleeper</option>
              <option>AC Seater</option>
              <option>Non-AC Seater</option>
              <option>Volvo</option>
              <option>Luxury</option>
            </select>
          </div>
          <div class="mb-3">
            <input type="number" name="capacity" id="editCapacity" class="form-control" required>
          </div>
          <div class="mb-3">
            <select name="operator_id" id="editOperator" class="form-control" required>
              <%
                try {
                    Statement st = con.createStatement(); 
                    ResultSet rsOps = st.executeQuery("SELECT operator_id, operator_name FROM Operators");
                    while(rsOps.next()){
              %>
              <option value="<%= rsOps.getInt("operator_id") %>">
                <%= rsOps.getString("operator_name") %>
              </option>
              <%
                    }
                    rsOps.close();
                    st.close();
                } catch(Exception e) {
                    out.println("Error loading operators: " + e.getMessage());
                }
              %>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">Update</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 🔹 JS to Fill Edit Modal -->
<script>
document.addEventListener("DOMContentLoaded", function(){
    var editModal = document.getElementById("editBusModal");
    editModal.addEventListener("show.bs.modal", function(event){
        var button = event.relatedTarget;

        document.getElementById("editBusId").value = button.getAttribute("data-id");
        document.getElementById("editBusNumber").value = button.getAttribute("data-number");
        document.getElementById("editBusType").value = button.getAttribute("data-type");
        document.getElementById("editCapacity").value = button.getAttribute("data-capacity");
        document.getElementById("editOperator").value = button.getAttribute("data-operator");
    });
});
</script>

</body>
</html>
