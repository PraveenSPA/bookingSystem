<%@ page import="java.sql.*" %>
<%@ include file="../../dbc.jsp" %>
<%
    response.setContentType("application/json");
    int id = Integer.parseInt(request.getParameter("id"));

    PreparedStatement ps = con.prepareStatement("SELECT * FROM Drivers WHERE driver_id=?");
    ps.setInt(1, id);
    ResultSet rs = ps.executeQuery();

    if(rs.next()){
        String json = "{"
            + "\"driver_id\":" + rs.getInt("driver_id") + ","
            + "\"driver_name\":\"" + rs.getString("driver_name") + "\","
            + "\"dob\":\"" + rs.getString("dob") + "\","
            + "\"joining_date\":\"" + rs.getString("joining_date") + "\","
            + "\"phone\":\"" + rs.getString("phone") + "\","
            + "\"email\":\"" + rs.getString("email") + "\","
            + "\"address\":\"" + rs.getString("address") + "\","
            + "\"license_number\":\"" + rs.getString("license_number") + "\","
            + "\"license_type\":\"" + rs.getString("license_type") + "\","
            + "\"license_expiry\":\"" + rs.getString("license_expiry") + "\","
            + "\"emergency_contact_name\":\"" + rs.getString("emergency_contact_name") + "\","
            + "\"emergency_contact_phone\":\"" + rs.getString("emergency_contact_phone") + "\","
            + "\"status\":\"" + rs.getString("status") + "\","
            + "\"remarks\":\"" + (rs.getString("remarks")!=null?rs.getString("remarks"):"") + "\""
            + "}";
        out.print(json);
    }
    rs.close(); ps.close();
%>
