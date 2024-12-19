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
        String getSidoIdSql = "SELECT * FROM SIDO_ADDRESS";
        pstmt = conn.prepareStatement(getSidoIdSql);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("value", rs.getInt("sido_address_id"));
            jsonObject.put("text", rs.getString("name"));
            jsonArray.put(jsonObject);
        }
        
        rs.close();
        pstmt.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }

    out.print(jsonArray.toString());
%>
