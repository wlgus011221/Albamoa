<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    // 세션에서 userId 가져오기
    String userIdStr = (String) session.getAttribute("userId");
    if (userIdStr == null) {
        out.println("<script>alert('로그인이 필요합니다. 로그인 후 다시 시도해주세요.'); location.href='login.jsp';</script>");
        return;
    }

    int userId = 0;
    String job_id = request.getParameter("job_id");
    
    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String jdbcUrl = "jdbc:mysql://localhost:3306/web_db";
    String dbUser = "root";
    String dbPassword = "123456";

    String userQuery = "SELECT user_id FROM user WHERE id = ?";
    String insertQuery = "INSERT INTO scrap_job (user_id, job_id) VALUES (?, ?)";

    try {
        Class.forName(jdbcDriver);
        
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
            PreparedStatement pstmtInsert = conn.prepareStatement(insertQuery);
        ) {
            pstmtUser.setString(1, userIdStr);
            try (ResultSet rs = pstmtUser.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    out.println("<script>alert('유효하지 않은 사용자입니다.'); location.href='login.jsp';</script>");
                    return;
                }
            }

            pstmtInsert.setInt(1, userId);
            pstmtInsert.setInt(2, Integer.parseInt(job_id));

            int rows = pstmtInsert.executeUpdate();

            if (rows > 0) {
            	out.println("<script>alert('스크랩 되었습니다.'); history.back();</script>");
            } else {
                out.println("<script>alert('스크랩에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
