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
    String updateQuery = "UPDATE talk_post SET title = ?, content = ? WHERE board_id = ? AND user_id = ?";

    try {
        Class.forName(jdbcDriver);
        
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
            PreparedStatement pstmtUpdate = conn.prepareStatement(updateQuery);
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

            String boardId = request.getParameter("board_id");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
         
            // 입력 값 유효성 검사
            if (title == null || title.isEmpty() || content == null || content.isEmpty() || boardId == null || boardId.isEmpty()) {
                out.println("<script>alert('모든 필드를 채워주세요.'); history.back();</script>");
                return;
            }

            pstmtUpdate.setString(1, title);
            pstmtUpdate.setString(2, content);
            pstmtUpdate.setInt(3, Integer.parseInt(boardId));
            pstmtUpdate.setInt(4, userId);

            int rows = pstmtUpdate.executeUpdate();

            if (rows > 0) {
                out.println("<script>alert('게시글이 성공적으로 수정되었습니다.'); window.top.location.href='myPage.jsp';</script>");
            } else {
                out.println("<script>alert('게시글 수정에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
