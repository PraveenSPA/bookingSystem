
<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%
    String fp_loginid = request.getParameter("fp_loginid");
    String fp_newpassword = request.getParameter("fp_newpassword");
    String fp_confirmpassword = request.getParameter("fp_confirmpassword");
    String redirect = request.getParameter("redirect");
    if(redirect==null || redirect.isEmpty()) redirect="userDashboard.jsp";

    if(!fp_newpassword.equals(fp_confirmpassword)){
        out.println("<script>alert('Passwords do not match!'); window.location='"+redirect+"';</script>");
    } else {
        try{
            PreparedStatement pst = con.prepareStatement("SELECT * FROM users WHERE email=? OR phone=?");
            pst.setString(1, fp_loginid);
            pst.setString(2, fp_loginid);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                PreparedStatement update = con.prepareStatement("UPDATE users SET password=? WHERE email=? OR phone=?");
                update.setString(1, fp_newpassword);
                update.setString(2, fp_loginid);
                update.setString(3, fp_loginid);
                update.executeUpdate();
                update.close(); rs.close();
                out.println("<script>alert('Password reset successful! Please login.'); window.location='"+redirect+"';</script>");
            } else {
                out.println("<script>alert('Account not found! Please register first.'); window.location='"+redirect+"';</script>");
            }
            pst.close();
        }catch(Exception e){ out.println("<script>alert('Error: "+e.getMessage()+"'); window.location='"+redirect+"';</script>"); }
    }
%>
    