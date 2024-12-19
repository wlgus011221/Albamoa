<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- 검색엔진 백업 -->
<%
	String userKeyword = request.getParameter("query");

    if (userKeyword == null || userKeyword.isEmpty()) {
        out.println("<script>alert('검색 키워드를 입력하세요.'); history.back();</script>");
        return;
    }

    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    List<Integer> jobIds = new ArrayList<>();

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        String query;
        if (userKeyword.length() <= 2) {
            query = "SELECT job_id FROM job_posting WHERE title LIKE ? OR business_content LIKE ? OR address LIKE ? OR company LIKE ? " +
                    "UNION SELECT j.job_id FROM job_posting j JOIN job_business_type jb ON j.job_id = jb.business_detail_id " +
                    "JOIN business_type_detail b ON jb.business_detail_id = b.business_detail_id WHERE b.name LIKE ?";
            pstmt = conn.prepareStatement(query);
            String keywordPattern = "%" + userKeyword + "%";
            pstmt.setString(1, keywordPattern);
            pstmt.setString(2, keywordPattern);
            pstmt.setString(3, keywordPattern);
            pstmt.setString(4, keywordPattern);
            pstmt.setString(5, keywordPattern);
        } else {
            query = "SELECT job_id FROM job_posting WHERE MATCH(title, business_content, address, company) AGAINST(?) " +
                    "UNION SELECT j.job_id FROM job_posting j JOIN job_business_type jb ON j.job_id = jb.business_detail_id " +
                    "JOIN business_type_detail b ON jb.business_detail_id = b.business_detail_id WHERE MATCH(b.name) AGAINST(?)";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, userKeyword);
            pstmt.setString(2, userKeyword);
        }

        rs = pstmt.executeQuery();
        while (rs.next()) {
            jobIds.add(rs.getInt("job_id"));
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
    }

    List<String[]> postList = new ArrayList<>();

    if (!jobIds.isEmpty()) {
        try {
            // 추가 데이터 가져오기
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, username, password);

            for (Integer jobId : jobIds) {
                String jobQuery = "SELECT * FROM job_posting WHERE job_id = ?";
                pstmt = conn.prepareStatement(jobQuery);
                pstmt.setInt(1, jobId);

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

                    if (post[7].equals("null~null")) {
                        post[7] = "시간협의";
                    }

                    postList.add(post);
                }
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
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
