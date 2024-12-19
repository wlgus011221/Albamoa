<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알바모아</title>
    <style>
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 20px;
        }
        h2 {
            text-align: center;
        }
        .write-btn-container {
            text-align: right;
            margin: 20px;
        }
        .post-container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 20px;
            cursor: pointer;
        }
        .post-header {
            font-weight: bold;
        }
        .post-link {
            text-decoration: none;
            color: black;
        }
        .post-footer {
            text-align: right;
            margin-top: 10px;
        }
        .btn {
            padding: 10px 20px;
            font-size: 16px;
            cursor: pointer;
            text-decoration: none;
            color: #fff;
            background-color: #FD9F28;
            border: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #FD991C;
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<br>
<h2>게시판 목록</h2>
<div class="write-btn-container">
    <a href="talkWrite.jsp" class="btn">게시글 작성</a>
</div>
<br>

<%
	//데이터베이스 연결 설정
	String url = "jdbc:mysql://localhost:3306/web_db"; // 데이터베이스 URL
	String dbUsername = "root"; // 데이터베이스 사용자 이름
	String dbPassword = "123456"; // 데이터베이스 비밀번호

	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
 
    List<String[]> postList = new ArrayList<>();

    
    try{
    	// JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);
    		
    	// TALK_POST 테이블과 user 테이블을 조인하여 nickname을 가져오는 쿼리 수정
    	String query = "SELECT T.board_id, U.nickname, T.title, T.content, T.date, T.view, T.comment " +
    	    "FROM talk_post T " +
    	    "INNER JOIN user U ON T.user_id = U.user_id " +
    	    "ORDER BY T.date DESC";
            
    	pstmt = conn.prepareStatement(query);
    	
        // 쿼리 실행
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            String[] post = new String[7];
            post[0] = rs.getString("board_id");
            post[1] = rs.getString("title");
            post[2] = rs.getString("nickname");
            post[3] = rs.getString("content");
            post[4] = rs.getString("date");
            post[5] = rs.getString("view");
            post[6] = rs.getString("comment");

            postList.add(post);
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
    }

    if (!postList.isEmpty()) {
        for (String[] post : postList) {
%>
<div class="post-container" onclick="location.href='talkDetail.jsp?board_id=<%= post[0] %>'">
    <div class="post-header">
        <%= post[1] %> ∙ <%= post[2] %> ∙ <%= post[4] %>
    </div>
    <div class="post-body">
        <%= post[3] %>
    </div>
    <div class="post-footer">
        댓글수: <%= post[6] %>   조회수: <%= post[5] %>
    </div>
</div>
<%
        }
    } else {
%>
<p>게시글이 없습니다.</p>
<%
    }
%>

</body>
</html>
