<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.text.ParseException" %>

<%!
    // 시간 차이 계산 메소드
    long calculateTimeDifference(Date startDate, Date endDate) {
        long diffInMillies = endDate.getTime() - startDate.getTime();
        return diffInMillies / 1000; // 초 단위로 반환
    }

    // 남은 시간을 일, 시간, 분, 초로 변환하는 메소드
    String formatTimeDifference(long seconds) {
        long days = seconds / (24 * 60 * 60);
        seconds %= 24 * 60 * 60;
        long hours = seconds / (60 * 60);
        seconds %= 60 * 60;
        long minutes = seconds / 60;
        seconds %= 60;
        return String.format("%d일 %d시간 %d분 %d초", days, hours, minutes, seconds);
    }
%>

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
    String postQuery = "SELECT job_id, date, title, end_date FROM job_posting WHERE user_id = ?";
    
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

                    // 공고 가져오기
                    pstmtPost.setInt(1, userId);
                    try (ResultSet rsPost = pstmtPost.executeQuery()) {
                        while (rsPost.next()) {
                            Map<String, String> post = new HashMap<>();
                            post.put("id", rsPost.getString("job_id"));
                            post.put("date", rsPost.getString("date"));
                            post.put("title", rsPost.getString("title"));
                            post.put("end_date", rsPost.getString("end_date"));
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
    <h2>공고 목록</h2>
    <table>
        <colgroup>
            <col style="width: 15%;">
            <col style="width: 50%;">
            <col style="width: 15%;">
            <col style="width: 20%;">
        </colgroup>
        <thead>
            <tr>
                <th>작성일</th>
                <th>제목</th>
                <th>마감일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <%
                // 현재 시간 가져오기
                Date now = new Date();
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

                for (Map<String, String> post : posts) {
                    String endDate = post.get("end_date");
                    String remainingTime = "상시모집";

                    if (endDate != null) {
                        try {
                            Date postEndDate = sdf.parse(endDate);
                            long timeDiffInSeconds = calculateTimeDifference(now, postEndDate);
                            remainingTime = formatTimeDifference(timeDiffInSeconds);
                            remainingTime = remainingTime.split(" ")[0] + " 전";
                        } catch (ParseException e) {
                            e.printStackTrace();
                        }
                    }
            %>
                <tr>
                    <td><%= post.get("date") %></td>
                    <td><a href="#" onclick="window.top.location.href='noticeDetail.jsp?id=<%= post.get("id") %>'"><%= post.get("title") %></a></td>
                    <td><%= endDate != null ? remainingTime : "상시모집" %></td>
                    <td>
                        <button class="button" onclick="location.href='bossJobUpdate.jsp?id=<%= post.get("id") %>'">수정</button>
                        <button class="button" onclick="location.href='bossJobDelete.jsp?id=<%= post.get("id") %>'">삭제</button>
                    </td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
</body>
</html>
