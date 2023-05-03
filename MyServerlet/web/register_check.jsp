<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/12
  Time: 15:01
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="Insert.InsertAccount"%>
<%@ page import="Select.SelectRegister" %>
<html>
<head>
    <title>注册系统数据库查重</title>
</head>
<body>
<%
  String username =request.getParameter("username");//获取账号
  String password = request.getParameter("password");//获取密码
  String email = request.getParameter("email");//获取电子邮件地址
  String role;//获取身份
  if (request.getParameter("role").equals("1"))
    role = "买家";
  else
    role = "卖家";
  if (SelectRegister.username_check(username)) {
    out.println("<script>");
    out.println("alert(\"该用户名已被注册，请重新设置用户名\");");
    out.println("setTimeout(function() {");
    out.println("    window.location.href = \"register.jsp\";");
    out.println("}, 100);");
    out.println("</script>");
  }
  else if (SelectRegister.email_check(email)) {
      out.println("<script>");
      out.println("alert(\"该邮箱地址已被注册，请重新输入邮箱地址\");");
      out.println("setTimeout(function() {");
      out.println("    window.location.href = \"register.jsp\";");
      out.println("}, 100);");
      out.println("</script>");
  }
  else {
    InsertAccount.register(username, password, email, role);
    request.setAttribute("username", username);
    request.setAttribute("password", password);
    request.setAttribute("email", email);
    request.setAttribute("role", role);
    request.getRequestDispatcher("register_success.jsp").forward(request, response);
  }
%>
</body>
</html>
