<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String resumeId = request.getParameter("resume_id");

    if (resumeId == null) {
    	out.println("<script>alert('유효하지 않은 게시글입니다.'); history.back();</script>");
        return;
    }
    
	String loggedInUserId = (String) session.getAttribute("userId");
	
	if (loggedInUserId == null) {
	    // 로그인된 사용자가 없는 경우 로그인 페이지로 리다이렉트
	    out.println("<script>alert('로그인이 필요합니다'); window.top.location.href='login.jsp';</script>");
	    return;
	}
	
    String name = "";
	String email = "";
	String birthYear = "";
	String gender = "";
	String phone = "";
	String address = "";
	int sidoAddress = 0;
	int siggAddress = 0;
	int emdAddress = 0;
	
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

    String title = "";
    String academy = "";
    String career = "";
    String company_name = "";
    String start_date = "";
    String end_date = "";
    String business = "";
    String info = "";

    try {
    	Class.forName("com.mysql.cj.jdbc.Driver");
    	String url = "jdbc:mysql://localhost:3306/web_db";
    	String dbUsername = "root";
    	String dbPassword = "123456";
    	conn = DriverManager.getConnection(url, dbUsername, dbPassword);
        
        String sql = "SELECT * FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loggedInUserId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            name = rs.getString("name");
            email = rs.getString("mail");
            String birthdate = rs.getString("birth");
            if (birthdate != null && birthdate.length() >= 10) {
                birthYear = birthdate.substring(0, 4);
            }
            gender = rs.getString("sex");
            phone = rs.getString("phone").substring(0,3) + "-" + rs.getString("phone").substring(3,7) + "-" + rs.getString("phone").substring(7,11);
            sidoAddress = rs.getInt("sido_address_id");
            siggAddress = rs.getInt("sigg_address_id");
            emdAddress = rs.getInt("emd_address_id");
        }
        rs.close();
        pstmt.close();
        
        String sidoName = "";
        if (sidoAddress != 0) {
            sql = "SELECT name FROM sido_address WHERE sido_address_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sidoAddress);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                sidoName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }

        // 시군구 주소 조회
        String siggName = "";
        if (siggAddress != 0) {
            sql = "SELECT name FROM sigg_address WHERE sido_address_id = ? AND sigg_address_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sidoAddress);
            pstmt.setInt(2, siggAddress);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                siggName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }

        // 읍면동 주소 조회
        String emdName = "";
        if (emdAddress != 0) {
            sql = "SELECT name FROM emd_address WHERE sido_address_id = ? AND sigg_address_id = ? AND emd_address_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, sidoAddress);
            pstmt.setInt(2, siggAddress);
            pstmt.setInt(3, emdAddress);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                emdName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }
        address = sidoName + " " + siggName + " " + emdName;
        
        String selectQuery = "SELECT title, academy, career, company_name, start_date, end_date, business, info FROM resume WHERE resume_id = ?";
        pstmt = conn.prepareStatement(selectQuery);  // 새로운 PreparedStatement 객체 생성
        pstmt.setInt(1, Integer.parseInt(resumeId));
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            title = rs.getString("title");
            academy = rs.getString("academy");
            career = rs.getString("career");
            company_name = rs.getString("company_name");
            start_date = rs.getString("start_date");
            end_date = rs.getString("end_date");
            business = rs.getString("business");
            info = rs.getString("info");
        } else {
            out.println("<script>alert('유효하지 않은 게시글입니다.'); location.href='myPage.jsp';</script>");
            return;
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } finally {
	    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
	    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
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
        width: 80%;
        margin: auto;
        background: #fff;
        padding: 20px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        margin-top: 20px;
        position: relative;
    }
    .section-content {
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 10px;
        background-color: #fafafa;
        margin-top: 10px;
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
    }
    .left-content, .middle-content, .right-content {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }
    .left-content {
        flex: 0 0 100px;
        margin-right: 20px;
    }
    .middle-content, .right-content {
        flex: 1;
    }
    .section-content img {
        width: 100px;
        height: 100px;
        border: 1px solid #ddd;
    }
    .info-item {
        display: flex;
        gap: 10px;
        margin-top: 15px;
    }
    .info-item strong {
        min-width: 10px; /* 최소 너비 설정 */
        color: #444;
        font-weight: bold;
    }
    .info-item span {
        color: #555;
    }
    .edit-button {
        position: absolute;
        margin-top: 13px;
        right: 20px;
        padding: 5px 10px;
        border-radius: 5px;
        text-decoration: none;
        color: #333;
        font-weight: bold;
        cursor: pointer;
    }
    .edit-button:hover {
        background-color: #e4e4e4;
    }
    input, select, textarea {
        width: 100%;
        padding: 10px;
        box-sizing: border-box;
        margin-tip: 10px;
    }
    .toggle-buttons {
        display: flex;
        gap: 10px;
        margin-top: 20px;
    }
    .toggle-button {
        flex: 1;
        padding: 10px;
        text-align: center;
        cursor: pointer;
        border: 1px solid #ccc;
        border-radius: 5px;
        background-color: #f4f4f4;
    }
    .toggle-button.active {
        background-color: #FD9F28;
    }
    .employment-details {
        display: none;
    }
    .button-container {
        display: flex;
        justify-content: center; /* 가운데 정렬 */
        margin-top: 20px;
    }
    button {
		background-color: #FD9F28;
		color: #fff;
	    padding: 10px 20px;
		border: none;
		border-radius: 4px;
		cursor: not-allowed; /* 수정 불가능하도록 커서를 변경 */
		font-size: 16px;
	}
		
	button:hover {
	    background-color: #FD991C;
	}
