<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    // 폼에서 전달받은 데이터 가져오기
    String id = request.getParameter("user_id");
    String jobId = request.getParameter("job_id");
    String resumeId = request.getParameter("resume_id");
    String message = request.getParameter("job_message");
    String title = request.getParameter("job_title");

    // 데이터베이스 연결 정보
    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        // user_id를 user 테이블에서 조회
        int userId = 0;
        String getUserSql = "SELECT user_id FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(getUserSql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            userId = rs.getInt("user_id");
        }
        rs.close();
        pstmt.close();

        if (userId != 0) {
            // SQL 쿼리 준비
            String sql = "INSERT INTO job_apply (user_id, job_id, resume_id, message, title) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.setInt(2, Integer.parseInt(jobId));
            pstmt.setInt(3, Integer.parseInt(resumeId));
            pstmt.setString(4, message);
            pstmt.setString(5, title);

            // 쿼리 실행
            int result = pstmt.executeUpdate();

            if (result > 0) {
                out.println("<script>alert('지원이 성공적으로 완료되었습니다.'); window.close();</script>");
            } else {
                out.println("<script>alert('지원에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
            }
        } else {
            out.println("<script>alert('유효하지 않은 사용자입니다. 다시 시도해주세요.'); history.back();</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('SQL 오류가 발생했습니다. 관리자에게 문의해주세요. 오류 메시지: " + e.getMessage() + "'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요. 오류 메시지: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
