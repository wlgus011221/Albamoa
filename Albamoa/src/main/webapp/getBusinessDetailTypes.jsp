<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, org.json.*, java.util.*, java.io.*" %>
<%
    BufferedReader reader = request.getReader();
    StringBuilder sb = new StringBuilder();
    String line;
    while ((line = reader.readLine()) != null) {
        sb.append(line);
    }
    JSONObject requestJson = new JSONObject(sb.toString());
    JSONArray selectedTypes = requestJson.getJSONArray("selectedTypes");

    JSONArray jsonArray = new JSONArray();

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web_db", "root", "123456");

        String sql = "SELECT business_detail_id AS value, name AS text FROM business_type_detail WHERE business_id IN (" + selectedTypes.join(",") + ")";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("value", rs.getInt("value"));
            jsonObject.put("text", rs.getString("text"));
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
