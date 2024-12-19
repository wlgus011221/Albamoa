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
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    .container {
        display: flex;
        margin: 20px;
    }
    .aside {
        width: 250px;
        height: 500px;
        padding: 20px;
        margin-right: 20px;
        border-radius: 8px;
        color: black;
        border: 1px solid #ccc;
		border-radius: 4px;
    }
    .aside h2 {
        text-align: center;
        margin-bottom: 20px;
    }
    .aside a {
        padding: 10px 20px;
        text-decoration: none;
        display: block;
        text-align: left;
        cursor: pointer;
        border: none;
        background: none;
        width: 80%;
        outline: none;
        font-size: 16px;
        color: black;
    }
    .dropdown-btn {
        padding: 10px 20px;
        text-decoration: none;
        display: block;
        text-align: left;
        cursor: pointer;
        border: none;
        background: none;
        width: 100%;
        outline: none;
        font-size: 16px;
        color: black;
    }
    .aside a:hover, .dropdown-btn:hover {
        background-color: #ddd;
    }
    .dropdown-container {
        display: none;
        background-color: #fff;
        padding-left: 20px;
    }
    .dropdown-container a {
        font-size: 14px;
    }
    .content {
        flex: 1;
        padding: 20px;
    }
    .content iframe {
        width: 100%;
        height: 100%;
        border: none;
        border-radius: 8px;
    }
    .dropdown-btn:after {
        content: '\25BC';
        float: right;
        margin-right: 8px;
    }
    .active:after {
        content: '\25B2';
    }
</style>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <div class="aside">
            <h2>마이페이지</h2>
            <div class="dropdown">
                <button class="dropdown-btn">알바 탭</button>
                <div class="dropdown-container">
                    <a href="scrapJob.jsp" target="content-frame">스크랩한 공고</a>
                    <a href="appliedJob.jsp" target="content-frame">지원한 공고</a>
                    <a href="manageResume.jsp" target="content-frame">이력서 관리</a>
                    <a href="managePost.jsp" target="content-frame">게시글 관리</a>
                    <button class="dropdown-btn">회원정보 관리</button>
                    <div class="dropdown-container">
                        <a href="editUser.jsp" target="content-frame">회원정보 수정</a>
                        <a href="deleteAccount.jsp" target="content-frame">회원 탈퇴</a>
                    </div>
                </div>
            </div>
            <div class="dropdown">
                <button class="dropdown-btn">사장 탭</button>
                <div class="dropdown-container">
                    <a href="bossJob.jsp" target="content-frame">공고 관리</a>
                    <a href="bossCheck.jsp" target="content-frame">지원 확인</a>
                </div>
            </div>
        </div>
        <div class="content">
            <iframe name="content-frame"></iframe>
        </div>
    </div>

    <script>
        var dropdown = document.getElementsByClassName("dropdown-btn");
        var i;

        for (i = 0; i < dropdown.length; i++) {
            dropdown[i].addEventListener("click", function() {
                this.classList.toggle("active");
                var dropdownContent = this.nextElementSibling;
                if (dropdownContent.style.display === "block") {
                    dropdownContent.style.display = "none";
                } else {
                    dropdownContent.style.display = "block";
                }
            });
        }
    </script>
</body>
</html>
