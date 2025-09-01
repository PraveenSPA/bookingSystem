<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbc.jsp" %>
<%
    String fullname = request.getParameter("fullname");
    String email = request.getParameter("email");
    String pass = request.getParameter("password");
    String phone = request.getParameter("phone");
    String gender = request.getParameter("gender");
    String dob = request.getParameter("dob");
    String redirect = request.getParameter("redirect");
    if(redirect==null || redirect.isEmpty()) redirect="userDashboard.jsp";

    try{
        PreparedStatement pst = con.prepareStatement(
            "INSERT INTO users(full_name,email,password,phone,gender,dob) VALUES(?,?,?,?,?,?)");
        pst.setString(1, fullname);
        pst.setString(2, email);
        pst.setString(3, pass);
        pst.setString(4, phone);
        pst.setString(5, gender);
        pst.setString(6, dob);
        int i = pst.executeUpdate();
        if(i>0){
            out.println("<script>alert('Registration successful! Please login.'); window.location='"+redirect+"';</script>");
        } else {
            out.println("<script>alert('Registration failed!'); window.location='"+redirect+"';</script>");
        }
        pst.close();
    }catch(Exception e){
        out.println("<script>alert('Error: "+e.getMessage()+"'); window.location='"+redirect+"';</script>");
    }
%>
    