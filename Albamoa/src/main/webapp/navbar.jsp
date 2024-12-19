<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.*" %>
<style>
    .navbar-container {
        background-color: #fff;
        overflow: hidden;
    }

    .logo {
        width: 150px;
        flex-grow: 1;
    }

    .search-container {
        flex-grow: 2;
        display: flex;
        justify-content: center;
        margin-top: 20px;
        margin-bottom: 20px;
    }

    .search-container input[type="text"] {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        width: 600px;
        margin-left: 10px;
    }

    .search-container button {
        padding: 10px;
        border: none;
        border-radius: 5px;
        background-color: #FD9F28;
        color: white;
        cursor: pointer;
        margin-left: 10px;
    }

    .search-container button:hover {
        background-color: #FD991C;
    }

    .navbar-content {
        overflow: hidden;
        background-color: #fff;
    }

    .navbar-content a {
        float: left;
        display: block;
        color: black;
        text-align: center;
        padding: 14px 20px;
        text-decoration: none;
        font-weight: bold;
    }

    .navbar-content a:hover {
        background-color: #ddd;
        color: black;
    }

    .navbar-right {
        float: right;
        padding-left: 20px;
    }

    .navbar-container a img {
        height: 50px;
        width: 160px;
    }

    .navbar-content hr {
        margin-top: 0;
    }
</style>

<%
    String username = null;

    if (session != null) {
        username = (String) session.getAttribute("userId");
    }

    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("username")) {
                username = cookie.getValue();
            }
        }
    }
    
    String query = request.getParameter("query"); // 검색어 추출
%>

<div class="navbar-container">
    <div class="search-container">
    	<a href="main.jsp"><img src="image/logo.png" alt="Logo"></a>
        <form action="search.jsp" method="get">
            <input type="text" name="query" value="<%= query != null ? query : "" %>" placeholder="어떤 알바를 찾으세요?" maxlength="20" onkeypress="if(event.keyCode==13) {this.form.submit(); return false;}">
            <button type="submit" class="search"> 검색 </button>
        </form>
    </div>
    <div class="navbar-content">
	    <a href="news.jsp">채용정보</a>
	    <a href="talkList.jsp">알바토크</a>
	    <a href="myPage.jsp">마이페이지</a>
	    <a href="newResume.jsp">이력서 등록</a>
	    <a href="newNotice.jsp">공고 등록</a>
	    <div class="navbar-right">
	        <%
	            if (username != null) {
	                out.println("<span>환영합니다, " + username + "님</span>");
	                out.println("<a href='logout.jsp'>로그아웃</a>");
	            } else {
	                out.println("<a href='login.jsp'>로그인</a>");
	                out.println("<a href='signup.jsp'>회원가입</a>");
	            }
	        %>
	    </div>
	</div>
</div>
<hr>
