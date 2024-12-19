<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<%
    // 로그인한 사용자 ID 가져오기
    String loggedInUserId = (String) session.getAttribute("userId");
    if (loggedInUserId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 게시글을 저장할 리스트
    List<Map<String, String>> posts = new ArrayList<>();
    
    // 데이터베이스 연결 정보
    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String jdbcUrl = "jdbc:mysql://localhost:3306/web_db";
    String dbUser = "root";
    String dbPassword = "123456";
    
    // 사용자 ID 가져오기 및 게시글 가져오기 SQL 쿼리
    String userQuery = "SELECT user_id FROM user WHERE id = ?";
    String postQuery = "SELECT resume_id, title FROM resume WHERE user_id = ?";
    
    try {
        Class.forName(jdbcDriver);
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
            PreparedStatement pstmtPost = conn.prepareStatement(postQuery);
        ) {
            // 사용자 ID 가져오기
            pstmtUser.setString(1, loggedInUserId);
            try (ResultSet rsUser = pstmtUser.executeQuery()) {
                if (rsUser.next()) {
                    int userId = rsUser.getInt("user_id");

                    // 게시글 가져오기
                    pstmtPost.setInt(1, userId);
                    try (ResultSet rsPost = pstmtPost.executeQuery()) {
                        while (rsPost.next()) {
                            Map<String, String> post = new HashMap<>();
                            post.put("id", rsPost.getString("resume_id"));
                            post.put("title", rsPost.getString("title"));
                            posts.add(post);
                        }
                    }
                } else {
                    out.println("<script>alert('유효하지 않은 사용자입니다.'); location.href='login.jsp';</script>");
                    return;
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    table {
        width: 100%;
        border-collapse: collapse;
    }
    th, td {
        border-top: 1px solid #ddd;
        border-bottom: 1px solid #ddd;
        border-left: none;
        border-right: none;
        padding: 8px;
        text-align: center;
    }
    th {
        background-color: #fff;
    }
     a {
        color: black;
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }
    .button {
        background-color: white;
        border: 1px solid black;
        padding: 5px 10px;
        text-decoration: none;
        color: black;
        cursor: pointer;
    }
    .button:hover {
        background-color: #ddd;
    }
</style>
</head>
<body>
    <h2>이력서 목록</h2>
    <table>
        <colgroup>
            <col style="width: 80%;">
            <col style="width: 20%;">
        </colgroup>
        <thead>
            <tr>
                <th>제목</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Map<String, String> post : posts) {
            %>
                <tr>
                    <td><a href="#" onclick="window.top.location.href='resumeUpdate.jsp?resume_id=<%= post.get("id") %>'"><%= post.get("title") %></a></td>
                    <td>
                        <button class="button" onclick="location.href='resumeDelete.jsp?resume_id=<%= post.get("id") %>'">삭제</button>
                    </td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
