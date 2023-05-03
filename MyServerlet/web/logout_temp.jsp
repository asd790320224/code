<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.SQLException" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/16
  Time: 16:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>注销</title>
</head>
<body>
<%
    Cookie[] cookies = request.getCookies();
    String username=null;
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            // 如果找到了登录状态的 Cookie
            if (cookie.getName().equals("LoginInfo")) {
                String[] values = cookie.getValue().split("\\|");
                username = values[1];
            }
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        }
    }
    String tips = "你已成功注销";
    String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
    Connection conn = DriverManager.getConnection(url, "eshop", "93576881");
    String ip = request.getRemoteAddr();
    Date currentTime = new Date();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String formattedTime = sdf.format(currentTime);
    String state = "登出";
    try{
        String info = "insert into 状态信息 " +
                "values('"  + username +
                "','"+ ip +
                "','"+ formattedTime +
                "','"+ state +
                "')";
        PreparedStatement infops = conn.prepareStatement(info);
        infops.execute();
    }catch (SQLException e){
        e.printStackTrace();
    }
%>
<script type="text/javascript">
    alert("<%=tips%>");  //弹出警示框
</script>
<%
    response.sendRedirect("login.jsp");
%>
</body>
</html>
