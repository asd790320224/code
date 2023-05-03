<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 16:03
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>商家主页</title>
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
        Statement st = conn.createStatement();
        ResultSet rs;
        rs = st.executeQuery("SELECT * FROM 商品信息 WHERE 商家 = '" + username + "'");
        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("name", rs.getString("商品名称"));
            item.put("pid", String.valueOf(rs.getInt("商品id")));
            item.put("price", String.valueOf(rs.getDouble("商品价格")));
            item.put("popular", String.valueOf(rs.getInt("浏览次数")));
            item.put("sell", String.valueOf(rs.getInt("销量")));
            item.put("sum", String.valueOf(rs.getDouble("商品价格") *rs.getInt("销量")));
            item.put("stock", String.valueOf(rs.getInt("库存")));
            byte[] imageData = rs.getBytes("缩略图");
            String imageString = null;
            if (imageData != null)
            {
                imageString = Base64.getEncoder().encodeToString(imageData);
            }
            item.put("pic", imageString);
            items.add(item);
        }
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    try {
        conn = DriverManager.getConnection(url, "eshop", "93576881");
        Statement stmt = conn.createStatement();
        ResultSet result;
        result = stmt.executeQuery("SELECT * FROM 处理信息 WHERE 商家 = '" + username + "'");
        while (result.next()) {
            if(result.getInt("进度")==0) {
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


<h1 align="center">消息通知</h1>
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
        <th style="font-size: 1.25em;">处理进度</th>
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
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;">
            <form action="CheckDelivery" method="post">
                <input type="hidden" name="id" value="<%= info.get("id") %>">
                <input type="submit" value="已处理">
            </form>
        </td>
    </tr>
    <% } %>
    </tbody>
</table>





<h1 align="center">统计报表</h1>
<table >
    <thead>
    <tr>
        <th style="font-size: 1.25em;">商品图</th>
        <th style="font-size: 1.25em;">商品名</th>
        <th style="font-size: 1.25em;">商品 ID</th>
        <th style="font-size: 1.25em;">单价￥</th>
        <th style="font-size: 1.25em;">浏览量</th>
        <th style="font-size: 1.25em;">销量</th>
        <th style="font-size: 1.25em;">营业额￥</th>
        <th style="font-size: 1.25em;">库存</th>
    </tr>
    </thead>
    <tbody>
    <% for (Map<String, String> item : items) { %>
    <tr>
        <td style="padding: 15px"><img src="data:image/png;base64,<%= item.get("pic") %>" alt="缩略图" width='120' height='120'></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("name") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("pid") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("price") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("popular") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("sell") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("sum") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("stock") %></td>
    </tr>
    <% } %>
    </tbody>
</table>

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
