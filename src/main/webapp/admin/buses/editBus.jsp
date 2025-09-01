<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    String bus_number="", bus_type="";
    int capacity=0, operator_id=0;

    try {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM Buses WHERE bus_id=?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            bus_number = rs.getString("bus_number");
            bus_type = rs.getString("bus_type");
            capacity = rs.getInt("capacity");
            operator_id = rs.getInt("operator_id");
        }
        rs.close();
        ps.close();
    } catch(Exception e){ out.println("Error: "+e.getMessage()); }
%>

<!-- Modal Header -->
<div class="modal-header">
    <h5 class="modal-title">Edit Bus</h5>
    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
</div>

<!-- Modal Body -->
<div class="modal-body">
    <form action="updateBus.jsp" method="post" id="editBusForm">
        <input type="hidden" name="bus_id" value="<%= id %>">

        <div class="mb-3">
            <label>Bus Number</label>
            <input type="text" name="bus_number" class="form-control" value="<%= bus_number %>" required>
        </div>

        <div class="mb-3">
            <label>Bus Type</label>
            <select name="bus_type" class="form-control" required>
                <option <%= "AC Sleeper".equals(bus_type)?"selected":"" %>>AC Sleeper</option>
                <option <%= "AC Seater".equals(bus_type)?"selected":"" %>>AC Seater</option>
                <option <%= "Non-AC Seater".equals(bus_type)?"selected":"" %>>Non-AC Seater</option>
                <option <%= "Volvo".equals(bus_type)?"selected":"" %>>Volvo</option>
                <option <%= "Luxury".equals(bus_type)?"selected":"" %>>Luxury</option>
            </select>
        </div>

        <div class="mb-3">
            <label>Capacity</label>
            <input type="number" name="capacity" class="form-control" value="<%= capacity %>" required>
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
                    <option value="<%= rsOps.getInt("operator_id") %>" 
                        <%= (rsOps.getInt("operator_id")==operator_id)?"selected":"" %>>
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
    <button type="submit" form="editBusForm" class="btn btn-primary">Update</button>
    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
</div>
