
<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ include file="../includes/adminHeader.jsp" %>

<div class="container mt-4">
    <h3 class="text-primary mb-4">Operators</h3>

    <!-- Add Operator Button -->
    <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addOperatorModal">
        Add Operator
    </button>

    <!-- Operators Table -->
    <table class="table table-bordered table-striped">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Contact</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <%
            int pageNum = 1;
            int recordsPerPage = 10;
            if(request.getParameter("page") != null){
                pageNum = Integer.parseInt(request.getParameter("page"));
            }
            int start = (pageNum - 1) * recordsPerPage;

            Statement st = null;
            ResultSet rs = null;
            int totalRecords = 0;

            try {
                st = con.createStatement();

                // Get total records
                ResultSet rsTotal = st.executeQuery("SELECT COUNT(*) AS total FROM Operators");
                if(rsTotal.next()){
                    totalRecords = rsTotal.getInt("total");
                }
                rsTotal.close();

                // Get current page data
                rs = st.executeQuery("SELECT * FROM Operators LIMIT " + start + "," + recordsPerPage);
                while(rs.next()){
        %>
            <tr>
                <td><%= rs.getInt("operator_id") %></td>
                <td><%= rs.getString("operator_name") %></td>
                <td><%= rs.getString("contact_number") %></td>
                <td>
                    <a href="editOperator.jsp?id=<%= rs.getInt("operator_id") %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="deleteOperator.jsp?id=<%= rs.getInt("operator_id") %>" 
                       class="btn btn-danger btn-sm" 
                       onclick="return confirm('Are you sure you want to delete this operator?');">
                        Delete
                    </a>
                </td>
            </tr>
        <%
                }
            } catch(Exception e){
                out.println("Error: " + e.getMessage());
            } finally {
                if(rs != null) rs.close();
                if(st != null) st.close();
                if(con != null) con.close();
            }
        %>
        </tbody>
    </table>

    <!-- Pagination -->
    <nav>
        <ul class="pagination">
        <%
            int totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
            if(pageNum > 1){
        %>
            <li class="page-item">
                <a class="page-link" href="manageOperators.jsp?page=<%= pageNum-1 %>">Prev</a>
            </li>
        <%
            }
            for(int i=1; i<=totalPages; i++){
        %>
            <li class="page-item <%= (i==pageNum)?"active":"" %>">
                <a class="page-link" href="manageOperators.jsp?page=<%= i %>"><%= i %></a>
            </li>
        <%
            }
            if(pageNum < totalPages){
        %>
            <li class="page-item">
                <a class="page-link" href="manageOperators.jsp?page=<%= pageNum+1 %>">Next</a>
            </li>
        <%
            }
        %>
        </ul>
    </nav>
</div>

<!-- Add Operator Modal -->
<div class="modal fade" id="addOperatorModal" tabindex="-1" aria-labelledby="addOperatorLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form action="saveOperator.jsp" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addOperatorLabel">Add Operator</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Operator Name</label>
                    <input type="text" name="operator_name" class="form-control" required>
                </div>
                <div class="mb-3">
                    <label>Contact Number</label>
                    <input type="text" name="contact_number" class="form-control" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Save</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<%@ include file="../includes/adminFooter.jsp" %>
