<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="dbc.jsp" %>
<%
    String loginid = request.getParameter("loginid");
    String password = request.getParameter("password");

    try {
        // 1️⃣ Check in users table
        PreparedStatement pstUser = con.prepareStatement(
            "SELECT * FROM users WHERE (email=? OR phone=?) AND password=?"
        );
        pstUser.setString(1, loginid);
        pstUser.setString(2, loginid);
        pstUser.setString(3, password);
        ResultSet rsUser = pstUser.executeQuery();

        if (rsUser.next()) {
            session.setAttribute("username", rsUser.getString("full_name"));
            session.setAttribute("role", "user");
            session.setAttribute("user_id", rsUser.getInt("user_id"));
            response.sendRedirect("userDashboard.jsp");
        } else {
            // 2️⃣ Check in admins table
            PreparedStatement pstAdmin = con.prepareStatement(
                "SELECT * FROM admins WHERE (email=? OR phone=?) AND password=?"
            );
            pstAdmin.setString(1, loginid);
            pstAdmin.setString(2, loginid);
            pstAdmin.setString(3, password);
            ResultSet rsAdmin = pstAdmin.executeQuery();

            if (rsAdmin.next()) {
                session.setAttribute("username", rsAdmin.getString("full_name"));
                session.setAttribute("role", "admin");
                response.sendRedirect("admin/adminDashboard.jsp");
            } else {
                // 3️⃣ No match → invalid login
            	out.println("<script>alert('Invalid credentials!'); window.location='userDashboard.jsp';</script>");

            }

            rsAdmin.close();
            pstAdmin.close();
        }

        rsUser.close();
        pstUser.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
