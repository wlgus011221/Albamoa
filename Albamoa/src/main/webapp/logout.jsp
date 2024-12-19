<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // 세션 무효화
    if (session != null) {
        session.invalidate();
    }

    // 쿠키 삭제
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            cookie.setMaxAge(0); // 쿠키 유효기간을 0으로 설정하여 삭제
            response.addCookie(cookie);
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <script type="text/javascript">
        // 로그아웃 알림창 표시 후 리다이렉트
        alert('로그아웃 되었습니다.');
        window.location.href = 'main.jsp';
    </script>
</head>
<body>
</body>
</html>
