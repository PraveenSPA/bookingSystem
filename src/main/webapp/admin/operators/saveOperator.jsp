<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
String name = request.getParameter("operator_name");
String contact = request.getParameter("contact_number");

try {
    PreparedStatement checkStmt = con.prepareStatement("SELECT COUNT(*) FROM Operators WHERE contact_number=?");
    checkStmt.setString(1, contact);
    ResultSet rsCheck = checkStmt.executeQuery();

    if(rsCheck.next() && rsCheck.getInt(1) > 0) {
%>
<script>
    alert("Contact number already exists!");
    window.history.back();
</script>
<%
    } else {
        PreparedStatement pst = con.prepareStatement("INSERT INTO Operators(operator_name, contact_number, status) VALUES (?, ?, 1)");
        pst.setString(1, name);
        pst.setString(2, contact);
        pst.executeUpdate();
%>
<script>
    alert("Operator added successfully!");
    window.location.href = "manageOperators.jsp";
</script>
<%
    }
    rsCheck.close();
    checkStmt.close();
} catch(Exception e){
%>
<script>
    alert("Database Error: <%= e.getMessage() %>");
    window.history.back();
</script>
<%
}
%>
