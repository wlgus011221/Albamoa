<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
    // 로그인 상태 확인
    String username = null;

    if (session != null) {
        username = (String) session.getAttribute("username");
    }

    if (username == null) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("username")) {
                    username = cookie.getValue();
                    break;
                }
            }
        }
    }

    // 로그인되지 않은 경우 로그인 페이지로 리다이렉트
    if (username == null) {
    	out.println("<script>alert('로그인이 필요합니다. 로그인 후 다시 시도해주세요.'); location.href='login.jsp';</script>");
        return;
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
</style>
</head>
<body>
	<jsp:include page="navbar.jsp" />
    <div class="container">
        
        <h2> 알바토크 </h2>
        <form action="talk_send.jsp" method="post">
            <label for="title">제목 :</label>
            <textarea id="title" name="title" cols="180" rows="1"></textarea>
            <label for="content">본문 :</label>
            <textarea id="content" name="content" cols="180" rows="30"></textarea>
            <div class="btn-container">
                <button type="submit" class="btn-submit">등록</button>
            </div>
        </form>
    </div>
</body>
</html>
