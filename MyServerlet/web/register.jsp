<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/6
  Time: 21:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册系统</title>
    <script>
        function input_check()
        {
            let username= document.forms["myForm"]["username"].value;
            if (username === "") {
                alert("未输入用户名");
                return false;
            }
            let password= document.forms["myForm"]["password"].value;
            if (password === "") {
                alert("未输入密码");
                return false;
            }
            if (password.length < 8) {
                alert("密码长度应不小于8位");
                return false;
            }
            if (password.length > 20) {
                alert("密码长度应不长于20位");
                return false;
            }
            let email= document.forms["myForm"]["email"].value;
            if (email === "") {
                alert("未输入邮箱地址");
                return false;
            }
        }
    </script>
</head>
<body>
<h1 align="center">注册系统</h1>
<form name="myForm" action="register_check.jsp" method="post" onsubmit="return input_check()">
    <table align="center">
        <tr>
            <td>用户名: </td>
            <td><input type="text" name="username" /></td>
        </tr>
        <tr>
            <td>用户密码：</td>
            <td><input type="password" name="password"/></td>
        </tr>
        <tr>
            <td>电子邮箱: </td>
            <td><input type="email" name="email"/></td>
        </tr>
    </table>
    <p style="text-align: center;">用户类型：商家 <input type="radio" name="role" checked="checked" value="2">
        顾客 <input type="radio" name="role" checked="checked" value="1">
    <p style="text-align: center;"><input type="submit" value="注册" /></p>
</form>

</body>
</html>
