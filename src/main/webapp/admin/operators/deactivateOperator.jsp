<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
int id = Integer.parseInt(request.getParameter("id"));
try {
    PreparedStatement ps = con.prepareStatement("UPDATE Operators SET status=0 WHERE operator_id=?");
    ps.setInt(1, id);
    ps.executeUpdate();
%>
<script>
    alert("Operator deactivated successfully!");
    window.location.href = "manageOperators.jsp";
</script>
<%
} catch(Exception e){
%>
<script>
    alert("Error: <%= e.getMessage() %>");
    window.location.href = "manageOperators.jsp";
</script>
<%
}
%>
