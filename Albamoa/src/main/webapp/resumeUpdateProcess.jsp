<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    String resumeId = request.getParameter("resume_id");
    String title = request.getParameter("title");
    String education = request.getParameter("education");
    String experienceType = request.getParameter("experience_type");
    String companyName = request.getParameter("company_name");
    String startDate = request.getParameter("start_date");
    String endDate = request.getParameter("end_date");
    String business = request.getParameter("business");
    String selfIntroduction = request.getParameter("info");
   	
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/web_db";
        String dbUsername = "root";
        String dbPassword = "123456";
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        String updateQuery = "UPDATE resume SET title = ?, academy = ?, career = ?, company_name = ?, start_date = ?, end_date = ?, business = ?, info = ? WHERE resume_id = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, title);
        pstmt.setString(2, education);
        pstmt.setInt(3, Integer.parseInt(experienceType));
        pstmt.setString(4, companyName);
        pstmt.setString(5, startDate);
        pstmt.setString(6, endDate);
        pstmt.setString(7, business);
        pstmt.setString(8, selfIntroduction);
        pstmt.setInt(9, Integer.parseInt(resumeId));
        
        int rowsUpdated = pstmt.executeUpdate();
        if (rowsUpdated > 0) {
            out.println("<script>alert('이력서가 성공적으로 업데이트되었습니다.'); location.href='myPage.jsp';</script>");
        } else {
            out.println("<script>alert('이력서 업데이트에 실패했습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
