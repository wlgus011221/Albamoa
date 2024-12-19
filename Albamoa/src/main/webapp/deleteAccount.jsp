<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    body {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 500px;
        margin: 0;
    }
    .container {
        text-align: center;
        padding: 20px;
    }
    input[type="text"] {
        width: 300px;
        padding: 10px;
        margin: 10px 0;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    button {
        width: 150px;
        padding: 10px;
        background-color: #FD9F28;
        border: none;
        border-radius: 5px;
        color: white;
        font-size: 16px;
        cursor: pointer;
    }
    button:hover {
        background-color: #FD991C;
    }
</style>
</head>
<body>
    <div class="container">
        <h2>회원 탈퇴</h2><br>
        <h3>탈퇴를 원하시면 아래에 본인의 아이디를 다시 적으세요.</h3> <br><br>
        <form method="post" action="deleteAccountProcess.jsp">
            <input type="text" id="id" name="id" required> <br><br>
            <button type="submit">탈퇴하기</button>
        </form>
        <br><br><br>
        회원탈퇴 시 알바토크, 등록한 게시물(이력서, 공고등)은 삭제 되지 않으므로 탈퇴 전 삭제해 주세요.
    </div>
</body>
</html>
