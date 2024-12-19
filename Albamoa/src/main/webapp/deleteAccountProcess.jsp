<!-- deleteAccountProcess.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>

<%
    // 세션에서 로그인한 사용자 아이디 가져오기
    String loggedInUserId = (String) session.getAttribute("userId");

    // 폼에서 입력받은 사용자 아이디 가져오기
    String id = request.getParameter("id");

    if (id == null || id.isEmpty()) {
        out.println("<script>alert('아이디를 입력하세요.');history.back();</script>");
        return;
    }

    if (id.equals(loggedInUserId)) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String dbURL = "jdbc:mysql://localhost:3306/web_db";
            String dbUsername = "root";
            String dbPassword = "123456";
            conn = DriverManager.getConnection(dbURL, dbUsername, dbPassword);

            String sql = "DELETE FROM user WHERE id=?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, id);
            int result = pstmt.executeUpdate();

            if (result > 0) {
            	// 디버깅 메시지 추가
                System.out.println("회원 탈퇴 성공: " + id);

                session.invalidate();

                Cookie[] cookies = request.getCookies();
                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        cookie.setMaxAge(0); // 쿠키 유효기간을 0으로 설정하여 삭제
                        response.addCookie(cookie);
                    }
                }
                
                out.println("<script>alert('회원탈퇴에 성공했습니다.'); window.top.location.href='main.jsp';</script>");
            } else {
                out.println("<script>alert('회원탈퇴에 실패했습니다.');history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('회원탈퇴 처리 중 오류가 발생했습니다.');history.back();</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    } else {
        out.println("<script>alert('입력된 아이디와 로그인한 아이디가 다릅니다.');history.back();</script>");
    }
%>
