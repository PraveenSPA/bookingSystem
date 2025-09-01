
<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%
    String loginid = request.getParameter("loginid");
    String password = request.getParameter("password");
    String redirect = request.getParameter("redirect");
    if(redirect==null || redirect.isEmpty()) redirect="userDashboard.jsp";

    try{
        PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE (email=? OR phone=?) AND password=?");
        pst.setString(1, loginid);
        pst.setString(2, loginid);
        pst.setString(3, password);
        ResultSet rs = pst.executeQuery();
        if(rs.next()){
            session.setAttribute("username", rs.getString("full_name"));
            session.setAttribute("role", "user");
            response.sendRedirect(redirect); // redirect back to search page
        } else {
            out.println("<script>alert('Invalid credentials!'); window.location='"+redirect+"';</script>");
        }
        rs.close(); pst.close();
    }catch(Exception e){ out.println("Error: "+e.getMessage()); }
%>
    