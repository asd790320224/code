<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/21
  Time: 2:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>已交易目录</title>
</head>
<body>
<%
    boolean isLoggedIn = false;
    Cookie[] cookies = request.getCookies();
    String username = null;
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            // 如果找到了登录状态的 Cookie
            if (cookie.getName().equals("LoginInfo")) {
                String[] values = cookie.getValue().split("\\|");
                isLoggedIn = Boolean.parseBoolean(values[0]);// 将登录状态设为 true
                username = values[1];
                String role = values[2];
                session.setAttribute("username",username);
                session.setAttribute("role",role);
            }
        }
    }
    if (!isLoggedIn)
    {
        out.println("<script>");
        out.println("alert(\"登陆已过期，请重新登录\");");
        out.println("setTimeout(function() {");
        out.println("    window.location.href = \"login.jsp\";");
        out.println("}, 500);");
        out.println("</script>");
    }
%>

<style>
    .user-status {
        position: absolute;
        top: 0;
        left: 0;
        font-size: 20px;
    }
    .user-status a {
        color: #000;
        text-decoration: none;
        font-size: 20px;
    }
    .user-status a:hover {
        color: #999;
    }
</style>

<div class="user-status">
    <a href="role_choose_temp.jsp">
        <%= session.getAttribute("username") %>
        <%= session.getAttribute("role") %>
    </a>
    <a href="main.jsp">返回主页</a>
    <br><a href="product_upload.jsp">上传商品</a>
    <a href="product_manage.jsp">管理商品</a>
    <a href="product_trade_show.jsp">交易目录</a>
    <br><a href="logout_temp.jsp">注销</a>
</div>

<%
    List<Map<String, String>> items = new ArrayList<>();
    List<Map<String, String>> infos = new ArrayList<>();
    String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
    // 使用 JDBC 连接数据库，查询 "购物车" 表中用户 id 为 username 的数据
    Connection conn;
    try {
        conn = DriverManager.getConnection(url, "eshop", "93576881");
        Statement stmt = conn.createStatement();
        ResultSet result;
        result = stmt.executeQuery("SELECT * FROM 处理信息 WHERE 商家 = '" + username + "'");
        while (result.next()) {
            if(result.getInt("进度")==1) {
                Map<String, String> info = new HashMap<>();
                info.put("buyer", result.getString("用户"));
                info.put("id", result.getString("单号"));
                int pid = result.getInt("商品id");
                info.put("pid", String.valueOf(pid));
                double price = result.getInt("单价");
                info.put("product", result.getString("商品名"));
                info.put("price", String.valueOf(price));
                info.put("quantity", String.valueOf(result.getInt("数量")));
                info.put("sum", String.valueOf(price * result.getInt("数量")));
                String timeStr = result.getTimestamp("日期").toString().substring(0, result.getTimestamp("日期").toString().indexOf("."));
                info.put("datetime", timeStr);
                info.put("email", result.getString("用户邮箱"));
                infos.add(info);
            }
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>

<style>
    table {
        margin: 0 auto;
        border-spacing: 30px;
    }

</style>


<h1 align="center">交易汇总</h1>
<table >
    <thead>
    <tr>
        <th style="font-size: 1.25em;">客户名</th>
        <th style="font-size: 1.25em;">商品名</th>
        <th style="font-size: 1.25em;">单价￥</th>
        <th style="font-size: 1.25em;">数量</th>
        <th style="font-size: 1.25em;">实付￥</th>
        <th style="font-size: 1.25em;">日期</th>
        <th style="font-size: 1.25em;">客户邮箱</th>
    </tr>
    </thead>
    <tbody>
    <% for (Map<String, String> info : infos) { %>
    <tr>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("buyer") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("product") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("price") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("quantity") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("sum") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("datetime") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("email") %></td>
    </tr>
    <% } %>
    </tbody>
</table>

</body>
</html>
