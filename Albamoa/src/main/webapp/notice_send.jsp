<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page import="jakarta.servlet.http.*" %>

<%
    String loggedInUserId = (String) session.getAttribute("userId");    
    int userId = 0;

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String dbUsername = "root";
    String dbPassword = "123456";
    
    String userQuery = "SELECT user_id FROM user WHERE id = ?";
    String insertQuery = "INSERT INTO JOB_POSTING (user_id, business_content, address, title, company, employment_type, person, day, day_option, week, time, salary_type, salary, salary_option, sex, age, academy, preferential, end_date, register_type, name, mail, phone, sido_address_id, sigg_address_id, emd_address_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    String businessTypeQuery = "SELECT business_id, business_detail_id FROM business_type_detail WHERE name = ?";
    String jobBusinessTypeInsertQuery = "INSERT INTO job_business_type (job_id, business_id, business_detail_id) VALUES (?, ?, ?)";
    String sidoQuery = "SELECT sido_address_id FROM sido_address WHERE name LIKE ?";
    String siggQuery = "SELECT sigg_address_id FROM sigg_address WHERE sido_address_id = ? AND name LIKE ?";
    String emdQuery = "SELECT emd_address_id FROM emd_address WHERE sido_address_id = ? AND sigg_address_id = ? AND name LIKE ?";
    
    try {
        Class.forName(jdbcDriver);
        
        try (
            Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            PreparedStatement pstmtUser = conn.prepareStatement(userQuery);
            PreparedStatement pstmtInsert = conn.prepareStatement(insertQuery, Statement.RETURN_GENERATED_KEYS);
        	PreparedStatement pstmtBusinessType = conn.prepareStatement(businessTypeQuery);
            PreparedStatement pstmtJobBusinessTypeInsert = conn.prepareStatement(jobBusinessTypeInsertQuery);
            PreparedStatement pstmtSido = conn.prepareStatement(sidoQuery);
            PreparedStatement pstmtSigg = conn.prepareStatement(siggQuery);
            PreparedStatement pstmtEmd = conn.prepareStatement(emdQuery);
        ) {
            pstmtUser.setString(1, loggedInUserId);
            try (ResultSet rs = pstmtUser.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getInt("user_id");
                } else {
                    out.println("<script>alert('유효하지 않은 사용자입니다.'); location.href='login.jsp';</script>");
                    return;
                }
            }
            
            String business = request.getParameter("business");
            String address = request.getParameter("address");
            String detailAddress = request.getParameter("detailAddress");
            String extraAddress = request.getParameter("extraAddress");
            String title = request.getParameter("title");
            String company = request.getParameter("company");
            int employmentType = Integer.parseInt(request.getParameter("employment_type"));
            String person = request.getParameter("person");
            String period = request.getParameter("period");
            String timeFlexible = request.getParameter("period_flexible");  // 근무기간 협의 가능
            String week = request.getParameter("week");
            String startTime = request.getParameter("start_time");
            String endTime = request.getParameter("end_time");
            String salaryType = request.getParameter("salary_type");
            String salary = request.getParameter("salary");
            String salaryFlexible = request.getParameter("salary_flexible");
            String sex = request.getParameter("sex");
            String age = request.getParameter("age");
            String ageMin = request.getParameter("age_min");
            String ageMax = request.getParameter("age_max");
            String scholarship = request.getParameter("scholarship");
            String endDate = request.getParameter("end-date");
            String endDateFlexible = request.getParameter("end_date_flexible");
            String reception = request.getParameter("reception_method");
            String name = request.getParameter("name");
            String contactEmail = request.getParameter("contact_email");
            String phone = request.getParameter("phone");
            String[] businessTypes = request.getParameterValues("business_types");
            String[] sweetenersArray = request.getParameterValues("sweeteners");

            // 주소에서 sido, sigg를 추출
            String[] addressParts = address.split(" ");
            String sidoName = addressParts.length > 0 ? addressParts[0] : "";
            String siggName = addressParts.length > 1 ? addressParts[1] : "";

            // extraAddress에서 emd를 추출
            String emdName = "";
			if (extraAddress != null) {
			    int startIdx = extraAddress.indexOf("(");
			    int endIdx = extraAddress.indexOf(")");
			    if (startIdx != -1 && endIdx != -1) {
			        emdName = extraAddress.substring(startIdx + 1, endIdx).trim();
			    }
			}

            // sido_address_id 조회
            int sidoAddressId = 0;
            pstmtSido.setString(1, "%" + sidoName + "%");
            try (ResultSet rs = pstmtSido.executeQuery()) {
                if (rs.next()) {
                    sidoAddressId = rs.getInt("sido_address_id");
                }
            }

            // sigg_address_id 조회
            int siggAddressId = 0;
            pstmtSigg.setInt(1, sidoAddressId);
            pstmtSigg.setString(2, "%" + siggName + "%");
            try (ResultSet rs = pstmtSigg.executeQuery()) {
                if (rs.next()) {
                    siggAddressId = rs.getInt("sigg_address_id");
                }
            }

            // emd_address_id 조회
            int emdAddressId = 0;
			pstmtEmd.setInt(1, sidoAddressId);
			pstmtEmd.setInt(2, siggAddressId);
			pstmtEmd.setString(3, "%" + emdName + "%");
			try (ResultSet rs = pstmtEmd.executeQuery()) {
			    if (rs.next()) {
			        emdAddressId = rs.getInt("emd_address_id");
			    }
			}
			
			// 디버깅을 위한 출력
			System.out.println("sidoName: " + sidoName);
			System.out.println("siggName: " + siggName);
			System.out.println("emdName: " + emdName);
            
            // 근무기간 협의가능 체크 확인
            int periodFlexible = timeFlexible != null ? 1 : 0;

            // 연령 제한 텍스트 설정
            if ("limit".equals(age)) {
                age = ageMin + "세~" + ageMax + "세 이하";
            }

            // 우대조건 배열을 콤마로 구분된 문자열로 변환
            String sweeteners = sweetenersArray != null ? String.join(", ", sweetenersArray) : "";

            pstmtInsert.setInt(1, userId); 
            pstmtInsert.setString(2, business);
            pstmtInsert.setString(3, address + ", " + detailAddress + extraAddress); 
            pstmtInsert.setString(4, title); 
            pstmtInsert.setString(5, company); 
            pstmtInsert.setInt(6, employmentType); 
            pstmtInsert.setInt(7, Integer.parseInt(person)); 
            pstmtInsert.setInt(8, Integer.parseInt(period)); 
            pstmtInsert.setInt(9, periodFlexible); 
            pstmtInsert.setInt(10, Integer.parseInt(week)); 
            pstmtInsert.setString(11, startTime + "~" + endTime); 
            pstmtInsert.setInt(12, Integer.parseInt(salaryType)); 
            pstmtInsert.setInt(13, Integer.parseInt(salary)); 
            pstmtInsert.setInt(14, salaryFlexible != null ? 1 : 0); 
            pstmtInsert.setString(15, sex); 
            pstmtInsert.setString(16, age); 
            pstmtInsert.setString(17, scholarship); 
            pstmtInsert.setString(18, sweeteners); 
            pstmtInsert.setString(19, endDateFlexible != null ? null : endDate); 
            pstmtInsert.setString(20, reception); 
            pstmtInsert.setString(21, name); 
            pstmtInsert.setString(22, contactEmail); 
            pstmtInsert.setString(23, phone);
            pstmtInsert.setInt(24, sidoAddressId);
            pstmtInsert.setInt(25, siggAddressId);
            pstmtInsert.setInt(26, emdAddressId);

            int rows = pstmtInsert.executeUpdate();

            if (rows > 0) {
                try (ResultSet generatedKeys = pstmtInsert.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int jobId = generatedKeys.getInt(1);

                        // job_business_type 테이블에 업직종 데이터 삽입
                        for (String businessTypeGroup : businessTypes) {
                            // 각 businessTypeGroup을 개별 업직종으로 분리
                            String[] individualBusinessTypes = businessTypeGroup.split(",");

                            for (String businessType : individualBusinessTypes) {
                                pstmtBusinessType.setString(1, businessType);
                                try (ResultSet rs = pstmtBusinessType.executeQuery()) {
                                    if (rs.next()) {
                                        int businessId = rs.getInt("business_id");
                                        int businessDetailId = rs.getInt("business_detail_id");

                                        pstmtJobBusinessTypeInsert.setInt(1, jobId);
                                        pstmtJobBusinessTypeInsert.setInt(2, businessId);
                                        pstmtJobBusinessTypeInsert.setInt(3, businessDetailId);
                                        pstmtJobBusinessTypeInsert.addBatch();
                                    } else {
                                        out.println("No results for businessType: " + businessType);
                                    }
                                } catch (SQLException e) {
                                    out.println("businessTypeQuery Error: " + e.getMessage());
                                }
                            }
                        }
                        pstmtJobBusinessTypeInsert.executeBatch();
                    }
                }
                out.println("<script>alert('공고 등록 되었습니다.');</script>");
                response.sendRedirect("news.jsp"); // 게시글 리스트 페이지로 리다이렉트합니다.
            } else {
                out.println("<script>alert('데이터 저장에 실패했습니다.'); history.back();</script>");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    }
%>
