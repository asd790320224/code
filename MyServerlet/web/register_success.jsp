<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/16
  Time: 14:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
  String username =request.getParameter("username");
  String password = request.getParameter("password");
  String email = request.getParameter("email");
  String role ;
  if (request.getParameter("role").equals("1"))
    role = "买家";
  else
    role = "卖家";
%>

<h1 align="center">注册成功</h1>
<table align="center">
  <tr>
    <td>注册用户名：</td>
    <td><%out.println(username);%></td>
  </tr>
  <tr>
    <td>注册密码：</td>
    <td><%out.println(password);%></td>
  </tr>
  <tr>
    <td>注册邮箱：</td>
    <td><%out.println(email);%></td>
  </tr>
  <tr>
    <td>注册用途：</td>
    <td><%out.println(role);%></td>
  </tr>
</table>


</body>
<br>
<p align="center">注册成功，请移步到登陆页面进行登录</p>
<p align="center"><a href="login.jsp" >登录</a></p>
</html>
