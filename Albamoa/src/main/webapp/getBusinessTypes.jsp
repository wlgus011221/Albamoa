<%@ page contentType="application/json;charset=UTF-8" %>
<%@ page import="java.sql.*, org.json.*" %>
<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray jsonArray = new JSONArray();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web_db", "root", "123456");

        String sql = "SELECT business_id, name FROM business_type";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("value", rs.getInt("business_id"));
            jsonObject.put("text", rs.getString("name"));
            jsonArray.put(jsonObject);
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
