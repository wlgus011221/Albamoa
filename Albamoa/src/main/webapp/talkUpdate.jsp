<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String boardId = request.getParameter("id");

    if (boardId == null) {
    	out.println("<script>alert('유효하지 않은 게시글입니다.'); history.back();</script>");
        return;
    }

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String jdbcUrl = "jdbc:mysql://localhost:3306/web_db";
    String dbUser = "root";
    String dbPassword = "123456";
    
    String selectQuery = "SELECT title, content FROM talk_post WHERE board_id = ?";

    String title = "";
    String content = "";

    try {
        Class.forName(jdbcDriver);
        try (
            Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            PreparedStatement pstmt = conn.prepareStatement(selectQuery);
        ) {
            pstmt.setInt(1, Integer.parseInt(boardId));

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    title = rs.getString("title");
                    content = rs.getString("content");
                } else {
                    out.println("<script>alert('유효하지 않은 게시글입니다.'); location.href='talkList.jsp';</script>");
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
<title>알바모아</title>
<style>
	.container{
		width: 80%;
		margin: 0 auto;
	}
	
    h2 {
        color: #333;
        text-align: center;
    }
    
    form {
        display: flex;
        flex-direction: column;
    }
    
    textarea {
        width: 90%;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 16px;
        resize: vertical;
    }
    
    textarea[name="title"] {
        height: 40px;
    }
    
    textarea[name="content"] {
        height: 400px;
    }
    
    .btn-container {
        text-align: center;
    }
    
    .btn-submit {
        background-color: #FD9F28;
        color: #fff;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
    }
    .btn-submit:hover {
        background-color: #FD991C;
    }
    .cancel-button {
    	background-color: #808080;
        color: #fff;
        border: none;
        padding: 10px 20px;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
    }
    .cancel-button:hover {
        background-color: #696969; /* 호버 시 더 어두운 회색 */
    }
</style>
</head>
<body>
    <div class="container">
        <form action="talkUpdateProcess.jsp" method="post">
            <input type="hidden" name="board_id" value="<%= boardId %>">
            <label for="title">제목 :</label>
            <textarea id="title" name="title" cols="180" rows="1"><%= title %></textarea>
            <label for="content">본문 :</label>
            <textarea id="content" name="content" cols="180" rows="30"><%= content %></textarea>
            <div class="btn-container">
            	<input type="button" value="취소" class="cancel-button" onclick="window.top.location.href='myPage.jsp'">	
                <button type="submit" class="btn-submit">수정하기</button>
            </div>
        </form>
    </div>
</body>
</html>
