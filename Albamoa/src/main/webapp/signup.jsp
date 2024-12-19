<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> 회원가입 </title>
<style>
    body, html {
        height: 100%;
        margin: 0;
        display: flex;
        justify-content: center;
        align-items: center; /* 중앙 정렬을 위해 추가 */
        background-color: #f2f2f2; /* 배경색 추가 */
    }

    .form-container {
    	position: absolute;
    	top: 0;
        width: 600px;
        padding: 20px;
        border: 1px solid #ccc;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        background-color: #fff; /* 배경색 추가 */
    }

    .form-container h2 {
        text-align: center;
    }

    .form-container input[type="text"], 
    .form-container input[type="password"], 
    .form-container select {
        width: calc(100% - 16px);
        padding: 8px;
        margin: 3px 0;
        display: inline-block;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }

    .email-container, 
    .birthdate-container, 
    .gender-container, 
    .address-container {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .email-container input[type="text"]:last-child {
        margin-right: 0;
    }

    input[type="submit"] {
        width: 48%; /* 버튼 크기 조정 */
        background-color: #FD9F28;
        color: white;
        padding: 14px 20px;
        margin: 10px 1%; /* 동일한 줄 간격을 위해 수정 */
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    input[type="submit"]:hover {
        background-color: #FD991C;
    }

    .button-container {
        display: flex;
        justify-content: space-between;
    }
    
    .cancel-button {
        width: 48%; /* 버튼 크기 조정 */
        padding: 14px 20px;
        margin: 10px 1%; /* 동일한 줄 간격을 위해 수정 */
        background-color: #808080; /* 회색으로 설정 */
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    
    .cancel-button:hover {
        background-color: #696969; /* 호버 시 더 어두운 회색 */
    }
</style>
</head>
<body onload="initializePage()">
<br><br>
	<div class="form-container">
        <form action="signupProcess.jsp" name="user_info" method="post">
            <h2> 회 원 가 입 </h2>
            아이디 <br>
            <input type="text" name="userid" required><br>
            비밀번호 <br>
            <input type="password" name="password" required><br>
            비밀번호 재확인 <br>
            <input type="password" name="confirm_password" required><br>
            이름 <br>
            <input type="text" name="name" required><br>
            닉네임 <br>
            <input type="text" name="nickname" required><br>
            전화번호 <br>
            <input type="text" name="phone" placeholder="01012341234" required><br>
            이메일 <br>
            <div class="email-container">
                <input type="text" id="emailId" name="emailId" onchange="setEmail()"> @ 
                <select id="emailDomainSelector" name="emailDomainSelector" onchange="handleDomainSelection()">
                    <option value="custom">직접 입력</option>
                    <option value="gmail.com">gmail.com</option>
                    <option value="naver.com">naver.com</option>
                    <option value="daum.net">daum.net</option>
                    <option value="nate.com">nate.com</option>
                </select>
                <input type="text" id="customDomain" name="customDomain" onchange="setEmail()">
            </div>
            <input type="hidden" id="email" name="email"><br>
            생년월일 <br>
            <div class="birthdate-container">
                <select id="birthYear" name="birthYear" onchange="setBirthdate()">
                    <option value="">년도</option>
                    <% for (int year = 2020; year >= 1970; year--) { %>
                        <option value="<%= year %>"><%= year %></option>
                    <% } %>
                </select>
                <select id="birthMonth" name="birthMonth" onchange="setBirthdate()">
                    <option value="">월</option>
                    <% for (int month = 1; month <= 12; month++) { %>
                        <option value="<%= month %>"><%= month %></option>
                    <% } %>
                </select>
                <select id="birthDay" name="birthDay" onchange="setBirthdate()">
                    <option value="">일</option>
                    <% for (int day = 1; day <= 31; day++) { %>
                        <option value="<%= day %>"><%= day %></option>
                    <% } %>
                </select>
            </div>
            <input type="hidden" id="birthdate" name="birthdate" required><br>
            성별 <br>
            <div class="gender-container">
                <label><input type="radio" name="gender" value="남" required>남성</label>
                <label><input type="radio" name="gender" value="여" required>여성</label><br>
            </div>
            <br>
            
            <label for="sido">시도:</label>
	        <select id="sido" name="sido">
	            <option value="">선택</option>
	            <%-- 시도 옵션 추가 --%>
	            <%
	                Connection conn = null;
	                PreparedStatement pstmt = null;
	                ResultSet rs = null;
	                
	                try {
	                    Class.forName("com.mysql.cj.jdbc.Driver");
	                    String url = "jdbc:mysql://localhost:3306/web_db";
	                    String username = "root";
	                    String password = "123456";
	
	                    conn = DriverManager.getConnection(url, username, password);
	                    String sql = "SELECT name FROM SIDO_ADDRESS";
	                    pstmt = conn.prepareStatement(sql);
	                    rs = pstmt.executeQuery();
	                    
	                    while (rs.next()) {
	                        %>
	                        <option value="<%=rs.getString("name")%>"><%=rs.getString("name")%></option>
	                        <%
	                    }
	                } catch (Exception e) {
	                    out.println("Error: " + e.getMessage());
	                    e.printStackTrace();
	                } finally {
	                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
	                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
	                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
	                }
	            %>
	        </select>
	        
	        <label for="sigungu">시군구:</label>
	        <select id="sigungu" name="sigungu">
	            <option value="">선택</option>
	        </select>
	        
	        <label for="dong">동읍면:</label>
	        <select id="dong" name="dong">
	            <option value="">선택</option>
	        </select>
	        
            <div class="button-container">
                <input type="button" value="취소" class="cancel-button" onclick="location.href='main.jsp'">
                <input type="submit" value="회원가입">
            </div>
            
            <br><br>
            
	    </form>
    </div>

<script>
function handleDomainSelection() {
    var emailId = document.getElementById("emailId").value;
    var emailDomainSelector = document.getElementById("emailDomainSelector").value;
    var customDomain = document.getElementById("customDomain");

    if (emailDomainSelector === "custom") {
        // 직접 입력 선택시, 도메인 필드 활성화 및 초기화
        customDomain.disabled = false;
        customDomain.value = "";
        customDomain.focus();
    } else {
        // 다른 도메인 선택시, 도메인 필드 비활성화 및 선택된 도메인으로 설정
        customDomain.value = emailDomainSelector;
        customDomain.disabled = true;
    }
	setEmail();
}

function setEmail() {
    var emailId = document.getElementById('emailId').value;
    var emailDomain = document.getElementById('customDomain').value;
    
    document.getElementById('email').value = emailId + '@' + emailDomain;
}

// 페이지 로드 시 초기화
function initializePage() {
    var customDomain = document.getElementById("customDomain");
    customDomain.disabled = false;
}

function setBirthdate() {
    var year = document.getElementById("birthYear").value;
    var month = document.getElementById("birthMonth").value;
    var day = document.getElementById("birthDay").value;
    document.getElementById("birthdate").value = year + "-" + month.padStart(2, '0') + "-" + day.padStart(2, '0');
}

function fetchOptions(url, targetId) {
    console.log('Fetching options from URL:', url);  // 디버깅 메시지 추가
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4 && xhr.status === 200) {
            console.log('Response received:', xhr.responseText);  // 디버깅 메시지 추가
            const options = JSON.parse(xhr.responseText);
            const target = document.getElementById(targetId);
            target.innerHTML = '<option value="">선택</option>';
            options.forEach(function(option) {
                const opt = document.createElement('option');
                opt.value = option.value;
                opt.text = option.text;
                target.appendChild(opt);
            });
        }
    };
    xhr.send();
}

function onSidoChange() {
    const sido = document.getElementById('sido').value;
    if (sido) {
        fetchOptions('getSigungu.jsp?sido=' + encodeURIComponent(sido), 'sigungu');
    } else {
        document.getElementById('sigungu').innerHTML = '<option value="">선택</option>';
        document.getElementById('dong').innerHTML = '<option value="">선택</option>';
    }
}

function onSigunguChange() {
    const sido = document.getElementById('sido').value;
    const sigungu = document.getElementById('sigungu').value;
    if (sido && sigungu) {
        fetchOptions('getDong.jsp?sido=' + encodeURIComponent(sido) + '&sigungu=' + encodeURIComponent(sigungu), 'dong');
    } else {
        document.getElementById('dong').innerHTML = '<option value="">선택</option>';
    }
}

window.onload = function() {
    console.log('Page loaded, setting up event listeners');
    document.getElementById('sido').addEventListener('change', onSidoChange);
    document.getElementById('sigungu').addEventListener('change', onSigunguChange);
};
</script>
</body>
</html>
