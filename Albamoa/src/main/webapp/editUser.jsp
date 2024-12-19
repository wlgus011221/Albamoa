<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .form-container {
            display: flex;
            justify-content: space-between;
            width: 80%;
            margin: 0 auto;
        }
        .form-left {
            width: 60%;
        }
        .form-right {
            width: 40%;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
        }
        .form-group input, .form-group select {
            width: 85%;
            padding: 8px;
            box-sizing: border-box;
        }
        .form-group img {
            width: 100px;
            height: 100px;
            display: block;
            margin: 0 auto;
            margin-left: 0px;
        }
        .birth-date-group, .address-group, .email-group {
            display: flex;
            gap: 10px;
        }
        .birth-date-group select, .address-group select, .email-group input, .email-group select {
            width: auto;
            padding: 8px;
            box-sizing: border-box;
        }
        .email-group input[type="text"], .email-group select {
            width: 25%;
            margin-right: 5px;
        }
        .email-group #customDomain {
            width: 25%;
        }
        .birthdate-container select {
            width: calc((100% / 3) - 30px);
        }
        .address-group select {
            width: calc((100% / 3) - 33px);
        }
        input[type="submit"] {
            width: 30%; /* 버튼 크기 조정 */
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
            justify-content: space-evenly;
        }
        .cancel-button {
            width: 30%; /* 버튼 크기 조정 */
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
        .password-group {
            display: flex;
            align-items: center;
            width: calc(100% - 40px);
        }
        .password-group input {
            flex: 1;
            width: 400px;
        }
        .password-group button {
            margin-left: 5px;
            background: none;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <%
    	String loggedInUserId = (String) session.getAttribute("userId");
        
        if (loggedInUserId == null) {
            // 로그인된 사용자가 없는 경우 로그인 페이지로 리다이렉트
            out.println("<script>alert('로그인이 필요합니다'); window.top.location.href='login.jsp';</script>");
            return;
        }

        // 데이터베이스에서 사용자 정보를 가져오기 위한 변수들
        String pw = "";
        String name = "";
        String email = "";
        String birthYear = "";
        String birthMonth = "";
        String birthDay = "";
        String gender = "";
        String phone = "";
        int sidoAddressId = 0;
        int siggAddressId = 0;
        int emdAddressId = 0;
        String nickname = "";
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/web_db";
        String dbUsername = "root";
        String dbPassword = "123456";
        
        try {
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            
            // Fetch user details
            String sql = "SELECT * FROM user WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loggedInUserId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
            	pw = rs.getString("pw");
                name = rs.getString("name");
                email = rs.getString("mail");
                String birthdate = rs.getString("birth");
                if (birthdate != null && birthdate.length() >= 10) {
                    birthYear = birthdate.substring(0, 4);
                    birthMonth = birthdate.substring(5, 7);
                    birthDay = birthdate.substring(8, 10);
                }
                gender = rs.getString("sex");
                phone = rs.getString("phone");
                sidoAddressId = rs.getInt("sido_address_id");
                siggAddressId = rs.getInt("sigg_address_id");
                emdAddressId = rs.getInt("emd_address_id");
                nickname = rs.getString("nickname");
            }
        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        }
    %>
    <form action="editUserProcess.jsp" method="post">
	    <div class="form-container">
	        <div class="form-right">
	            사진
	            <div class="form-group">
	                <img id="photoPreview" src="image/user.jpg" alt="기본이미지">
	                <input type="file" id="photo" name="photo" onchange="previewImage(event)">
	            </div>
	        </div>
	        <div class="form-left">
	            아이디
	            <div class="form-group">
	                <input type="text" id="userId" name="userId" value="<%= loggedInUserId %>" readonly>
	            </div>
	            비밀번호
	            <div class="form-group">
	                <div class="password-group">
	                    <input type="password" id="password" name="password" value="<%= pw %>">
	                    <button type="button" id="togglePwBtn" onclick="togglePasswordVisibility()">
	                        <img id="togglePwImg" src="image/eye.png" alt="보기" style="width: 20px; height: 20px;">
	                    </button>
	                </div>
	            </div>
	            이름
	            <div class="form-group">
	                <input type="text" id="name" name="name" value="<%= name %>" placeholder="이름">
	            </div>
	            닉네임
	            <div class="form-group">
	                <input type="text" id="nickname" name="nickname" value="<%= nickname %>" placeholder="닉네임">
	            </div>
	            이메일
	            <div class="form-group">
	                <div class="email-group">
	                    <input type="text" id="emailId" name="emailId" value="<%= email.split("@")[0] %>" onchange="setEmail()"> @ 
	                    <select id="emailDomainSelector" name="emailDomainSelector" onchange="handleDomainSelection()">
	                        <option value="custom">직접 입력</option>
	                        <option value="gmail.com" <%= email.endsWith("gmail.com") ? "selected" : "" %>>gmail.com</option>
	                        <option value="naver.com" <%= email.endsWith("naver.com") ? "selected" : "" %>>naver.com</option>
	                        <option value="daum.net" <%= email.endsWith("daum.net") ? "selected" : "" %>>daum.net</option>
	                        <option value="nate.com" <%= email.endsWith("nate.com") ? "selected" : "" %>>nate.com</option>
	                    </select>
	                    <input type="text" id="customDomain" name="customDomain" value="<%= email.contains("@") ? email.split("@")[1] : "" %>" onchange="setEmail()">
	                </div>
	                <input type="hidden" id="email" name="email" value="<%= email %>"><br>
	            </div>
	            생년월일
	            <div class="form-group">
	                <div class="birthdate-container">
	                    <select id="birthYear" name="birthYear" onchange="setBirthdate()">
	                        <option value="">년도</option>
	                        <% for (int year = 2020; year >= 1970; year--) { 
	                            boolean isSelected = false;
	                            try {
	                                isSelected = year == Integer.parseInt(birthYear);
	                            } catch (NumberFormatException e) {
	                                isSelected = false;
	                            }
	                        %>
	                            <option value="<%= year %>" <%= isSelected ? "selected" : "" %>><%= year %></option>
	                        <% } %>
	                    </select>
	                    <select id="birthMonth" name="birthMonth" onchange="setBirthdate()">
	                        <option value="">월</option>
	                        <% for (int month = 1; month <= 12; month++) { 
	                            boolean isSelected = false;
	                            try {
	                                isSelected = month == Integer.parseInt(birthMonth);
	                            } catch (NumberFormatException e) {
	                                isSelected = false;
	                            }
	                        %>
	                            <option value="<%= String.format("%02d", month) %>" <%= isSelected ? "selected" : "" %>><%= month %></option>
	                        <% } %>
	                    </select>
	                    <select id="birthDay" name="birthDay" onchange="setBirthdate()">
	                        <option value="">일</option>
	                        <% for (int day = 1; day <= 31; day++) { 
	                            boolean isSelected = false;
	                            try {
	                                isSelected = day == Integer.parseInt(birthDay);
	                            } catch (NumberFormatException e) {
	                                isSelected = false;
	                            }
	                        %>
	                            <option value="<%= String.format("%02d", day) %>" <%= isSelected ? "selected" : "" %>><%= day %></option>
	                        <% } %>
	                    </select>
	                </div>
	            </div>
	            <input type="hidden" id="birthdate" name="birthdate" value="<%= birthYear + "-" + birthMonth + "-" + birthDay %>" required><br>
	            성별
	            <div class="form-group">
	                <select id="gender" name="gender">
	                    <option value="남자" <%= "남자".equals(gender) ? "selected" : "" %>>남자</option>
	                    <option value="여자" <%= "여자".equals(gender) ? "selected" : "" %>>여자</option>
	                </select>
	            </div>
	            전화번호
	            <div class="form-group">
	                <input type="text" id="phone" name="phone" value="<%= phone %>" placeholder="010-0000-0000">
	            </div>
	            주소
	            <div class="form-group">
	                <div class="address-group">
	                    <select id="sido" name="sido" onchange="onSidoChange()">
	                        <option value="">시도</option>
	                        <%-- 시도 옵션 추가 --%>
	                        <%
	                        try {
	                            conn = DriverManager.getConnection(url, dbUsername, dbPassword);
	                            String sql = "SELECT sido_address_id, name FROM SIDO_ADDRESS";
	                            pstmt = conn.prepareStatement(sql);
	                            rs = pstmt.executeQuery();
	                            
	                            while (rs.next()) {
	                                String sidoName = rs.getString("name");
	                                int sidoId = rs.getInt("sido_address_id");
	                                %>
	                                <option value="<%= sidoName %>" <%= (sidoId == sidoAddressId) ? "selected" : "" %>><%= sidoName %></option>
	                                <%
	                            }
	                            rs.close();
	                            pstmt.close();
	                        } catch (Exception e) {
	                            out.println("Error: " + e.getMessage());
	                            e.printStackTrace();
	                        } finally {
	                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
	                        }
	                        %>
	                    </select>
	                    <select id="sigungu" name="sigungu" onchange="onSigunguChange()">
	                        <option value="">시군구</option>
	                        <%
	                        if (sidoAddressId > 0) {
	                            try {
	                                conn = DriverManager.getConnection(url, dbUsername, dbPassword);
	                                String sql = "SELECT sigg_address_id, name FROM SIGG_ADDRESS WHERE sido_address_id = ?";
	                                pstmt = conn.prepareStatement(sql);
	                                pstmt.setInt(1, sidoAddressId);
	                                rs = pstmt.executeQuery();
	                                
	                                while (rs.next()) {
	                                    int id = rs.getInt("sigg_address_id");
	                                    String siggName = rs.getString("name");
	                                    int siggId = rs.getInt("sigg_address_id");
	                                    %>
	                                    <option value="<%= siggName %>" <%= (siggId == siggAddressId) ? "selected" : "" %>><%= siggName %></option>
	                                    <%
	                                }
	                                rs.close();
	                                pstmt.close();
	                            } catch (Exception e) {
	                                out.println("Error: " + e.getMessage());
	                                e.printStackTrace();
	                            } finally {
	                                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
	                            }
	                        }
	                        %>
	                    </select>
	                    <select id="dong" name="dong">
	                        <option value="">동읍면</option>
	                        <%
	                        if (sidoAddressId > 0 && siggAddressId > 0) {
	                            try {
	                                conn = DriverManager.getConnection(url, dbUsername, dbPassword);
	                                String sql = "SELECT emd_address_id, name FROM EMD_ADDRESS WHERE sido_address_id = ? AND sigg_address_id = ?";
	                                pstmt = conn.prepareStatement(sql);
	                                pstmt.setInt(1, sidoAddressId);
	                                pstmt.setInt(2, siggAddressId);
	                                rs = pstmt.executeQuery();
	                                
	                                while (rs.next()) {
	                                    int emdId = rs.getInt("emd_address_id");
	                                    String emdName = rs.getString("name");
	                                    %><option value="<%= emdName %>" <%= (emdId == emdAddressId) ? "selected" : "" %>><%= emdName %></option>
	                                    <%
	                                }
	                                rs.close();
	                                pstmt.close();
	                            } catch (Exception e) {
	                                out.println("Error: " + e.getMessage());
	                                e.printStackTrace();
	                            } finally {
	                                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
	                            }
	                        }
	                        %>
	                    </select>
	                </div>
	            </div>
	            <div class="button-container">
	                <input type="reset" value="취소" class="cancel-button">
	                <input type="submit" value="수정완료">
	            </div>
	        </div>
	    </div>
	</form>

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

function setBirthdate() {
    var year = document.getElementById("birthYear").value;
    var month = document.getElementById("birthMonth").value;
    var day = document.getElementById("birthDay").value;
    document.getElementById("birthdate").value = year + "-" + month.padStart(2, '0') + "-" + day.padStart(2, '0');
}

function onSidoChange() {
    const sido = document.getElementById('sido').value;
    if (sido) {
        fetchOptions('getSigungu.jsp?sido=' + encodeURIComponent(sido), 'sigungu');
        document.getElementById('dong').innerHTML = '<option value="">읍면동</option>'; // 이 부분 추가
    } else {
        document.getElementById('sigungu').innerHTML = '<option value="">시군구</option>';
        document.getElementById('dong').innerHTML = '<option value="">읍면동</option>'; // 이 부분 추가
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

function togglePasswordVisibility() {
    var passwordField = document.getElementById('password');
    var passwordImg = document.getElementById('togglePwImg');
    if (passwordField.type === 'password') {
        passwordField.type = 'text';
        passwordImg.src = 'image/eye-crossed.png';
        passwordImg.alt = '숨기기';
    } else {
        passwordField.type = 'password';
        passwordImg.src = 'image/eye.png';
        passwordImg.alt = '보기';
    }
}

function previewImage(event) {
    var reader = new FileReader();
    reader.onload = function(){
        var output = document.getElementById('photoPreview');
        output.src = reader.result;
    };
    reader.readAsDataURL(event.target.files[0]);
}
</script>
</body>
</html>
