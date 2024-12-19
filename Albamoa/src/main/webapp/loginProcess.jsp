<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="javax.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="jakarta.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login Process</title>
</head>
<body>
<%
    // 사용자로부터 입력받은 ID와 비밀번호를 가져옵니다.
    String userId = request.getParameter("id");
    String password = request.getParameter("password");

    // 데이터베이스 연결 설정
    String url = "jdbc:mysql://localhost:3306/web_db"; // 데이터베이스 URL
    String dbUsername = "root"; // 데이터베이스 사용자 이름
    String dbPassword = "123456"; // 데이터베이스 비밀번호

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        // 데이터베이스 연결
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

        // SQL 쿼리 작성
        String sql = "SELECT * FROM user WHERE id = ? AND pw = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        pstmt.setString(2, password);
        
        // 쿼리 실행
        rs = pstmt.executeQuery();

        // 결과 처리
        if (rs.next()) {
            // 로그인 성공
            session.setAttribute("userId", userId);
            
            // 쿠키 설정
            Cookie userCookie = new Cookie("username", userId);
            userCookie.setMaxAge(60*60*24); // 1일 동안 유효
            response.addCookie(userCookie);

            response.sendRedirect("main.jsp");
        } else {
            // 로그인 실패
            out.println("<script>alert('존재하지 않는 id 혹은 pw 입니다.');history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<h3>로그인 중 오류가 발생했습니다.</h3>");
    } finally {
        // 자원 해제
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
</body>
</html>
