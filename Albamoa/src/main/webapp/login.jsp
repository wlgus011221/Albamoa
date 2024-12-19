<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login Page</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
        }

        .login-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
            text-align: center;
        }

        h2 {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 5px;
        }

        input[type="text"], input[type="password"] {
            width: calc(100% - 20px);
            padding: 10px;
            margin: 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #FD9F28;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #FD991C;
        }
        
        .links {
            text-align: center;
            margin-top: 10px;
        }

        .links a {
            margin-right: 10px;
            font-size: 12px;
            color: #007BFF;
            text-decoration: none;
        }

        .links a:hover {
            text-decoration: underline;
        }

        .signup {
            margin-top: 20px;
        }

        .signup a {
            font-size: 14px;
            color: #007BFF;
            text-decoration: none;
        }

        .signup a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form action="loginProcess.jsp" method="post">
            <div class="form-group">
                <label for="ID">ID:</label>
                <input type="text" id="id" name="id" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Login</button>
            <div class="signup">
            	<a href="signup.jsp">회원가입</a>
        	</div>
        </form>
    </div>
</body>
</html>
