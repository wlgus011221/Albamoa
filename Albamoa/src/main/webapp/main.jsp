<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알바모아</title>
<style>
    body {
        margin: 0;
        font-family: Arial, sans-serif;
    }
    
    .content {
        padding: 20px;
    }
    
    .region-container {
        display: flex;
        flex-wrap: wrap;
    }
    
    .region {
        flex-basis: calc(100% / 6);
        cursor: pointer;
        padding: 1px 0;
        text-align: center;
    }
    
    .board-list {
        margin-top: 20px;
        display: flex;
        flex-wrap: wrap;
        justify-content: flex-start;
    }
    
    .board-item {
        flex-basis: calc(100% / 6); /* 기존 4에서 6으로 변경 */
    	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    	margin: 5px; /* 기존 10px에서 5px로 조정 */
    	padding: 4px; /* 기존 6px에서 4px로 조정 */
    	text-align: center;
    	cursor: pointer;
    	transition: transform 0.2s;
    }
    
    .board-item:hover {
        transform: scale(1.05);
    }
</style>
<script>
function searchByRegion(region) {
    window.location.href = 'search.jsp?query=' + region;
}
</script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="content">
        <fieldset style="width:240px;">
            <legend> 지역 </legend>
            <div class="region-container">
                <p class="region" onclick="searchByRegion('서울')">서울</p>
                <p class="region" onclick="searchByRegion('경기')">경기</p>
                <p class="region" onclick="searchByRegion('인천')">인천</p>
                <p class="region" onclick="searchByRegion('강원')">강원</p>
                <p class="region" onclick="searchByRegion('대전')">대전</p>
                <p class="region" onclick="searchByRegion('세종')">세종</p>
                <p class="region" onclick="searchByRegion('충남')">충남</p>
                <p class="region" onclick="searchByRegion('충북')">충북</p>
                <p class="region" onclick="searchByRegion('부산')">부산</p>
                <p class="region" onclick="searchByRegion('울산')">울산</p>
                <p class="region" onclick="searchByRegion('경남')">경남</p>
                <p class="region" onclick="searchByRegion('경북')">경북</p>
                <p class="region" onclick="searchByRegion('대구')">대구</p>
                <p class="region" onclick="searchByRegion('광주')">광주</p>
                <p class="region" onclick="searchByRegion('전남')">전남</p>
                <p class="region" onclick="searchByRegion('전북')">전북</p>
                <p class="region" onclick="searchByRegion('제주')">제주</p>
                <p class="region" onclick="searchByRegion('')">전국</p>
            </div>
        </fieldset>
        <hr>
        <h2> 실시간 공고 </h2>
        <div class="board-list">
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    // 데이터베이스 연결
                    String url = "jdbc:mysql://localhost:3306/web_db";
                    String dbUsername = "root";
                    String dbPassword = "123456";
                    conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                    
                    // SQL 쿼리 실행
                    String sql = "SELECT * FROM job_posting ORDER BY date DESC LIMIT 5";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    
                    // 결과 출력
                    while (rs.next()) {
                        String id = rs.getString("job_id");
                        String title = rs.getString("title");
                        String company = rs.getString("company");
                        String salary = rs.getString("salary");
                        String salary_type = rs.getString("salary_type");
                        
                     // 급여 유형 변환
        	            switch (salary_type) {
        	                case "1":
        	                	salary_type = "시급";
        	                    break;
        	                case "2":
        	                	salary_type = "일급";
        	                    break;
        	                case "3":
        	                	salary_type = "주급";
        	                    break;
        	                case "4":
        	                	salary_type = "월급";
        	                    break;
        	                case "5":
        	                	salary_type = "연봉";
        	                    break;
        	            }
                        %>
                        <div class="board-item" onclick="location.href='noticeDetail.jsp?id=<%= id %>'">
                            <h4><%= title %></h4>
                            <p><%= company %></p>
                            <%= salary_type %> ∙ <%= salary %>
                        </div>
                        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // 리소스 해제
                    if (rs != null) try { rs.close(); } catch(SQLException ex) {}
                    if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
                    if (conn != null) try { conn.close(); } catch(SQLException ex) {}
                }
            %>
        </div>
        <hr>
        <h2> 실시간 게시글 </h2>
        <div class="board-list">
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    // 데이터베이스 연결
                    String url = "jdbc:mysql://localhost:3306/web_db";
                    String dbUsername = "root";
                    String dbPassword = "123456";
                    conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                    
                    // SQL 쿼리 실행
                    String sql = "SELECT * FROM talk_post ORDER BY date DESC LIMIT 5";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    
                    // 결과 출력
                    while (rs.next()) {
                        String id = rs.getString("board_id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        // 필요한 다른 컬럼들 가져오기
                        %>
                        <div class="board-item" onclick="location.href='talkDetail.jsp?board_id=<%= id %>'">
                            <h3><%= title %></h3>
                            <p><%= content %></p>
                            <!-- 다른 게시판 정보 출력 -->
                        </div>
                        <%
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // 리소스 해제
                    if (rs != null) try { rs.close(); } catch(SQLException ex) {}
                    if (pstmt != null) try { pstmt.close(); } catch(SQLException ex) {}
                    if (conn != null) try { conn.close(); } catch(SQLException ex) {}
                }
            %>
        </div>
    </div>
</body>
</html>
