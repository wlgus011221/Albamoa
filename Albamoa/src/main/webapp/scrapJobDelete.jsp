<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String jobId = request.getParameter("id");
    String loggedInUserId = (String) session.getAttribute("userId");
    
    if (jobId == null || loggedInUserId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String jdbcUrl = "jdbc:mysql://localhost:3306/web_db";
    String dbUser = "root";
    String dbPassword = "123456";

    String deleteQuery = "DELETE FROM scrap_job WHERE job_id = ? AND user_id = (SELECT user_id FROM user WHERE id = ?)";

    try {
        Class.forName(jdbcDriver);
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmt = conn.prepareStatement(deleteQuery);
        ) {
            pstmt.setInt(1, Integer.parseInt(jobId));
            pstmt.setString(2, loggedInUserId);

            int rows = pstmt.executeUpdate();
            if (rows > 0) {
                out.println("<script>alert('스크랩이 삭제되었습니다.'); window.top.location.href='myPage.jsp';</script>");
                return;
            } else {
                out.println("<script>alert('스크랩 삭제에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
