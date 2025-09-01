<%@ page import="java.sql.*" %>
<%
    String jdbcURL = "jdbc:mysql://localhost:3306/bus_booking_system";
    String dbUser = "root";
    String dbPassword = "praveen";

    Connection con = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
    } catch (Exception e) {
        out.println("Database connection failed: " + e.getMessage());
    }
%>
