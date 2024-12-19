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
    String jobApplyQuery = "SELECT ja.job_id, ja.resume_id, ja.user_id, ja.date, ja.title, ja.message, jp.title as job_title " +
                           "FROM job_apply ja " +
                           "JOIN job_posting jp ON ja.job_id = jp.job_id " +
                           "WHERE ja.user_id = ?";

    try {
        Class.forName(jdbcDriver);
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
        ) {
            // 사용자 ID 가져오기
            pstmtUser.setString(1, loggedInUserId);
            try (ResultSet rsUser = pstmtUser.executeQuery()) {
                if (rsUser.next()) {
                    int userId = rsUser.getInt("user_id");

                    // 작성한 공고에 지원된 항목 가져오기
                    try (PreparedStatement pstmtJobApply = conn.prepareStatement(jobApplyQuery)) {
                        pstmtJobApply.setInt(1, userId);
                        try (ResultSet rsJobApply = pstmtJobApply.executeQuery()) {
                            while (rsJobApply.next()) {
                                Map<String, String> post = new HashMap<>();
                                post.put("job_id", rsJobApply.getString("job_id"));
                                post.put("date", rsJobApply.getString("date"));
                                post.put("title", rsJobApply.getString("job_title"));
                                post.put("message", rsJobApply.getString("message"));
                                posts.add(post);
                            }
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
    img {
        width: 100px;
        height: 100px;
        display: block;
        margin: 0 auto;
        margin-left: 0px;
    }
</style>
</head>
<body>
    <h2>지원된 공고 목록</h2>
    <table>
        <colgroup>
            <col style="width: 70%;">
            <col style="width: 20%;">
            <col style="width: 10%;">
        </colgroup>
        <thead>
            <tr>
                <th>지원공고</th>
                <th>지원일자</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Map<String, String> post : posts) {
            %>
                <tr>
                    <td><a href="#" onclick="window.top.location.href='noticeDetail.jsp?id=<%= post.get("job_id") %>'"><%= post.get("title") %></a></td>
                    <td><%= post.get("date") %></td>
                    <td>
                        <button class="button" onclick="location.href='appliedDelete.jsp?id=<%= post.get("id") %>'">삭제</button>
                    </td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
