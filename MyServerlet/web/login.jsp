<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/6
  Time: 20:19
  To change this template use File | Settings | File Templates.
--%>
<script>
    function jump(){
        window.location.href="register.jsp";
    }
</script>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物网站登录页面</title>
    <%
        boolean isLoggedIn = false;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 如果找到了登录状态的 Cookie
                if (cookie.getName().equals("LoginInfo")) {
                    String[] values = cookie.getValue().split("\\|");
                    isLoggedIn = Boolean.parseBoolean(values[0]);// 将登录状态设为 true
                }
            }
        }
        if (isLoggedIn)
        {
            response.sendRedirect("main.jsp");
        }
    %>
</head>
<body>
<form action="LoginServlet" method="post">
    <br><br><br>
    <h1 align="center">用户登录</h1>
    <table align="center">
        <tr>
            <td>用户账号：</td>
            <td><input type="text" value="" name="username"/></td>
        </tr>
        <tr>
            <td>用户密码：</td>
            <td><input type="password" value="" name="password"/></td>
        </tr>
        <tr>
            <td><input type="button" value="注册账号" onclick="window.location.href='register.jsp'"></td>

            <td><input type="submit" style="text-align:right" value="登录"></td>
        </tr>
    </table>
</form>

<%
    String mess=(String)session.getAttribute("message");  //接收后台传来的message
    if(mess!=null&&!mess.equals(""))
    {  //判断message
    %>
<script type="text/javascript">
    alert("<%=mess%>");  //弹出警示框
</script>
<%
        session.setAttribute("message","");  //将message值设为空，否则将一直弹出。
    }
%>


</body>
</html>
