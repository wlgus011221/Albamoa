<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.*" %>
<%
    String sidoName = request.getParameter("sido");
    JSONArray jsonArray = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web_db", "root", "123456");

        // 1단계: sido_name으로 sido_address_id를 조회
        String getSidoIdSql = "SELECT sido_address_id FROM SIDO_ADDRESS WHERE name = ?";
        pstmt = conn.prepareStatement(getSidoIdSql);
        pstmt.setString(1, sidoName);
        rs = pstmt.executeQuery();
        
        int sidoAddressId = -1;
        if (rs.next()) {
            sidoAddressId = rs.getInt("sido_address_id");
        }

        rs.close();
        pstmt.close();

        if (sidoAddressId != -1) {
            // 2단계: sido_address_id로 시군구 데이터 조회
            String getSigunguSql = "SELECT sigg_address_id, name FROM SIGG_ADDRESS WHERE sido_address_id = ?";
            pstmt = conn.prepareStatement(getSigunguSql);
            pstmt.setInt(1, sidoAddressId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("value", rs.getInt("sigg_address_id"));
                jsonObject.put("text", rs.getString("name"));
                jsonArray.put(jsonObject);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    out.print(jsonArray.toString());
%>
