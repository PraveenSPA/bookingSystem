<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="../../dbc.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="../includes/adminHeader.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Operators</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
</head>
<body class="container mt-4">

<h2 class="mb-3 text-primary">Manage Operators</h2>

<!-- Add Operator Button -->
<button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#addOperatorModal">
    Add Operator
</button>

<!-- Operators Table -->
<table id="operatorsTable" class="table table-bordered table-striped">
    <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Contact</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <%
        try {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM Operators ORDER BY operator_id DESC");
            while(rs.next()){
                int id = rs.getInt("operator_id");
                String name = rs.getString("operator_name");
                String contact = rs.getString("contact_number");
                int status = rs.getInt("status"); // 1=active, 0=inactive
    %>
        <tr>
            <td><%= id %></td>
            <td><%= name %></td>
            <td><%= contact %></td>
            <td><%= (status==1)?"Active":"Inactive" %></td>
            <td>
                <button type="button" class="btn btn-warning btn-sm editBtn" data-id="<%= id %>" data-name="<%= name %>" data-contact="<%= contact %>">Edit</button>
                
                <%
                    if(status==1){
                %>
                    <a href="deactivateOperator.jsp?id=<%= id %>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to deactivate this operator?');">
                        Deactivate
                    </a>
                <%
                    } else {
                %>
                    <button class="btn btn-secondary btn-sm" disabled>Deactivated</button>
                <%
                    }
                %>
            </td>
        </tr>


    <%
            }
            rs.close();
            st.close();
        } catch(Exception e){
            out.println("Error: "+e.getMessage());
        }
    %>
    </tbody>
</table>

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
                    <input type="text" name="operator_name" class="form-control" required pattern="^[A-Za-z ]{6,50}$" title="6-50 letters only">
                </div>
                <div class="mb-3">
                    <label>Contact Number</label>
                    <input type="text" name="contact_number" class="form-control" required maxlength="10" pattern="[6-9][0-9]{9}" title="10-digit number starting with 6,7,8,9">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Save</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>
<!-- Single Edit Operator Modal -->
<div class="modal fade" id="editOperatorModal" tabindex="-1" aria-labelledby="editOperatorLabel" aria-hidden="true">
    <div class="modal-dialog">
        <form id="editOperatorForm" action="updateOperator.jsp" method="post" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editOperatorLabel">Edit Operator</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="id" id="edit_id">
                <div class="mb-3">
                    <label>Operator Name</label>
                    <input type="text" name="operator_name" id="edit_name" class="form-control" required pattern="^[A-Za-z ]{6,50}$" title="6-50 letters only">
                </div>
                <div class="mb-3">
                    <label>Contact Number</label>
                    <input type="text" name="contact_number" id="edit_contact" class="form-control" required maxlength="10" pattern="[6-9][0-9]{9}" title="10-digit number starting with 6,7,8,9">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-primary">Update</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function(){
    $('#operatorsTable').DataTable({
        "pageLength": 5,
        "lengthChange": false,
        "ordering": true,
        "searching": true
    });
 // Edit button click
    $('.editBtn').on('click', function(){
        var id = $(this).data('id');
        var name = $(this).data('name');
        var contact = $(this).data('contact');

        $('#edit_id').val(id);
        $('#edit_name').val(name);
        $('#edit_contact').val(contact);

        $('#editOperatorModal').modal('show');
    });
});
});
</script>



</body>
</html>

<%@ include file="../includes/adminFooter.jsp" %>
