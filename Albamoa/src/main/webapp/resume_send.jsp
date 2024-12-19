<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
	String loggedInUserId = (String) session.getAttribute("userId");
	String title = request.getParameter("title");
	String education = request.getParameter("education");
	String experience_type = request.getParameter("experience_type");
	String companyName = request.getParameter("company_name");
	String startDate = request.getParameter("start_date");
	String endDate = request.getParameter("end_date");
	String business = request.getParameter("business");
	String selfIntroduction = request.getParameter("info");
	
    int userId = 0;

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String dbUsername = "root";
    String dbPassword = "123456";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmtSido = null;
    PreparedStatement pstmtSigg = null;
    PreparedStatement pstmtEmd = null;
    ResultSet rs = null;
 
    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        
        // 유효한 사용자 확인
        String userQuery = "SELECT user_id FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(userQuery);
        pstmt.setString(1, loggedInUserId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            userId = rs.getInt("user_id");
        } else {
            out.println("<script>alert('유효하지 않은 사용자입니다.'); location.href='login.jsp';</script>");
            return;
        }
        rs.close();
        pstmt.close();

        // 이력서 저장
        String insertResumeSQL;
        if (experience_type.equals("0")) {
            insertResumeSQL = "INSERT INTO resume (user_id, title, academy, career, info) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertResumeSQL);
            pstmt.setInt(1, userId);
            pstmt.setString(2, title);
            pstmt.setString(3, education);
            pstmt.setInt(4, Integer.parseInt(experience_type));
            pstmt.setString(5, selfIntroduction);
        } else if (experience_type.equals("1")) {
            insertResumeSQL = "INSERT INTO resume (user_id, title, academy, career, company_name, start_date, end_date, business, info) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertResumeSQL);
            pstmt.setInt(1, userId);
            pstmt.setString(2, title);
            pstmt.setString(3, education);
            pstmt.setInt(4, Integer.parseInt(experience_type));
            pstmt.setString(5, companyName);
            pstmt.setString(6, startDate);
            pstmt.setString(7, endDate);
            pstmt.setString(8, business);
            pstmt.setString(9, selfIntroduction);
        }

        int rows = pstmt.executeUpdate();
        
        if (rows > 0) {
            out.println("<script>alert('이력서가 성공적으로 저장되었습니다.'); location.href='myPage.jsp';</script>");
        } else {
            out.println("<script>alert('이력서 저장에 실패했습니다.'); history.back();</script>");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }
%>
