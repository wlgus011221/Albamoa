<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	String u_id = request.getParameter("userid");
	String u_pw = request.getParameter("password");
	String u_name = request.getParameter("name");
	String u_nickname = request.getParameter("nickname");
	String u_phone = request.getParameter("phone");
	String u_mail = request.getParameter("email");
	String u_birth = request.getParameter("birthYear") + "-" + request.getParameter("birthMonth") + "-" + request.getParameter("birthDay");
	String u_sex = request.getParameter("gender");
	String str_sido = request.getParameter("sido");
	String str_sigg = request.getParameter("sigungu");
	String str_emd = request.getParameter("dong");

	
	Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    int u_sido = -1;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/web_db", "root", "123456");

        // 1단계: sido_name으로 sido_address_id를 조회
        String getSidoIdSql = "SELECT sido_address_id FROM SIDO_ADDRESS WHERE name = ?";
        pstmt = conn.prepareStatement(getSidoIdSql);
        pstmt.setString(1, str_sido);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            u_sido = rs.getInt("sido_address_id");
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
	
	int u_sigg = 0;
	int u_emd = 0;
	try {
		u_sigg = Integer.parseInt(request.getParameter("sigungu"));
		u_emd = Integer.parseInt(request.getParameter("dong"));
	} catch (NumberFormatException e) {
		out.println("<script>alert('주소 정보가 올바르지 않습니다.');history.back();</script>");
		return;
	}
	
	String sql = "INSERT INTO user(id, pw, name, phone, mail, birth, sex, nickname, sido_address_id, sigg_address_id, emd_address_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
	String driveName="com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/web_db";
	String username = "root";
	String password = "123456";
	
	try {
		Class.forName(driveName);
		conn = DriverManager.getConnection(url, username, password);
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, u_id);
		pstmt.setString(2, u_pw);
		pstmt.setString(3, u_name);
		pstmt.setString(4, u_phone);
		pstmt.setString(5, u_mail);
		pstmt.setString(6, u_birth);
		pstmt.setString(7, u_sex);
		pstmt.setString(8, u_nickname);
		pstmt.setInt(9, u_sido);
		pstmt.setInt(10, u_sigg);
		pstmt.setInt(11, u_emd);
		
		int count = pstmt.executeUpdate();
		if(count == 1){
			out.println("<script>alert('회원가입 되었습니다.'); location.href='login.jsp';</script>");
		} else{
			out.println("<script>alert('회원가입 실패');history.back();</script>");
		}
	} catch (Exception e) {
		e.printStackTrace();
		out.println("<script>alert('회원가입 중 오류가 발생했습니다.');history.back();</script>");
	} finally {
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
%>
