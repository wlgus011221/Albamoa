<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.text.ParseException" %>

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
    String jobPostingQuery = "SELECT job_id FROM job_posting WHERE user_id = ?";
    String jobApplyQuery = "SELECT ja.resume_id, ja.user_id, ja.date, ja.title, ja.message FROM job_apply ja WHERE ja.job_id = ?";
    String userDetailsQuery = "SELECT name, sex, phone, birth, mail FROM user WHERE user_id = ?";
    
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

                    // 작성한 공고 가져오기
                    try (PreparedStatement pstmtJobPosting = conn.prepareStatement(jobPostingQuery)) {
                        pstmtJobPosting.setInt(1, userId);
                        try (ResultSet rsJobPosting = pstmtJobPosting.executeQuery()) {
                            while (rsJobPosting.next()) {
                                int jobId = rsJobPosting.getInt("job_id");

                                // 해당 공고에 지원된 항목 가져오기
                                try (PreparedStatement pstmtJobApply = conn.prepareStatement(jobApplyQuery)) {
                                    pstmtJobApply.setInt(1, jobId);
                                    try (ResultSet rsJobApply = pstmtJobApply.executeQuery()) {
                                        while (rsJobApply.next()) {
                                            Map<String, String> post = new HashMap<>();
                                            int applyUserId = rsJobApply.getInt("user_id");
                                            post.put("resume_id", rsJobApply.getString("resume_id"));
                                            post.put("date", rsJobApply.getString("date"));
                                            post.put("title", rsJobApply.getString("title"));
                                            post.put("message", rsJobApply.getString("message"));
                                            
                                         	// 사용자 정보 가져오기
                                            try (PreparedStatement pstmtUserDetails = conn.prepareStatement(userDetailsQuery)) {
                                                pstmtUserDetails.setInt(1, applyUserId);
                                                try (ResultSet rsUserDetails = pstmtUserDetails.executeQuery()) {
                                                    if (rsUserDetails.next()) {
                                                        post.put("name", rsUserDetails.getString("name"));
                                                        post.put("sex", rsUserDetails.getString("sex"));
                                                        post.put("age", rsUserDetails.getString("birth").substring(0,4));
                                                        post.put("phone", rsUserDetails.getString("phone"));
                                                        post.put("email", rsUserDetails.getString("mail"));
                                                    }
                                                }
                                            }
                                            posts.add(post);
                                        }
                                    }
                                }
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
        	<col style="width: 10%;">
            <col style="width: 45%;">
            <col style="width: 30%;">
            <col style="width: 15%;">
        </colgroup>
        <thead>
            <tr>
                <th></th>
                <th>이력사항</th>
                <th>지원자 정보</th>
                <th>지원일자</th>
            </tr>
        </thead>
        <tbody>
            <%
                for (Map<String, String> post : posts) {
            %>
                <tr>
                	<td><img id="photoPreview" src="image/user.jpg" alt="기본이미지"></td>
                    <td>
                    	<strong><a href="javascript:void(0);" class="resumeDetailButton" onclick="openResumePopup('<%= post.get("resume_id") %>')"><%= post.get("title") %></a></strong><br>
                    	<br>
                    	전달메시지 : <%= post.get("message") %>
                    </td>
                    <td>
                    	<%= post.get("name") %>(<%= post.get("sex") %>, <%= post.get("age") %>년생)<br>
                    	전화번호 : <%= post.get("phone") %><br>
                    	이메일 : <%= post.get("email") %>
                    </td>
                    <td><%= post.get("date") %></td>
                </tr>
            <%
                }
            %>
        </tbody>
    </table>
<script>
function openResumePopup(resumeId) {
    window.open("bossResumeCheck.jsp?resume_id=" + resumeId, "이력서 보기", "width=800,height=600,scrollbars=yes");
}
</script>
</body>
</html>
