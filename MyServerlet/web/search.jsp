<%@ page import="java.util.Base64" %>
<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 21:57
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>搜索结果</title>
</head>
<body>
<%
    boolean isLoggedIn = false;
    Cookie[] cookies = request.getCookies();
    String username;
    String role = null;
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            // 如果找到了登录状态的 Cookie
            if (cookie.getName().equals("LoginInfo")) {
                String[] values = cookie.getValue().split("\\|");
                isLoggedIn = Boolean.parseBoolean(values[0]);// 将登录状态设为 true
                username = values[1];
                role = values[2];
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
    <%
        if ("商家".equals(session.getAttribute("role"))) {
    %>
    <br><a href="product_upload.jsp">上传商品</a>
    <a href="product_manage.jsp">管理商品</a>
    <%
        }
    %>
    <br><a href="logout_temp.jsp">注销</a>
</div>

<style>
    .container {
        display: flex;
        justify-content: flex-end;
    }
    #search-form input,
    #search-form button {
        font-size: 20px;
        height: 40px;
        width: 200px;
    }
</style>

<div class="container">
    <form action="search.jsp" method="post" accept-charset="UTF-8">
        <input type="text" id="search-form" name="search" />
        <button type="submit">搜索</button>
    </form>
</div>

<style>
    .product-list {
        display: flex;
        flex-wrap: wrap;
    }
    .product {
        width: 300px;
        margin: 100px;
    }
</style>

<h1 align="center">搜索结果</h1>
<div class="product-list">
<%
  String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
  request.setCharacterEncoding("UTF-8");
  String searchValue = request.getParameter("search");
  Connection conn;
  try {
      // 执行 SQL 查询，获取所有商品信息
    conn = DriverManager.getConnection(url,"eshop","93576881");
    PreparedStatement stmt;
    String sql = "SELECT * FROM 商品信息 WHERE 商品名称 LIKE ? OR 商品描述 LIKE ? OR 商家 LIKE ?";
    stmt = conn.prepareStatement(sql);
    stmt.setString(1, "%" + searchValue + "%");
    stmt.setString(2, "%" + searchValue + "%");
    stmt.setString(3, "%" + searchValue + "%");
    ResultSet rs = stmt.executeQuery();
    // 遍历结果集，输出每个商品的信息

        while (rs.next()) {
            String name = rs.getString("商品名称");
            String description = rs.getString("商品描述");
            double price = rs.getDouble("商品价格");
            int id = rs.getInt("商品id");
            int popular = rs.getInt("浏览次数");
            int stock = rs.getInt("库存");
            int sell = rs.getInt("销量");
            String seller = rs.getString("商家");
            String email = rs.getString("联系邮箱");
            byte[] thumbnailData = rs.getBytes("缩略图");
            out.println("<div class='product'>");
            out.println("  <table>");
            out.println("    <tr>");
            if (thumbnailData != null) {
                out.println("      <td>");
                out.println("        <img src='data:image/jpeg;base64," + Base64.getEncoder().encodeToString(thumbnailData) + "' alt='缩略图' width='190' height='190'>");
                out.println("      </td>");
            }
            out.println("      <td>");
            out.println("        <h3>" + name + "</h3>");
            out.println("        <p>" + description + "</p>");
            out.println("        <p>价格: " + price + "￥</p>");
            out.println("        <p>库存: " + stock + " 件</p>");
            out.println("        <p>总销量: " + sell + " 件</p>");
            out.println("      </td>");
            out.println("    </tr>");
            out.println("  </table>");
            out.println("  <form method='post' action='AddToCart'>");
            out.println("    <input type='hidden' name='productId' value='" + id + "'>");
            if(role != null && role.equals("顾客"))
                out.println("    <input type='submit' value='添加至购物车'>");
            out.println("  </form>");
            out.println("</div>");
        }

  }catch (SQLException ignored) {
  }
%>

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