</style>
<script>
function initializeForm() {
    var career = "<%= career %>";
    if (career == "1") {
        toggleEmploymentDetails(true);
    } else {
        toggleEmploymentDetails(false);
    }
}

function toggleEmploymentDetails(isExperienced) {
    var details = document.getElementById('employment-details');
    var newButton = document.getElementById('new-button');
    var experiencedButton = document.getElementById('experienced-button');
    var experienceType = document.getElementById('experience_type');

    if (isExperienced) {
        details.style.display = 'block';
        experiencedButton.classList.add('active');
        newButton.classList.remove('active');
        experienceType.value = '1'; // 경력
    } else {
        details.style.display = 'none';
        newButton.classList.add('active');
        experiencedButton.classList.remove('active');
        experienceType.value = '0'; // 신입
    }
}

function calculateExperience() {
    var workStart = document.getElementById('start_date').value;
    var workEnd = document.getElementById('end_date').value;

    if (workStart && workEnd) {
        var startDate = new Date(workStart);
        var endDate = new Date(workEnd);

        if (endDate >= startDate) {
            var timeDiff = endDate - startDate;
            var daysDiff = timeDiff / (1000 * 3600 * 24);
            document.getElementById('experience-days').innerText = Math.floor(daysDiff);
        } else {
            document.getElementById('experience-days').innerText = "0";
        }
    } else {
        document.getElementById('experience-days').innerText = "0";
    }
}
</script>
</head>
<body onload="initializeForm()">
    <h2 style="text-align: center; color: #333; margin-top: 20px;">이력서 보기</h2>
    <div class="container">
        <div class="section-content">
            <div class="left-content">
                <img id="photoPreview" src="image/user.jpg" alt="기본이미지">
            </div>
            <div class="middle-content">
                <div class="info-item">
                    <strong>이름:</strong> <span><%= name %></span> ∙ <span><%= gender %></span> / <span><%= birthYear %>년생</span>
                </div>
                <div class="info-item">
                    <strong>주소:</strong> <span><%= address %></span>
                </div>
            </div>
            <div class="right-content">
                <div class="info-item">
                    <strong>전화번호:</strong> <span><%= phone %></span>
                </div>
                <div class="info-item">
                    <strong>이메일:</strong> <span><%= email %></span>
                </div>
            </div>
        </div>
		<br>
		<form>
			<input type="hidden" id="experience_type" name="experience_type" value="0">
            <label for="title">이력서 제목</label><br><br>
            <textarea id="title" name="title" rows="1" readonly><%= title %></textarea><br><br>
            <strong>학력사항</strong><br><br>
            <label for="education">최종학력</label>
            <select id="education" name="education" disabled>
            	<option value="middle" <%= academy.equals("middle") ? "selected" : "" %>>중학교 졸업</option>
                <option value="high" <%= academy.equals("middle") ? "selected" : "" %>>고등학교 졸업</option>
                <option value="two-university" <%= academy.equals("middle") ? "selected" : "" %>>2년제 대학 졸업</option>
                <option value="university" <%= academy.equals("middle") ? "selected" : "" %>>4년제 대학 졸업</option>
                <option value="graduate" <%= academy.equals("middle") ? "selected" : "" %>>대학원 졸업</option>
            </select><br><br>
            <strong>경력사항</strong>
            <div class="toggle-buttons">
                <div id="new-button" class="toggle-button">신입</div>
				<div id="experienced-button" class="toggle-button">경력</div>
            </div>
            <div id="employment-details" class="employment-details">
                <label for="my-experience">나의 경력: <span id="experience-days">0</span>일</label><br><br>
                <label for="company-name">회사명</label><br>
                <input type="text" id="company_name" name="company_name" value="<%= company_name %>" readonly><br><br>
                <label for="work-period">근무기간</label><br>
                <div>
			        <label for="work-start">입사일</label>
			        <input type="date" id="start_date" name="start_date" value="<%= start_date %>" onchange="calculateExperience()" readonly>
			        <label for="work-end">퇴사일</label>
			        <input type="date" id="end_date" name="end_date" value="<%= end_date %>" onchange="calculateExperience()" readonly>
			    </div>
                <br>
                <label for="job-description">담당업무</label><br>
                <textarea id="job-description" name="business" rows="4" readonly><%= business %></textarea><br><br>
            </div><br><br>
		    <label for="self-introduction">자기소개</label>
		    <textarea id="self-introduction" name="info" rows="5" readonly><%= info %></textarea>
		    <br>
        </form>
    </div>
</body>
</html>