<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>

<%
    // 세션에서 사용자 ID 가져오기
    String loggedInUserId = (String) session.getAttribute("userId");

    if (loggedInUserId == null) {
        // 로그인된 사용자가 없는 경우 로그인 페이지로 리다이렉트
        out.println("<script>alert('로그인이 필요합니다'); window.top.location.href='login.jsp';</script>");
        return;
    }

    // form에서 전달된 파라미터 값 가져오기
    String u_id = null;
    String u_pw = null;
    String u_name = null;
    String u_nickname = null;
    String u_phone = null;
    String emailId = null;
    String emailDomain = null;
    String u_mail = null;
    String u_birth = null;
    String u_sex = null;
    String str_sido = null;
    String str_sigg = null;
    String str_emd = null;

    u_id = request.getParameter("userId");
    u_pw = request.getParameter("password");
    u_name = request.getParameter("name");
    u_nickname = request.getParameter("nickname");
    u_phone = request.getParameter("phone");
    emailId = request.getParameter("emailId");
    emailDomain = request.getParameter("customDomain");
    u_birth = request.getParameter("birthYear") + "-" + request.getParameter("birthMonth") + "-" + request.getParameter("birthDay");
    u_sex = request.getParameter("gender");
    str_sido = request.getParameter("sido");
    str_sigg = request.getParameter("sigungu");
    str_emd = request.getParameter("dong");
    
	u_mail = emailId + "@" + emailDomain;

    // 값이 올바르게 전달되었는지 확인
    if (u_name == null || u_pw == null || u_nickname == null || u_mail == null || u_birth == null || u_sex == null || u_phone == null || str_sido == null || str_sigg == null || str_emd == null) {
        out.println("<script>alert('모든 필드를 올바르게 입력해주세요.'); history.back();</script>");
        return;
    }

    // 데이터베이스 연결
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    int u_sido = 0;
    int u_sigg = 0;
    int u_emd = 0;

    String driveName = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String dbUsername = "root";
    String dbPassword = "123456";

    try {
        Class.forName(driveName);
        conn = DriverManager.getConnection(url, dbUsername, dbPassword);

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

        // 2단계: sigg_name으로 sigg_address_id를 조회
        String getSiggIdSql = "SELECT sigg_address_id FROM SIGG_ADDRESS WHERE sido_address_id = ? AND name = ?";
        pstmt = conn.prepareStatement(getSiggIdSql);
        pstmt.setInt(1, u_sido);
        pstmt.setString(2, str_sigg);
        rs = pstmt.executeQuery();
        if (rs.next()) {
	        u_sigg = rs.getInt("sigg_address_id");
        }
        rs.close();
        pstmt.close();

        // 3단계: emd_name으로 emd_address_id를 조회
        String getEmdIdSql = "SELECT emd_address_id FROM EMD_ADDRESS WHERE sido_address_id = ? AND sigg_address_id = ? AND name = ?";
        pstmt = conn.prepareStatement(getEmdIdSql);
        pstmt.setInt(1, u_sido);
        pstmt.setInt(2, u_sigg);
        pstmt.setString(3, str_emd);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            u_emd = rs.getInt("emd_address_id");
        }
        rs.close();
        pstmt.close();

        // 사용자 정보 업데이트 쿼리
        String sql = "UPDATE user SET pw = ?, name = ?, nickname = ?, phone = ?, mail = ?, birth = ?, sex = ?, sido_address_id = ?, sigg_address_id = ?, emd_address_id = ? WHERE id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, u_pw);
        pstmt.setString(2, u_name);
        pstmt.setString(3, u_nickname);
        pstmt.setString(4, u_phone);
	    pstmt.setString(5, u_mail);
        pstmt.setString(6, u_birth);
        pstmt.setString(7, u_sex);
        pstmt.setInt(8, u_sido);
        pstmt.setInt(9, u_sigg);
        pstmt.setInt(10, u_emd);
        pstmt.setString(11, loggedInUserId);
        int result = pstmt.executeUpdate();
        if (result > 0) {
            out.println("<script>alert('성공적으로 수정되었습니다.'); window.top.location.href='myPage.jsp';</script>");
        } else {
            out.println("<script>alert('수정에 실패했습니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
    }    
%>