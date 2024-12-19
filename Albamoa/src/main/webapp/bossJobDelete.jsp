<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    String jobId = request.getParameter("id");
    String jdbcDriver = "com.mysql.cj.jdbc.Driver";
    String url = "jdbc:mysql://localhost:3306/web_db";
    String username = "root";
    String password = "123456";

    Connection conn = null;
    PreparedStatement pstmtDeleteJobBusinessType = null;
    PreparedStatement pstmtDeleteJobPosting = null;
    PreparedStatement pstmtDeleteJobApply = null;
    PreparedStatement pstmtDeleteScrap = null;

    try {
        Class.forName(jdbcDriver);
        conn = DriverManager.getConnection(url, username, password);

        // 트랜잭션 시작
        conn.setAutoCommit(false);

        // job_business_type 테이블에서 해당 job_id 삭제
        String queryDeleteJobBusinessType = "DELETE FROM job_business_type WHERE job_id = ?";
        pstmtDeleteJobBusinessType = conn.prepareStatement(queryDeleteJobBusinessType);
        pstmtDeleteJobBusinessType.setInt(1, Integer.parseInt(jobId));
        pstmtDeleteJobBusinessType.executeUpdate();
        
        
     	// job_apply 테이블에서 해당 job_id 삭제
        String queryDeleteJobApply = "DELETE FROM job_apply WHERE job_id = ?";
        pstmtDeleteJobApply = conn.prepareStatement(queryDeleteJobApply);
        pstmtDeleteJobApply.setInt(1, Integer.parseInt(jobId));
        pstmtDeleteJobApply.executeUpdate();
        
     	// scrap_job 테이블에서 해당 job_id 삭제
        String queryDeleteScrap = "DELETE FROM scrap_job WHERE job_id = ?";
        pstmtDeleteScrap = conn.prepareStatement(queryDeleteJobApply);
        pstmtDeleteScrap.setInt(1, Integer.parseInt(jobId));
        pstmtDeleteScrap.executeUpdate();

        // job_posting 테이블에서 해당 job_id 삭제
        String queryDeleteJobPosting = "DELETE FROM job_posting WHERE job_id = ?";
        pstmtDeleteJobPosting = conn.prepareStatement(queryDeleteJobPosting);
        pstmtDeleteJobPosting.setInt(1, Integer.parseInt(jobId));

        int rows = pstmtDeleteJobPosting.executeUpdate();

        if (rows > 0) {
            // 트랜잭션 커밋
            conn.commit();
            out.println("<script>alert('공고가 삭제되었습니다.'); window.top.location.href='myPage.jsp';</script>");
        } else {
            // 트랜잭션 롤백
            conn.rollback();
            out.println("<script>alert('공고 삭제에 실패했습니다.'); history.back();</script>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        out.println("<script>alert('SQL 오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        if (conn != null) {
            try {
                conn.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        out.println("<script>alert('오류가 발생했습니다. 관리자에게 문의해주세요.'); history.back();</script>");
    } finally {
        if (pstmtDeleteJobBusinessType != null) try { pstmtDeleteJobBusinessType.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmtDeleteJobPosting != null) try { pstmtDeleteJobPosting.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
