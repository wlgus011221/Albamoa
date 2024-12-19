<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.*" %>
<%
    String sidoName = request.getParameter("sido");
    String sigunguId = request.getParameter("sigungu");
    
    int sigunguAddressId = Integer.parseInt(sigunguId);
    
    JSONArray jsonArray = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web_db", "root", "123456");

        // 1단계: sido_name으로 sido_id를 조회
        String getSidoIdSql = "SELECT sido_address_id FROM SIDO_ADDRESS WHERE name = ?";
        pstmt = conn.prepareStatement(getSidoIdSql);
        pstmt.setString(1, sidoName);
        rs = pstmt.executeQuery();
        
        int sidoId = -1;
        if (rs.next()) {
            sidoId = rs.getInt("sido_address_id");
        }

        rs.close();
        pstmt.close();

        if (sidoId != -1) {
            if (sigunguAddressId != -1) {
                // 3단계: sigg_address_id로 읍면동 데이터 조회
                String getDongSql = "SELECT emd_address_id, name FROM EMD_ADDRESS WHERE sido_address_id = ? AND sigg_address_id = ?";
                pstmt = conn.prepareStatement(getDongSql);
                pstmt.setInt(1, sidoId);
                pstmt.setInt(2, sigunguAddressId);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("value", rs.getInt("emd_address_id"));
                    jsonObject.put("text", rs.getString("name"));
                    jsonArray.put(jsonObject);
                }
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
