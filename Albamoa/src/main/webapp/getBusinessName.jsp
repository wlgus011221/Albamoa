<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>

<%
    String businessType = request.getParameter("businessType");

    String url = "jdbc:mysql://localhost:3306/web_db"; // 데이터베이스 URL
    String dbUsername = "root"; // 데이터베이스 사용자 이름
    String dbPassword = "123456"; // 데이터베이스 비밀번호

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // business_type_name을 통해 business_id 가져오기
        String getIdQuery = "SELECT business_id FROM business_type WHERE name = ?";
        pstmt = conn.prepareStatement(getIdQuery);
        pstmt.setString(1, businessType);
        rs = pstmt.executeQuery();

        int businessId = 0;
        if (rs.next()) {
            businessId = rs.getInt("business_id");
        }
        
        pstmt.close();
        rs.close();

        if (businessId != 0) {
            // business_id를 통해 상세 업직종 가져오기
            String query = "SELECT name FROM business_type_detail WHERE business_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, businessId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("value", rs.getString("name"));
                jsonObject.put("text", rs.getString("name"));
                jsonArray.put(jsonObject);
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    out.print(jsonArray.toString());
%>
