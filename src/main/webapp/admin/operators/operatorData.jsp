<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
int pageNum = 1;
int recordsPerPage = 10;

if(request.getParameter("page") != null){
    pageNum = Integer.parseInt(request.getParameter("page"));
}
if(request.getParameter("recordsPerPage") != null){
    recordsPerPage = Integer.parseInt(request.getParameter("recordsPerPage"));
}

int start = (pageNum - 1) * recordsPerPage;

Statement st = null;
ResultSet rs = null;
int totalRecords = 0;

try {
    st = con.createStatement();

    // Total active operators
    ResultSet rsTotal = st.executeQuery("SELECT COUNT(*) AS total FROM Operators WHERE status=1");
    if(rsTotal.next()){
        totalRecords = rsTotal.getInt("total");
    }
    rsTotal.close();

    // Get current page data
    rs = st.executeQuery("SELECT * FROM Operators WHERE status=1 LIMIT " + start + "," + recordsPerPage);
%>

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
    while(rs.next()){
    %>
        <tr>
            <td><%= rs.getInt("operator_id") %></td>
            <td><%= rs.getString("operator_name") %></td>
            <td><%= rs.getString("contact_number") %></td>
            <td>
                <!-- Edit Button -->
                <button type="button" class="btn btn-warning btn-sm" 
                        data-bs-toggle="modal" 
                        data-bs-target="#editOperatorModal<%= rs.getInt("operator_id") %>">
                    Edit
                </button>

                <a href="deleteOperator.jsp?id=<%= rs.getInt("operator_id") %>" 
                   class="btn btn-danger btn-sm" 
                   onclick="return confirm('Are you sure you want to deactivate this operator?');">
                    Deactivate
                </a>
            </td>
        </tr>

        <!-- Edit Operator Modal -->
        <div class="modal fade" id="editOperatorModal<%= rs.getInt("operator_id") %>" tabindex="-1" aria-labelledby="editOperatorLabel<%= rs.getInt("operator_id") %>" aria-hidden="true">
            <div class="modal-dialog">
                <form action="updateOperator.jsp" method="post" class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="editOperatorLabel<%= rs.getInt("operator_id") %>">Edit Operator</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="id" value="<%= rs.getInt("operator_id") %>">
                        <div class="mb-3">
                            <label>Operator Name</label>
                            <input type="text" name="operator_name" class="form-control" 
                                   value="<%= rs.getString("operator_name") %>" required pattern="^[A-Za-z ]{6,50}$" title="6-50 letters only">
                        </div>
                        <div class="mb-3">
                            <label>Contact Number</label>
                            <input type="text" name="contact_number" class="form-control" 
                                   value="<%= rs.getString("contact_number") %>" 
                                   required maxlength="10" pattern="[6-9][0-9]{9}" 
                                   title="Enter a 10-digit number starting with 6, 7, 8, or 9">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Update</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

    <%
    }
    %>
    </tbody>
</table>

<%
    // Pagination links
    int totalPages = (int)Math.ceil(totalRecords * 1.0 / recordsPerPage);
%>
<ul class="pagination justify-content-center">
<%
for(int i=1; i<=totalPages; i++){
%>
    <li class="page-item <%= (i==pageNum)?"active":"" %>">
        <a class="page-link" href="#" data-page="<%= i %>"><%= i %></a>
    </li>
<%
}
%>
</ul>

<%
} catch(Exception e){
    out.println("Error: " + e.getMessage());
} finally {
    if(rs != null) rs.close();
    if(st != null) st.close();
}
%>
