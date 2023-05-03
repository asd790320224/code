<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 15:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>用户主页</title>
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
  <br><a href="logout_temp.jsp">注销</a>
</div>

<%
  List<Map<String, String>> items = new ArrayList<>();
  List<Map<String, String>> dones = new ArrayList<>();
  String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
  // 使用 JDBC 连接数据库，查询 "购物车" 表中用户 id 为 username 的数据
  Connection conn;
  try {
    conn = DriverManager.getConnection(url, "eshop", "93576881");
    Statement st = conn.createStatement();
    Statement stmt = conn.createStatement();
    //购物车界面
    ResultSet rs = st.executeQuery("SELECT * FROM 购物车 WHERE 用户 = '" + username + "'");
    while (rs.next()) {
        Map<String, String> item = new HashMap<>();
        item.put("username", rs.getString("用户"));
        int pid = rs.getInt("商品id");
        PreparedStatement check = conn.prepareStatement("SELECT * FROM 商品信息 WHERE 商品id = ?");
        check.setInt(1, pid);
        ResultSet rc = check.executeQuery();
        if (rc.next()) {
            item.put("pid", String.valueOf(pid));
            int quantity = rs.getInt("数量");
            item.put("quantity", String.valueOf(quantity));
            ResultSet rss = stmt.executeQuery("SELECT 商品名称 FROM 商品信息 WHERE 商品id = '" + pid + "'");
            String pname = null;
            while (rss.next()) {
                pname = rss.getString("商品名称");
            }
            item.put("pname", pname);
            rss = stmt.executeQuery("SELECT 商品价格 FROM 商品信息 WHERE 商品id = '" + pid + "'");
            double price = 0;
            while (rss.next()) {
                price = rss.getDouble("商品价格");
            }
            item.put("price", String.valueOf(price));
            item.put("sum", String.valueOf(price * quantity));
            items.add(item);
        } else {
            PreparedStatement delete = conn.prepareStatement(
                    "DELETE FROM 购物车 WHERE 商品id = ?");
            delete.setInt(1, pid);
            delete.executeUpdate();
        }
    }
      rs.close();
      rs = st.executeQuery("SELECT * FROM 已购数据 WHERE 用户 = '" + username + "' ORDER BY 日期 DESC");
    while (rs.next()) {
      Map<String, String> item = new HashMap<>();
      item.put("username", rs.getString("用户"));
      item.put("id", String.valueOf(rs.getInt("单号")));
      String timeStr=rs.getTimestamp("日期").toString().substring(0, rs.getTimestamp("日期").toString().indexOf("."));
      item.put("datetime", timeStr);
      int pid = rs.getInt("商品id");
      item.put("pid", String.valueOf(pid));
      int quantity = rs.getInt("数量");
      item.put("quantity", String.valueOf(quantity));
      item.put("pname", rs.getString("商品名"));
      double price = rs.getDouble("单价");
      item.put("price", String.valueOf(price));
      item.put("sum", String.valueOf(price*quantity));
      String seller = rs.getString("商家");
      item.put("seller", seller);
      ResultSet rss = stmt.executeQuery("SELECT 电子邮箱 FROM 账号数据 WHERE 用户名 = '" + seller + "'");
      String email = null;
      while(rss.next()) {
          email = rss.getString("电子邮箱");
      }
      item.put("email", email);
      PreparedStatement pstmt = conn.prepareStatement(
              "Select 进度 FROM 处理信息 WHERE 单号 = ?");
      pstmt.setInt(1, rs.getInt("单号"));
      rss = pstmt.executeQuery();
      String status = "未发货";
      while(rss.next()){
        if(rss.getBoolean("进度"))
          status = "已发货";
      }
      item.put("status", status);

      dones.add(item);
    }
  } catch (SQLException ignored) {
  }
%>
<style>
  table {
    margin: 0 auto;
    border-spacing: 30px;
  }
  input[type="number"] {
    height: 2em; /* 调整输入框的高度 */
    width: 5em; /* 调整输入框的宽度 */
    vertical-align: middle; /* 调整输入框的垂直对齐方式 */
  }
</style>

<h1 align="center">购物车</h1>
<table>
  <thead>
  <tr>
    <th>商品名</th>
    <th>商品 ID</th>
    <th>单价￥</th>
    <th>数量</th>
    <th>总价￥</th>
    <th>操作</th>
  </tr>
  </thead>
  <tbody>
  <% for (Map<String, String> item : items) { %>
  <tr>
    <td><%= item.get("pname") %></td>
    <td><%= item.get("pid") %></td>
    <td><%= item.get("price") %></td>
    <td style="vertical-align: middle;"> <!-- 调整单元格的垂直对齐方式 -->
      <form action="updateQuantity.jsp" method="post">
        <input type="number" name="quantity" value="<%= item.get("quantity") %>" min="1" max="999">
        <input type="hidden" name="pid" value="<%= item.get("pid") %>">
        <input type="submit" value="更新">
      </form>
    </td>
    <td><%= item.get("sum") %></td>

    <td style="vertical-align: middle;"> <!-- 调整单元格的垂直对齐方式 -->
      <form action="BuyItem" method="post">
        <input type="hidden" name="pid" value="<%= item.get("pid") %>">
        <input type="hidden" name="quantity" value="<%= item.get("quantity") %>">
        <input type="hidden" name="username" value="<%= username %>">
        <input type="submit" value="购买">
      </form>
      <form action="DeleteItem" method="post">
        <input type="hidden" name="pid" value="<%= item.get("pid") %>">
        <input type="hidden" name="username" value="<%= username %>">
        <input type="submit" value="删除">
      </form>
    </td>
  </tr>
  <% } %>
  </tbody>
</table>


<h1 align="center">已购商品</h1>
<table>
  <thead>
  <tr>
    <th>单号</th>
    <th>商品名</th>
    <th>单价￥</th>
    <th>数量</th>
    <th>总价￥</th>
    <th>购买时间</th>
    <th>状态</th>
    <th>商家</th>
    <th>联系邮箱</th>
  </tr>
  </thead>
  <tbody>
  <% for (Map<String, String> done : dones) { %>
  <tr>
    <td><%= done.get("id") %></td>
    <td><%= done.get("pname") %></td>
    <td><%= done.get("price") %></td>
    <td><%= done.get("quantity") %></td>
    <td><%= done.get("sum") %></td>
    <td><%= done.get("datetime") %></td>
    <td><%= done.get("status") %></td>
    <td><%= done.get("seller") %></td>
    <td><%= done.get("email") %></td>
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
