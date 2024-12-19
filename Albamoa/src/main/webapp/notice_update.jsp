<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String jobId = request.getParameter("id");
    String business = request.getParameter("business");
    String address = request.getParameter("address");
    String detailAddress = request.getParameter("detailAddress");
    String extraAddress = request.getParameter("extraAddress");
    String title = request.getParameter("title");
    String company = request.getParameter("company");
    String employmentType = request.getParameter("employment_type");
    String person = request.getParameter("person");
    String period = request.getParameter("period");
    String periodFlexible = request.getParameter("period_flexible") != null ? "1" : "0";
    String week = request.getParameter("week");
    String startTime = request.getParameter("start_time");
    String endTime = request.getParameter("end_time");
    String timeFlexible = request.getParameter("time_flexible") != null ? "1" : "0";
    String salaryType = request.getParameter("salary_type");
    String salary = request.getParameter("salary");
    String salaryFlexible = request.getParameter("salary_flexible") != null ? "1" : "0";
    String sex = request.getParameter("sex");
    String age = request.getParameter("age");
    String ageMin = request.getParameter("age_min");
    String ageMax = request.getParameter("age_max");
    String scholarship = request.getParameter("scholarship");
    String[] preferentialArr = request.getParameterValues("sweeteners");
    String preferential = preferentialArr != null ? String.join(",", preferentialArr) : "";
    String endDate = request.getParameter("end-date");
    String endDateFlexible = request.getParameter("end_date_flexible") != null ? "1" : "0";
    String receptionMethod = request.getParameter("reception_method");
    String name = request.getParameter("name");
    String contactEmail = request.getParameter("contact_email");
    String phone = request.getParameter("phone");
    String businessTypes = request.getParameter("business_types");

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmtSido = null;
    PreparedStatement pstmtSigg = null;
    PreparedStatement pstmtEmd = null;
    ResultSet rs = null;

    System.out.println("end_date: " + endDate);
    System.out.println("end_date_f: " + endDateFlexible);

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        if (jobId != null && !jobId.isEmpty()) {
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
            String querySido = "SELECT sido_address_id FROM sido_address WHERE name LIKE ?";
            pstmtSido = conn.prepareStatement(querySido);
            pstmtSido.setString(1, "%" + sidoName + "%");
            rs = pstmtSido.executeQuery();
            if (rs.next()) {
                sidoAddressId = rs.getInt("sido_address_id");
            }
            rs.close();
            pstmtSido.close();

            // sigg_address_id 조회
            int siggAddressId = 0;
            String querySigg = "SELECT sigg_address_id FROM sigg_address WHERE sido_address_id = ? AND name LIKE ?";
            pstmtSigg = conn.prepareStatement(querySigg);
            pstmtSigg.setInt(1, sidoAddressId);
            pstmtSigg.setString(2, "%" + siggName + "%");
            rs = pstmtSigg.executeQuery();
            if (rs.next()) {
                siggAddressId = rs.getInt("sigg_address_id");
            }
            rs.close();
            pstmtSigg.close();

            // emd_address_id 조회
            int emdAddressId = 0;
            String queryEmd = "SELECT emd_address_id FROM emd_address WHERE sido_address_id = ? AND sigg_address_id = ? AND name LIKE ?";
            pstmtEmd = conn.prepareStatement(queryEmd);
            pstmtEmd.setInt(1, sidoAddressId);
            pstmtEmd.setInt(2, siggAddressId);
            pstmtEmd.setString(3, "%" + emdName + "%");
            rs = pstmtEmd.executeQuery();
            if (rs.next()) {
                emdAddressId = rs.getInt("emd_address_id");
            }
            rs.close();
            pstmtEmd.close();

            // 연령 제한 텍스트 설정
            if ("limit".equals(age)) {
                age = ageMin + "세~" + ageMax + "세 이하";
            }

            String query = "UPDATE job_posting SET business_content = ?, address = ?, title = ?, company = ?, employment_type = ?, person = ?, day = ?, day_option = ?, week = ?, time = ?, salary_type = ?, salary = ?, salary_option = ?, sex = ?, age = ?, academy = ?, preferential = ?, end_date = ?, register_type = ?, name = ?, mail = ?, phone = ?, sido_address_id = ?, sigg_address_id = ?, emd_address_id = ? WHERE job_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, business);
            pstmt.setString(2, address + ", " + detailAddress + extraAddress);
            pstmt.setString(3, title);
            pstmt.setString(4, company);
            pstmt.setString(5, employmentType);
            pstmt.setString(6, person);
            pstmt.setString(7, period);
            pstmt.setString(8, periodFlexible);
            pstmt.setString(9, week);
            pstmt.setString(10, timeFlexible.equals("1") ? "null~null" : startTime + "~" + endTime);
            pstmt.setString(11, salaryType);
            pstmt.setString(12, salary);
            pstmt.setString(13, salaryFlexible);
            pstmt.setString(14, sex);
            pstmt.setString(15, age);
            pstmt.setString(16, scholarship);
            pstmt.setString(17, preferential);
            pstmt.setString(18, endDateFlexible.equals("1") ? null : endDate);
            pstmt.setString(19, receptionMethod);
            pstmt.setString(20, name);
            pstmt.setString(21, contactEmail);
            pstmt.setString(22, phone);
            pstmt.setInt(23, sidoAddressId);
            pstmt.setInt(24, siggAddressId);
            pstmt.setInt(25, emdAddressId);
            pstmt.setInt(26, Integer.parseInt(jobId));

            int rows = pstmt.executeUpdate();
            pstmt.close();

            if (rows > 0) {
                // 기존 업직종 데이터 삭제
                String deleteBusinessTypesQuery = "DELETE FROM job_business_type WHERE job_id = ?";
                pstmt = conn.prepareStatement(deleteBusinessTypesQuery);
                pstmt.setInt(1, Integer.parseInt(jobId));
                pstmt.executeUpdate();
                pstmt.close();

                // 새로운 업직종 데이터 삽입
                if (businessTypes != null && !businessTypes.isEmpty()) {
                    String[] businessTypeArr = businessTypes.split(",");
                    String businessTypeQuery = "SELECT business_id, business_detail_id FROM business_type_detail WHERE name = ?";
                    String jobBusinessTypeInsertQuery = "INSERT INTO job_business_type (job_id, business_id, business_detail_id) VALUES (?, ?, ?)";
                    for (String type : businessTypeArr) {
                        pstmt = conn.prepareStatement(businessTypeQuery);
                        pstmt.setString(1, type.trim());
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                            int businessId = rs.getInt("business_id");
                            int businessDetailId = rs.getInt("business_detail_id");

                            pstmt.close();
                            rs.close();
                            
                            pstmt = conn.prepareStatement(jobBusinessTypeInsertQuery);
                            pstmt.setInt(1, Integer.parseInt(jobId));
                            pstmt.setInt(2, businessId);
                            pstmt.setInt(3, businessDetailId);
                            pstmt.executeUpdate();
                            pstmt.close();
                        } else {
                            rs.close();
                            pstmt.close();
                        }
                    }
                }

                out.println("<script>alert('공고가 수정되었습니다.'); window.top.location.href='myPage.jsp';</script>");
            } else {
                out.println("<script>alert('데이터 저장에 실패했습니다.'); history.back();</script>");
            }
        } else {
            out.println("<script>alert('유효하지 않은 공고 ID입니다.'); history.back();</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('SQL 오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmtSido != null) try { pstmtSido.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmtSigg != null) try { pstmtSigg.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmtEmd != null) try { pstmtEmd.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
