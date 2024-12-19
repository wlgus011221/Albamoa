<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, java.text.ParseException" %>
<%
    String job_id = request.getParameter("id");
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

    String businessContent = "";
    String address = "";
    String title = "";
    String company = "";
    String employmentType = "";
    String person = "";
    String period = "";
    String periodFlexible = "";
    String week = "";
    String time = "";
    String salaryType = "";
    String salary = "";
    String salaryFlexible = "";
    String sex = "";
    String age = "";
    String scholarship = "";
    String preferential = "";
    String endDate = "";
    String endDateFlexible = "";
    String receptionMethod = "";
    String name = "";
    String mail = "";
    String phone = "";
    String date = "";
    List<String> businessTypes = new ArrayList<>();

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        String query = "SELECT * FROM job_posting WHERE job_id = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setInt(1, Integer.parseInt(job_id));
        rs = pstmt.executeQuery();

        if (rs.next()) {
            businessContent = rs.getString("business_content");
            address = rs.getString("address");
            title = rs.getString("title");
            company = rs.getString("company");
            employmentType = rs.getString("employment_type");
            person = rs.getString("person");
            period = rs.getString("day");
            periodFlexible = rs.getString("day_option");
            week = rs.getString("week");
            time = rs.getString("time");
            salaryType = rs.getString("salary_type");
            salary = rs.getString("salary");
            salaryFlexible = rs.getString("salary_option");
            sex = rs.getString("sex");
            age = rs.getString("age");
            scholarship = rs.getString("academy");
            preferential = rs.getString("preferential");
            endDate = rs.getString("end_date");
            receptionMethod = rs.getString("register_type");
            name = rs.getString("name");
            mail = rs.getString("mail");
            phone = rs.getString("phone");
            date = rs.getString("date");
        }
        pstmt.close();
        rs.close();

        // job_business_type 테이블에서 데이터 가져오기
        String businessQuery = "SELECT * FROM job_business_type WHERE job_id = ?";
        pstmt = conn.prepareStatement(businessQuery);
        pstmt.setInt(1, Integer.parseInt(job_id));
        rs = pstmt.executeQuery();

        while (rs.next()) {
            int businessId = rs.getInt("business_id");
            int businessDetailId = rs.getInt("business_detail_id");

            String businessNameQuery = "SELECT name FROM business_type_detail WHERE business_id = ? AND business_detail_id = ?";
            try (PreparedStatement pstmtBusinessName = conn.prepareStatement(businessNameQuery)) {
                pstmtBusinessName.setInt(1, businessId);
                pstmtBusinessName.setInt(2, businessDetailId);
                try (ResultSet rsBusinessName = pstmtBusinessName.executeQuery()) {
                    if (rsBusinessName.next()) {
                        businessTypes.add(rsBusinessName.getString("name"));
                    }
                }
            }
        }
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
    
 	// 남은 기간 계산
    String remainingDays = "";
    if (endDate != null && !endDate.isEmpty()) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date end = sdf.parse(endDate);
            Date now = new Date();
            long diff = end.getTime() - now.getTime();
            long daysRemaining = diff / (1000 * 60 * 60 * 24);
            remainingDays = daysRemaining > 0 ? "마감 " + daysRemaining + "일 전" : "마감됨";
        } catch (ParseException e) {
            e.printStackTrace();
            remainingDays = "날짜 형식 오류";
        }
    } else {
        remainingDays = "상시모집";
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
        .date {
            display: flex;
            justify-content: flex-end;
            top: 20px;
            right: 20px;
            font-weight: bold;
        }
        h2, h3 {
            text-align: center;
            color: #333;
        }
        .section {
            margin-bottom: 20px;
        }
        .section-content {
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 10px;
            background-color: #fafafa;
            margin-top: 10px;
            line-height: 1.6;  /* 추가된 줄간격 설정 */
            display: flex;
            justify-content: space-between;
            flex-wrap: wrap; /* 내용이 길어질 때 줄 바꿈을 허용 */
        }
        .section-content strong {
            color: #444;
            font-weight: bold;
        }
        .highlight {
            font-weight: bold;
        }
        .remaining-days {
            color: red;
            font-weight: bold;
        }
        .map {
            width: 100%;
            height: 300px;
            background: #eee;
        }
        .hr {
            border: 0;
            height: 1px;
            background: #ddd;
            margin: 20px 0;
        }
        .flex-item {
            width: 48%; /* 좌우로 나누기 위해 각각 48% 너비로 설정 */
            margin-bottom: 10px;
        }
        .flex-item-full {
            width: 100%; /* 전체 너비를 차지하는 항목 */
            margin-bottom: 10px;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
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
        .button-scrap {
		    display: inline-block;
		    padding: 10px 20px;
		    font-size: 16px;
		    border-radius: 5px;
		    color: #fff;
		    background-color: #888; /* 스크랩 버튼 배경색을 회색으로 설정 */
		    text-align: center;
		    text-decoration: none;
		    margin: 10px 0;
		    cursor: pointer;
		    margin-left: 20px;
		}
		.button-scrap:hover {
		    background-color: #666; /* 호버 시 조금 더 어두운 회색으로 변경 */
		}
    </style>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=c04bdfdf2895354d0558305deeeaa8d5&libraries=services"></script>
    <script type="text/javascript">
	    function initializeMap() {
	        var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	            mapOption = { 
	                center: new kakao.maps.LatLng(37.5665, 126.9780), // 지도의 중심좌표 (기본값: 서울)
	                level: 3 // 지도의 확대 레벨
	            };  
	
	        var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	        // 주소-좌표 변환 객체를 생성합니다
	        var geocoder = new kakao.maps.services.Geocoder();
	
	        // 주소로 좌표를 검색합니다
	        geocoder.addressSearch('<%= address %>', function(result, status) {
	
	            // 정상적으로 검색이 완료됐으면 
	            if (status === kakao.maps.services.Status.OK) {
	
	                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	
	                // 결과값으로 받은 위치를 마커로 표시합니다
	                var marker = new kakao.maps.Marker({
	                    map: map,
	                    position: coords
	                });
	
	                // 지도의 중심을 결과값으로 받은 위치로 이동시킵니다
	                map.setCenter(coords);
	            } else {
	                // 주소를 2차 검색하여 시도 및 구 단위로 다시 검색 시도
	                var parts = '<%= address %>'.split(' ');
	                if (parts.length > 2) {
	                    var newAddress = parts[0] + ' ' + parts[1];
	                    geocoder.addressSearch(newAddress, function(result, status) {
	                        if (status === kakao.maps.services.Status.OK) {
	                            var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	                            var marker = new kakao.maps.Marker({
	                                map: map,
	                                position: coords
	                            });
	                            map.setCenter(coords);
	                        } else {
	                            alert("지도 검색에 실패했습니다. 주소를 확인해주세요.");
	                        }
	                    });
	                } else {
	                    alert("지도 검색에 실패했습니다. 주소를 확인해주세요.");
	                }
	            }
	        });    
	    }
	
	    window.onload = initializeMap;
	    
	    function openApplyPopup(jobId) {
	        window.open("applyJob.jsp?job_id=" + jobId, "지원하기", "width=800,height=600,scrollbars=yes");
	    }
    </script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="container">
        <div class="date"><%= date %></div>
        <div class="section-content">
            <div class="flex-item-full">
                <strong>공고제목</strong> <%= title %>
            </div>
            <div class="flex-item">
                <strong class="highlight">
                    <%= salaryType.equals("1") ? "시급" : "" %>
                    <%= salaryType.equals("2") ? "일급" : "" %>
                    <%= salaryType.equals("3") ? "주급" : "" %>
                    <%= salaryType.equals("4") ? "월급" : "" %>
                    <%= salaryType.equals("5") ? "연봉" : "" %>
                </strong>
                <%= salary %>
            </div>
            <div class="flex-item">
                <strong class="highlight">근무기간</strong>
                <%= period.equals("1") ? "하루(1일)" : "" %>
                <%= period.equals("2") ? "1주일이하" : "" %>
                <%= period.equals("3") ? "1주일~1개월" : "" %>
                <%= period.equals("4") ? "1개월~3개월" : "" %>
                <%= period.equals("5") ? "3개월~6개월" : "" %>
                <%= period.equals("6") ? "6개월~1년" : "" %>
                <%= period.equals("7") ? "1년이상" : "" %> <%= periodFlexible.equals("1") ? " ∙ 협의가능" : "" %>
            </div>
            <div class="flex-item">
                <strong class="highlight">근무요일</strong>
                <%= week.equals("1") ? "월~일" : "" %>
                <%= week.equals("2") ? "월~토" : "" %>
                <%= week.equals("3") ? "월~금" : "" %>
                <%= week.equals("4") ? "주말(토,일)" : "" %>
                <%= week.equals("5") ? "요일협의" : "" %>
            </div>
            <div class="flex-item">
                <strong class="highlight">근무시간</strong> <%= time.equals("null~null") ? "시간협의" : time %>
            </div>
        </div><br>
        
        <h3> 모집조건</h3>
        <div class="section-content">
            <div class="flex-item">
                <strong>모집마감</strong> <%= endDate != null ? endDate : "상시모집" %> <span class="remaining-days"><%= remainingDays %></span>
            </div>
            <div class="flex-item">
                <strong>모집인원</strong> <%= person %>명
            </div>
            <div class="flex-item">
                <strong>모집분야</strong> <%= String.join(", ", businessTypes) %>
            </div>
            <div class="flex-item">
                <strong>성별</strong> <%= sex %>
            </div>
            <div class="flex-item">
                <strong>학력</strong> <%= scholarship.equals("every") ? "학력무관" : "" %>
                <%= scholarship.equals("middle") ? "중학교 졸업" : "" %>
                <%= scholarship.equals("high") ? "고등학교 졸업" : "" %>
                <%= scholarship.equals("two-university") ? "2년제 대학 졸업" : "" %>
                <%= scholarship.equals("university") ? "4년제 대학 졸업" : "" %>
                <%= scholarship.equals("graduate") ? "대학원 졸업" : "" %>
            </div>
            <div class="flex-item">
                <strong>연령</strong> <%= age %>
            </div>
            <div class="flex-item">
                <strong>우대사항</strong> <%= preferential %>
            </div>
        </div><br>
        
        <h3> 근무지역 </h3>
        <div class="section-content">
            <%= address %><br><br>
            <div id="map" class="map"></div>
        </div><br>
        
        <h3> 근무조건 </h3>
        <div class="section-content">
            <div class="flex-item">
                <strong>급여</strong>
                <strong style="color: red;">
	                <%= salaryType.equals("1") ? "시급" : "" %>
	                <%= salaryType.equals("2") ? "일급" : "" %>
	                <%= salaryType.equals("3") ? "주급" : "" %>
	                <%= salaryType.equals("4") ? "월급" : "" %>
	                <%= salaryType.equals("5") ? "연봉" : "" %>
                </strong>
                <%= salary %>원<br>
                2024년 최저시급 9,860원
            </div>
            <div class="flex-item">
                <strong>근무기간</strong>
                <%= period.equals("1") ? "하루(1일)" : "" %>
                <%= period.equals("2") ? "1주일이하" : "" %>
                <%= period.equals("3") ? "1주일~1개월" : "" %>
                <%= period.equals("4") ? "1개월~3개월" : "" %>
                <%= period.equals("5") ? "3개월~6개월" : "" %>
                <%= period.equals("6") ? "6개월~1년" : "" %>
                <%= period.equals("7") ? "1년이상" : "" %> <%= periodFlexible.equals("1") ? " ∙ 협의가능" : "" %>
            </div>
            <div class="flex-item">
                <strong>근무요일</strong>
                <%= week.equals("1") ? "월~일" : "" %>
                <%= week.equals("2") ? "월~토" : "" %>
                <%= week.equals("3") ? "월~금" : "" %>
                <%= week.equals("4") ? "주말(토,일)" : "" %>
                <%= week.equals("5") ? "요일협의" : "" %>
            </div>
            <div class="flex-item">
                <strong>근무시간</strong> 
                <%= time.equals("null~null") ? "시간협의" : time %>
            </div>
            <div class="flex-item">
                <strong>업직종</strong> 
                <%= String.join(", ", businessTypes) %>
            </div>
            <div class="flex-item">
                <strong>고용형태</strong> 
                <%= employmentType.equals("1") ? "일반" : "" %>
                <%= employmentType.equals("2") ? "정규직" : "" %>
                <%= employmentType.equals("3") ? "계약직" : "" %>
                <%= employmentType.equals("4") ? "파견직" : "" %>
                <%= employmentType.equals("5") ? "인턴" : "" %>
            </div>
        </div><br>

        <h3> 채용담당자 연락처</h3>
        <div class="section-content">
            <div class="flex-item">
                <strong>담당자</strong> 
                <%= name %>
            </div>
            <div class="flex-item">
                <strong>연락처</strong> 
                <%= phone %>
            </div>
            <div class="flex-item">
                <strong>이메일</strong> 
                <%= mail %>
            </div>
            <div class="flex-item">
            	<strong>접수방법</strong>
            	<%= receptionMethod.equals("online") ? "온라인지원" : "" %>
	            <%= receptionMethod.equals("message") ? "간편문자지원" : "" %>
	            <%= receptionMethod.equals("email") ? "이메일지원" : "" %>
	            <%= receptionMethod.equals("phone") ? "전화연락" : "" %>
	            <%= receptionMethod.equals("visit") ? "바로방문" : "" %>
            </div>
        </div><br>
        
        <h3>회사 정보</h3> 
        <div class="section-content">
            <div class="flex-item">
                <strong> 회사명 </strong> <%= company %>
            </div>
            <div class="flex-item">
                <strong>사업내용</strong> <%= businessContent %>
            </div>
        </div><br>
    </div>
    <div class="button-container">
        <a href="scrapJobProcess.jsp?job_id=<%= job_id %>" class="button-scrap">스크랩</a>
        <% if ("online".equals(receptionMethod)) { %>
	        <a href="javascript:void(0);" class="button" onclick="openApplyPopup('<%= job_id %>')">지원하기</a>
	    <% } %>
    </div>
</body>
</html>