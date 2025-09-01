<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<!-- Modal Header -->
<div class="modal-header">
    <h5 class="modal-title">Add New Bus</h5>
    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
</div>

<!-- Modal Body -->
<div class="modal-body">
    <form action="insertBus.jsp" method="post" id="addBusForm">
        <div class="mb-3">
            <label>Bus Number</label>
            <input type="text" name="bus_number" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Bus Type</label>
            <select name="bus_type" class="form-control" required>
                <option>AC Sleeper</option>
                <option>AC Seater</option>
                <option>Non-AC Seater</option>
                <option>Volvo</option>
                <option>Luxury</option>
            </select>
        </div>

        <div class="mb-3">
            <label>Capacity</label>
            <input type="number" name="capacity" class="form-control" required>
        </div>

        <div class="mb-3">
            <label>Operator</label>
            <select name="operator_id" class="form-control" required>
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
    </form>
</div>

<!-- Modal Footer -->
<div class="modal-footer">
    <button type="submit" form="addBusForm" class="btn btn-success">Add Bus</button>
    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
</div>
