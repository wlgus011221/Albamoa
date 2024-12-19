<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="jakarta.servlet.http.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알바모아</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    .container {
        width: 80%;
        margin: 20px auto;
        padding: 20px;
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }
    h2, h3 {
        text-align: center;
    }

    .post-header {
        font-weight: bold;
        margin-top: 10px;
        display: flex;
        justify-content: space-between;
    }
    
    .post-footer {
    	font-weight: bold;
        margin-top: 10px;
        display: flex;
        justify-content: right;
    }
    
    .post-body {
        margin-top: 20px;
        line-height: 1.6;
    }
    .comment-section {
        margin-top: 40px;
    }
    .comment {
        margin-top: 10px;
        padding: 10px;
        border-bottom: 1px solid #ccc;
    }
    .comment-form {
        margin-top: 20px;
    }
    .comment-form textarea {
        width: 98%;
        padding: 10px;
        border-radius: 4px;
        border: 1px solid #ccc;
    }
    .comment-form button {
        margin-top: 10px;
        padding: 10px 20px;
        border: none;
        background-color: #FD9F28;
        color: #fff;
        border-radius: 4px;
        cursor: pointer;
    }
    .comment-form button:hover {
        background-color: #FD991C;
    }
    /* 오른쪽 정렬을 위한 스타일 추가 */
    .right-align {
        text-align: right;
    }

    /* 댓글 섹션에서 작성자와 작성일을 오른쪽 정렬하기 위한 스타일 */
    .comment-meta {
        display: flex;
        justify-content: space-between;
    }

    .comment-meta .comment-date {
        margin-left: auto;
    }    
</style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<div class="container">
    <%
        String boardId = request.getParameter("board_id");
        if (boardId == null || boardId.trim().isEmpty()) {
            out.println("<p>잘못된 접근입니다.</p>");
        } else {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            String url = "jdbc:mysql://localhost:3306/web_db";
            String dbUsername = "root";
            String dbPassword = "123456";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, dbUsername, dbPassword);

                String updateViewQuery = "UPDATE talk_post SET view = view + 1 WHERE board_id = ?";
                pstmt = conn.prepareStatement(updateViewQuery);
                pstmt.setString(1, boardId);
                pstmt.executeUpdate();
                pstmt.close();

                String query = "SELECT T.board_id, U.nickname, T.title, T.content, T.date, T.view, T.comment " +
                        "FROM talk_post T " +
                        "INNER JOIN user U ON T.user_id = U.user_id " +
                        "WHERE T.board_id = ?";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, boardId);

                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String title = rs.getString("title");
                    String nickname = rs.getString("nickname");
                    String content = rs.getString("content");
                    String date = rs.getString("date");
                    int view = rs.getInt("view");
                    int comment = rs.getInt("comment");
    %>
    <h2><%= title %></h2>
    <div class="post-detail">
        <div class="post-header">
            <div>작성자: <%= nickname %></div>
            <div>작성일: <%= date %></div>
        </div>
        <div class="post-body">
            <%= content %>
        </div>
        <div class="post-footer">
            <div>댓글수: <%= comment %></div>
            <div>조회수: <%= view %></div>
        </div>
    </div>
    <br>
    <hr>
    <div class="comment-section">
        <h3>댓글</h3>
        <div class="comment-form">
            <form action="addComment.jsp" method="post">
                <input type="hidden" name="board_id" value="<%= boardId %>">
                <textarea name="comment" rows="4" required></textarea><br>
                <div class="right-align">
                    <button type="submit">댓글 작성</button>
                </div>
            </form>
        </div>
        <div class="comment-list">
            <%
                String commentQuery = "SELECT U.nickname, C.comment, C.date " +
                                      "FROM comment C " +
                                      "INNER JOIN user U ON C.user_id = U.user_id " +
                                      "WHERE C.board_id = ? " +
                                      "ORDER BY C.date DESC";
                pstmt = conn.prepareStatement(commentQuery);
                pstmt.setString(1, boardId);
                ResultSet commentRs = pstmt.executeQuery();
                while (commentRs.next()) {
                    String commentNickname = commentRs.getString("nickname");
                    String commentContent = commentRs.getString("comment");
                    String commentDate = commentRs.getString("date");
            %>
            <div class="comment">
                <div class="comment-meta">
                    <strong><%= commentNickname %></strong>
                    <span class="comment-date"><%= commentDate %></span>
                </div>
                <%= commentContent %>
            </div>
            <%
                }
                commentRs.close();
            %>
        </div>
    </div>
    <%
                } else {
                    out.println("<p>해당 게시글을 찾을 수 없습니다.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        }
    %>
</div>
</body>
</html>
