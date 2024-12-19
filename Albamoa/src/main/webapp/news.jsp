<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>알바모아</title>
    <style>
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 20px;
        }
        h2 {
            text-align: center;
        }
        .post-container, .search_filter {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            margin-top: 20px;
        }
        .post-header {
            font-weight: bold;
        }
        .post-link {
            text-decoration: none;
            color: black;
        }
        .post-footer {
            text-align: right;
            margin-top: 10px;
        }
        .button-container {
            display: flex;
            justify-content: flex-end;
            margin-top: 10px;
        }
        .btn {
            padding: 8px 10px;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
            color: #fff;
            background-color: #FD9F28;
            border: none;
            border-radius: 4px;
        }
        .btn:hover {
            background-color: #FD991C;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
        .remove-type {
            margin-left: 10px;
            color: red;
            cursor: pointer;
        }
        .filter_button_wrap {
            width: 100%;
        }
        .filter_button_wrap button {
            width: 50%;
        }
        .filter_button {
            background-color: #FD9F28;
            border: 1px solid #ddd;
            color: white;
            padding: 10px 24px;
            cursor: pointer;
            float: left;
        }
        .filter_button_wrap:after {
            content: "";
            clear: both;
            display: table;
        }
        .filter_button_wrap button:not(:last-child) {
            border-right: none;
        }
        .filter_button:hover {
            background-color: #FD991C;
        }
        .filter_active {
            background-color: #F18657;
        }
        .filter_content {
            padding: 20px 50px;
            border: 1px solid gray;
        }
        .filter_content a:not(:first-child) {
            margin-left: 10px;
        }
        .selected-filter {
        	border: 1px solid #ddd;
	        border-radius: 4px;
	        margin-right: 10px;
	        padding: 5px 10px;
	        display: flex;
	        align-items: center;
	    }
	    .selected-filter .remove-type {
	        margin-left: 10px;
	        color: red;
	        cursor: pointer;
	    }
    </style>
</head>
<body>
    <%
        // 데이터베이스 연결 설정
        String url = "jdbc:mysql://localhost:3306/web_db"; // 데이터베이스 URL
        String dbUsername = "root"; // 데이터베이스 사용자 이름
        String dbPassword = "123456"; // 데이터베이스 비밀번호

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<String[]> postList = new ArrayList<>();

        try {
            // JDBC 드라이버 로드
            Class.forName("com.mysql.cj.jdbc.Driver");
            // 데이터베이스 연결
            conn = DriverManager.getConnection(url, dbUsername, dbPassword);

            String query = "SELECT * FROM job_posting";
            pstmt = conn.prepareStatement(query);

            // 쿼리 실행
            rs = pstmt.executeQuery();

            while (rs.next()) {
                String[] post = new String[10];
                post[0] = rs.getString("title");
                post[1] = rs.getString("company");
                int sidoAddressId = rs.getInt("sido_address_id");
                int siggAddressId = rs.getInt("sigg_address_id");
                int emdAddressId = rs.getInt("emd_address_id");
                post[5] = rs.getString("salary");
                post[6] = rs.getString("salary_type");
                post[7] = rs.getString("time");
                post[8] = rs.getString("date");
                post[9] = rs.getString("job_id");

                // sido_address_id를 통해 name 조회
                String sidoName = "";
                String sidoQuery = "SELECT name FROM sido_address WHERE sido_address_id = ?";
                try (PreparedStatement pstmtSido = conn.prepareStatement(sidoQuery)) {
                    pstmtSido.setInt(1, sidoAddressId);
                    try (ResultSet rsSido = pstmtSido.executeQuery()) {
                        if (rsSido.next()) {
                            sidoName = rsSido.getString("name");
                        }
                    }
                }
                post[2] = sidoName != null ? sidoName : "";

                // sigg_address_id를 통해 name 조회
                String siggName = "";
                String siggQuery = "SELECT name FROM sigg_address WHERE sido_address_id = ? AND sigg_address_id = ?";
                try (PreparedStatement pstmtSigg = conn.prepareStatement(siggQuery)) {
                    pstmtSigg.setInt(1, sidoAddressId);
                    pstmtSigg.setInt(2, siggAddressId);
                    try (ResultSet rsSigg = pstmtSigg.executeQuery()) {
                        if (rsSigg.next()) {
                            siggName = rsSigg.getString("name");
                        }
                    }
                }
                post[3] = siggName != null ? siggName : "";

                // emd_address_id를 통해 name 조회
                String emdName = "";
                String emdQuery = "SELECT name FROM emd_address WHERE sido_address_id = ? AND sigg_address_id = ? AND emd_address_id = ?";
                try (PreparedStatement pstmtEmd = conn.prepareStatement(emdQuery)) {
                    pstmtEmd.setInt(1, sidoAddressId);
                    pstmtEmd.setInt(2, siggAddressId);
                    pstmtEmd.setInt(3, emdAddressId);
                    try (ResultSet rsEmd = pstmtEmd.executeQuery()) {
                        if (rsEmd.next()) {
                            emdName = rsEmd.getString("name");
                        }
                    }
                }
                post[4] = emdName != null ? emdName : "";

                // 급여 유형 변환
                switch (post[6]) {
                    case "1":
                        post[6] = "시급";
                        break;
                    case "2":
                        post[6] = "일급";
                        break;
                    case "3":
                        post[6] = "주급";
                        break;
                    case "4":
                        post[6] = "월급";
                        break;
                    case "5":
                        post[6] = "연봉";
                        break;
                }

                if(post[7].equals("null~null")){
                    post[7] = "시간협의";
                }

                postList.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
    <jsp:include page="navbar.jsp" />
    <br>
    <h2>공고 목록</h2>
    <br>
    
    <div class="search_filter">
        <div class="filter_button_wrap">
            <button class="filter_button filter_active" id="filter_button_a">지역</button>
            <button class="filter_button" id="filter_button_b">업직종</button>
<!--             <button class="filter_button" id="filter_button_c">근무기간</button>
            <button class="filter_button" id="filter_button_d">상세조건</button> -->
        </div>
        <div class="filter_content filter_a">
		    <label for="sido">시도</label>
	        <select id="sido" name="sido">
	            <option value="">선택</option>
	            <%-- 시도 옵션 추가 --%>
	            <%
	                try {
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
	                }
	            %>
	        </select>
	        
	        <label for="sigungu">시군구</label>
	        <select id="sigungu" name="sigungu">
	            <option value="">선택</option>
	        </select>
	        
	        <label for="dong">동읍면</label>
	        <select id="dong" name="dong">
	            <option value="">선택</option>
	        </select>
	        <button type="button" id="addButton">추가</button>
		</div>
		
        <div class="filter_content filter_b">
            <label for="business_type">대분류</label>
	        <select id="business_type" name="business_type">
	            <option value="">선택</option>
	            <%
	                try {
	                    String sql = "SELECT name FROM business_type";
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
	                }
	            %>
	        </select>
	        
	        <label for="business_type_detail">업직종</label>
			<select id="business_type_detail" name="business_type_detail">
			    <option value="">전체</option>
			</select>
	        
	        <button type="button" id="addBusinessButton">추가</button>
        </div>
        
<!--         <div class="filter_content filter_c">
            <a>주말</a>
            <a>테스트용2</a>
            <a>테스트용3</a>
            <a>테스트용4</a>
            <a>테스트용5</a>
            <a>테스트용6</a>
        </div>    
        <div class="filter_content filter_d">
            <a>성별</a>
            <a>테스트용2</a>
            <a>테스트용3</a>
            <a>테스트용4</a>
            <a>테스트용5</a>
            <a>테스트용6</a>
        </div> -->

        <form id="filter_form" action="search.jsp" method="get">
            <div id="selected-filter" class="selected-filter" style="margin-top: 10px; display: flex; flex-wrap: wrap;"></div>
            <div class="button-container">
                <button type="submit" class="btn">검색</button>
            </div>
            <input type="hidden" id="filters" name="filters">
        </form>
    </div>

    <div class="container">
        <table>
            <thead>
                <tr>
                    <th>지역</th>
                    <th>모집제목<br>기업명</th>
                    <th>급여(원)</th>
                    <th>근무시간</th>
                    <th>등록일</th>
                </tr>
            </thead>
            <tbody>
            <%
                if (!postList.isEmpty()) {
                    for (String[] post : postList) {
            %>
                <tr onclick="location.href='noticeDetail.jsp?id=<%= post[9] %>'">
                    <td><%= post[2] %> <%= post[3] %> <%= post[4] %></td>
                    <td><%= post[0] %><br><%= post[1] %></td>
                    <td><%= post[5] %>원 <%= post[6] %></td>
                    <td><%= post[7] %></td>
                    <td><%= post[8] %></td>
                </tr>
            <%
                    }
                } else {
            %>
                <tr>
                    <td colspan="5">공고가 없습니다.</td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
   	<script>
   	document.addEventListener('DOMContentLoaded', function() {
        const buttonA = document.getElementById('filter_button_a');
        const buttonB = document.getElementById('filter_button_b');
        const buttonC = document.getElementById('filter_button_c');
        const buttonD = document.getElementById('filter_button_d');

        // 초기 상태에서 필터 A만 보이도록 설정
        document.querySelector(".filter_a").style.display = "block";
        document.querySelector(".filter_b").style.display = "none";
/*         document.querySelector(".filter_c").style.display = "none";
        document.querySelector(".filter_d").style.display = "none"; */

        buttonA.addEventListener('click', function() {
            document.querySelector(".filter_b").style.display = "none";
/*             document.querySelector(".filter_c").style.display = "none";
            document.querySelector(".filter_d").style.display = "none"; */
            document.querySelector(".filter_a").style.display = "block";        
            buttonA.classList.add("filter_active");
            buttonB.classList.remove("filter_active");
/*             buttonC.classList.remove("filter_active");
            buttonD.classList.remove("filter_active"); */
        });

        buttonB.addEventListener('click', function() {
            document.querySelector(".filter_a").style.display = "none";
/*             document.querySelector(".filter_c").style.display = "none";
            document.querySelector(".filter_d").style.display = "none"; */
            document.querySelector(".filter_b").style.display = "block";    
            buttonB.classList.add("filter_active");
            buttonA.classList.remove("filter_active");
/*             buttonC.classList.remove("filter_active");
            buttonD.classList.remove("filter_active"); */
        });

/*         buttonC.addEventListener('click', function() {
            document.querySelector(".filter_a").style.display = "none";
            document.querySelector(".filter_b").style.display = "none";
            document.querySelector(".filter_d").style.display = "none";
            document.querySelector(".filter_c").style.display = "block";    
            buttonC.classList.add("filter_active");
            buttonA.classList.remove("filter_active");
            buttonB.classList.remove("filter_active");
            buttonD.classList.remove("filter_active");
        });

        buttonD.addEventListener('click', function() {
            document.querySelector(".filter_a").style.display = "none";
            document.querySelector(".filter_b").style.display = "none";
            document.querySelector(".filter_c").style.display = "none";
            document.querySelector(".filter_d").style.display = "block";    
            buttonD.classList.add("filter_active");
            buttonA.classList.remove("filter_active");
            buttonB.classList.remove("filter_active");
            buttonC.classList.remove("filter_active");
        }); */
		
        document.getElementById('addButton').addEventListener('click', function() {
            const sido = document.getElementById('sido').options[document.getElementById('sido').selectedIndex].text;
            const sigungu = document.getElementById('sigungu').options[document.getElementById('sigungu').selectedIndex].text;
            const dong = document.getElementById('dong').options[document.getElementById('dong').selectedIndex].text;

            const selectedText = [sido, sigungu, dong].filter(Boolean).join(' ');
            if (!selectedText) return;

            if (isFilterAlreadySelected(selectedText)) return;

            addFilter(selectedText);
            updateSelectedTypes();
        });

        document.getElementById('addBusinessButton').addEventListener('click', function() {
            const businessType = document.getElementById('business_type').options[document.getElementById('business_type').selectedIndex].text;
            const businessDetailType = document.getElementById('business_type_detail').options[document.getElementById('business_type_detail').selectedIndex].text;

            const selectedText = [businessType, businessDetailType].filter(Boolean).join(' ');
            if (!selectedText) return;

            if (isFilterAlreadySelected(selectedText)) return;

            addFilter(selectedText);
            updateSelectedTypes();
        });

        function isFilterAlreadySelected(filterText) {
            const selectedTexts = Array.from(document.querySelectorAll('.selected-filter .filter-text'))
                .map(el => el.textContent.trim());
            return selectedTexts.includes(filterText);
        }

        function addFilter(filterText) {
            const selectedContainer = document.getElementById('selected-filter');

            const span = document.createElement('span');
            span.classList.add('selected-filter');

            const textNode = document.createElement('span');
            textNode.classList.add('filter-text');
            textNode.textContent = filterText;

            const removeBtn = document.createElement('span');
            removeBtn.classList.add('remove-type');
            removeBtn.textContent = ' x';
            removeBtn.addEventListener('click', function() {
                span.remove();
                updateSelectedTypes();
            });

            span.appendChild(textNode);
            span.appendChild(removeBtn);
            selectedContainer.appendChild(span);
        }

        function updateSelectedTypes() {
            const selectedTexts = Array.from(document.querySelectorAll('.selected-filter .filter-text'))
                .map(el => el.textContent.trim())
                .filter(Boolean);
            document.getElementById('filters').value = selectedTexts.join(',');
        }

        document.getElementById('business_type').addEventListener('change', function() {
            const businessType = this.value;
            if (businessType) {
                fetchOptions('getBusinessName.jsp?businessType=' + encodeURIComponent(businessType), 'business_type_detail');
            } else {
                document.getElementById('business_type_detail').innerHTML = '<option value="">전체</option>';
            }
        });
    });
   	
   	function fetchOptions(url, targetId) {
   	    console.log('Fetching options from URL:', url);  // 디버깅 메시지 추가
   	    const xhr = new XMLHttpRequest();
   	    xhr.open('GET', url, true);
   	    xhr.onreadystatechange = function() {
   	        if (xhr.readyState === 4 && xhr.status === 200) {
   	            console.log('Response received:', xhr.responseText);  // 디버깅 메시지 추가
   	            const options = JSON.parse(xhr.responseText);
   	            const target = document.getElementById(targetId);
   	            target.innerHTML = '<option value="">전체</option>';
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
   	        document.getElementById('sigungu').innerHTML = '<option value="">전체</option>';
   	        document.getElementById('dong').innerHTML = '<option value="">전체</option>';
   	    }
   	}

   	function onSigunguChange() {
   	    const sido = document.getElementById('sido').value;
   	    const sigungu = document.getElementById('sigungu').value;
   	    if (sido && sigungu) {
   	        fetchOptions('getDong.jsp?sido=' + encodeURIComponent(sido) + '&sigungu=' + encodeURIComponent(sigungu), 'dong');
   	    } else {
   	        document.getElementById('dong').innerHTML = '<option value="">전체</option>';
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
