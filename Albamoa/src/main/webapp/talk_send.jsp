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
    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String jdbcUrl = "jdbc:mysql://localhost:3306/web_db";
    String dbUser = "root";
    String dbPassword = "123456";

    String userQuery = "SELECT user_id FROM user WHERE id = ?";
    String insertQuery = "INSERT INTO TALK_POST (user_id, title, content, view, comment) VALUES (?, ?, ?, ?, ?)";

    try {
        Class.forName(jdbcDriver);
        
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
            PreparedStatement pstmtInsert = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
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

            String title = request.getParameter("title");
            String content = request.getParameter("content");
         
            // 입력 값 유효성 검사
            if (title == null || title.isEmpty() || content == null || content.isEmpty()) {
                out.println("<script>alert('모든 필드를 채워주세요.'); history.back();</script>");
                return;
            }

            pstmtInsert.setInt(1, userId);
            pstmtInsert.setString(2, title);
            pstmtInsert.setString(3, content);
            pstmtInsert.setInt(4, 0); // 초기 조회수
            pstmtInsert.setInt(5, 0); // 초기 댓글 수

            int rows = pstmtInsert.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("talkList.jsp"); // 게시글 리스트 페이지로 리다이렉트합니다.
            } else {
                out.println("<script>alert('데이터 저장에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
