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
    <title>管理员主页</title>
</head>
<body>


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
    <a href="main.jsp">返回主页</a>
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
        rs = st.executeQuery("SELECT * FROM 商品信息");
        while (rs.next()) {
            Map<String, String> item = new HashMap<>();
            item.put("name", rs.getString("商品名称"));
            item.put("pid", String.valueOf(rs.getInt("商品id")));
            item.put("price", String.valueOf(rs.getDouble("商品价格")));
            item.put("popular", String.valueOf(rs.getInt("浏览次数")));
            item.put("sell", String.valueOf(rs.getInt("销量")));
            item.put("sum", String.valueOf(rs.getDouble("商品价格") *rs.getInt("销量")));
            item.put("stock", String.valueOf(rs.getInt("库存")));
            item.put("up", rs.getString("商家"));
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
        result = stmt.executeQuery("SELECT * FROM 账号数据 ORDER BY 用户类型");
        while (result.next()) {
            Map<String, String> info = new HashMap<>();
            info.put("user", result.getString("用户名"));
            info.put("email", result.getString("电子邮箱"));
            info.put("type", result.getString("用户类型"));
            infos.add(info);
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


<h1 align="center">账号列表</h1>
<table >
    <thead>
    <tr>
        <th style="font-size: 1.25em;">用户类型</th>
        <th style="font-size: 1.25em;">用户名</th>
        <th style="font-size: 1.25em;">电子邮箱</th>
    </tr>
    </thead>
    <tbody>
    <% for (Map<String, String> info : infos) { %>
    <tr>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("type") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("user") %></td>
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= info.get("email") %></td>
    </tr>
    <% } %>
    </tbody>
</table>





<h1 align="center">商品信息</h1>
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
        <th style="font-size: 1.25em;">商家</th>
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
        <td style="padding: 15px; font-size: 1.2em; vertical-align: middle;"><%= item.get("up") %></td>
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

