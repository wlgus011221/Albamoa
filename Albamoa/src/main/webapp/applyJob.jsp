<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.text.ParseException" %>
<%
    String job_id = request.getParameter("job_id");
	String loggedInUserId = (String) session.getAttribute("userId");
	
    if (job_id == null || job_id.isEmpty()) {
        out.println("<script>alert('유효하지 않은 공고 ID입니다.'); history.back();</script>");
        return;
    }

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String title = "";
    String company = "";
    String name = "";
    String gender = "";
    String birthYear = "";
    String address = "";
    int sidoId = 0;
    int siggId = 0;
    int emdId = 0;
    String phone = "";
    String email = "";
    int userId = 0;
    
    List<String> resumeList = new ArrayList<>(); // 이력서 목록을 저장할 리스트

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        String query = "SELECT title, company FROM job_posting WHERE job_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, Integer.parseInt(job_id));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            company = rs.getString("company");
        }
        pstmt.close();
        rs.close();

        query = "SELECT user_id, name, sex, birth, sido_address_id, sigg_address_id, emd_address_id, phone, mail FROM user WHERE id = ?";
        pstmt = conn.prepareStatement(query);
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
            sidoId = rs.getInt("sido_address_id");
            siggId = rs.getInt("sigg_address_id");
            emdId = rs.getInt("emd_address_id");
            userId = rs.getInt("user_id"); // user_id 저장
        }
        rs.close();
        pstmt.close();
        
        String sidoName = "";
        if (sidoId != 0) {
        	query = "SELECT name FROM sido_address WHERE sido_address_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, sidoId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                sidoName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }

        // 시군구 주소 조회
        String siggName = "";
        if (siggId != 0) {
        	query = "SELECT name FROM sigg_address WHERE sido_address_id = ? AND sigg_address_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, sidoId);
            pstmt.setInt(2, siggId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                siggName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }

        // 읍면동 주소 조회
        String emdName = "";
        if (emdId != 0) {
        	query = "SELECT name FROM emd_address WHERE sido_address_id = ? AND sigg_address_id = ? AND emd_address_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, sidoId);
            pstmt.setInt(2, siggId);
            pstmt.setInt(3, emdId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                emdName = rs.getString("name");
            }
            rs.close();
            pstmt.close();
        }
        address = sidoName + " " + siggName + " " + emdName;
        
     	// 이력서 목록 조회
        query = "SELECT resume_id, title FROM resume WHERE user_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, userId);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            int resumeId = rs.getInt("resume_id");
            String resumeTitle = rs.getString("title");
            resumeList.add(resumeId + ": " + resumeTitle); // 이력서 목록에 추가
        }
        rs.close();
        pstmt.close();
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('SQL 오류가 발생했습니다. 관리자에게 문의해주세요. 오류 메시지: " + e.getMessage() + "'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요. 오류 메시지: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
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
            border-radius: 10px;
            margin-top: 20px;
        }
        h1 {
            color: #333;
            text-align: center;
        }
        h3 {
            color: #444;
            margin-top: 20px;
            margin-bottom: 10px;
        }
        .container input[type="text"],
        .container select,
        .container textarea {
            width: calc(100% - 30px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 10px;
        }
        .select-button-group {
            display: flex;
            align-items: center;
        }
        .select-button-group select {
            flex: 1;
            margin-right: 10px;
        }
        .hr {
            border: 0;
            height: 1px;
            background: #ddd;
            margin: 20px 0;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
        .resumeDetailButton {
	        display: inline-block;
	        padding: 10px;
	        font-size: 10px;
	        border-radius: 5px;
	        color: #fff;
	        background-color: #888; /* 회색 배경색 설정 */
	        text-align: center;
	        text-decoration: none;
	        margin: 10px 0;
	        cursor: pointer;
	        margin-left: 20px;
	    }
	    .resumeDetailButton:hover {
	        background-color: #666; /* 호버 시 더 어두운 회색으로 변경 */
	    }
	    .button {
	        display: inline-block;
	        padding: 10px 20px;
	        font-size: 16px;
	        border-radius: 5px;
	        color: #fff;
	        background-color: #FD9F28;
	        text-align: center;
	        text-decoration: none;
	        margin: 10px 0;
	        cursor: pointer;
	        margin-left: 20px;
	    }
	    .button:hover {
	        background-color: #FD991C;
	    }
    </style>
</head>
<body>
    <div class="container">
        <h1>온라인 지원</h1>
        <hr>
        <h3>지원회사 확인</h3>
        <strong>근무회사명</strong> <%= company %> <br>
        <strong>공고제목</strong> <%= title %> <br><br>
        <form action="applyJobProcess.jsp" method="post">
            <h3>지원내용</h3>
            <strong>이력서선택</strong>
            <div class="select-button-group">
                <select name="resume_id" id="resume_id" onchange="updateHiddenResumeId()">
                    <% for (String resume : resumeList) { %>
                        <option value="<%= resume.split(":")[0] %>"><%= resume.split(":")[1] %></option>
                    <% } %>
                </select>
                <a href="javascript:void(0);" class="resumeDetailButton" onclick="openResumePopup()">보기 및 수정</a>
            </div>
            <strong>지원제목</strong><br>
            <input type="text" name="job_title" id="job_title"><br>
            <strong>전달메시지</strong><br>
            <textarea id="job_message" name="job_message" rows="5"></textarea>
            <h3>지원정보 확인</h3>
            <strong><%= name %></strong> (<%= gender %>, <%= birthYear %> / <%= address %>)<br>
            <strong>휴대폰</strong> <%= phone %><br>
            <strong>이메일</strong> <%= email %><br>
            <input type="hidden" name="job_id" value="<%= job_id %>">
            <input type="hidden" name="user_id" value="<%= loggedInUserId %>">
            <input type="hidden" name="resume_id_hidden" id="resume_id_hidden" value="<%= resumeList.isEmpty() ? "" : resumeList.get(0).split(":")[0] %>">
            <div class="button-container">
                <button type="submit" class="button">지원</button>
            </div>
        </form>
    </div>
    <script>
    function openResumePopup() {
        var resumeId = document.getElementById('resume_id').value;
        window.open("resumeDetail.jsp?resume_id=" + resumeId, "이력서 보기 및 수정", "width=800,height=600,scrollbars=yes");
    }
    
    function updateHiddenResumeId() {
        var resumeId = document.getElementById('resume_id').value;
        document.getElementById('resume_id_hidden').value = resumeId;
    }
    </script>
</body>
</html>