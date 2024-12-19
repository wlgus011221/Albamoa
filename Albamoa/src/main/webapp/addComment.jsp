<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>알바모아</title>
</head>
<body>
<%
    // Get the comment content entered by the user
    String comment = request.getParameter("comment");
    String userIdStr = (String) session.getAttribute("userId"); // Logged-in user ID
    String boardId = request.getParameter("board_id"); // Board ID

    if (userIdStr == null) {
        out.println("<script>alert('Login is required.');location.href='login.jsp';</script>");
        return;
    }

    if (boardId == null || boardId.trim().isEmpty()) {
        out.println("<script>alert('유효하지 않은 요청입니다. (게시판 ID가 없습니다)');history.back();</script>");
        return;
    }

    if (comment == null || comment.trim().isEmpty()) {
        out.println("<script>alert('댓글 내용을 입력해주세요.');history.back();</script>");
        return;
    }

    // Database connection settings
    String url = "jdbc:mysql://localhost:3306/web_db"; // Database URL
    String dbUsername = "root"; // Database username
    String dbPassword = "123456"; // Database password

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        // Connect to the database
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Check user ID in the user table
        String checkUserSql = "SELECT user_id FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(checkUserSql);
        pstmt.setString(1, userIdStr);
        rs = pstmt.executeQuery();
        
        int userId = 0; // Initialize
        if (!rs.next()) {
            // User ID is not found in the user table
            out.println("<script>alert('Invalid user.');history.back();</script>");
            return;
        } else {
            userId = rs.getInt("user_id");
        }
        rs.close();
        pstmt.close();

        // SQL query to insert comment
        String sql = "INSERT INTO comment (board_id, user_id, comment) VALUES (?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, boardId);
        pstmt.setInt(2, userId);
        pstmt.setString(3, comment);

        // Execute the query
        int result = pstmt.executeUpdate();

        if (result > 0) {
            // Comment added successfully, now update the comment count
            pstmt.close(); // Close previous statement

            String updateBoardSql = "UPDATE talk_post SET comment = comment + 1 WHERE board_id = ?";
            pstmt = conn.prepareStatement(updateBoardSql);
            pstmt.setString(1, boardId);
            pstmt.executeUpdate();

            response.sendRedirect("talkList.jsp");
        } else {
            // Failed to add comment
            out.println("<script>alert('Failed to add comment.');history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('Error occurred while adding comment: " + e.getMessage() + "');history.back();</script>");
    } finally {
        // Release resources
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

</body>
</html>
