<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>

<%
    request.setCharacterEncoding("UTF-8");

    PreparedStatement ps = con.prepareStatement(
        "INSERT INTO Drivers (driver_name,dob,joining_date,phone,email,address,license_number,license_type,license_expiry,emergency_contact_name,emergency_contact_phone,remarks) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)"
    );
    ps.setString(1, request.getParameter("driver_name"));
    ps.setDate(2, java.sql.Date.valueOf(request.getParameter("dob")));
    ps.setDate(3, java.sql.Date.valueOf(request.getParameter("joining_date")));
    ps.setString(4, request.getParameter("phone"));
    ps.setString(5, request.getParameter("email"));
    ps.setString(6, request.getParameter("address"));
    ps.setString(7, request.getParameter("license_number"));
    ps.setString(8, request.getParameter("license_type"));
    ps.setDate(9, java.sql.Date.valueOf(request.getParameter("license_expiry")));
    ps.setString(10, request.getParameter("emergency_contact_name"));
    ps.setString(11, request.getParameter("emergency_contact_phone"));
    ps.setString(12, request.getParameter("remarks"));
    ps.executeUpdate();
    ps.close();

    response.sendRedirect("manageDrivers.jsp");
%>
