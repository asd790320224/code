<%@ page import="java.sql.*" %>
<%@ page import="java.util.Base64" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/20
  Time: 0:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>刷新</title>
</head>
<body>
<%
    if(request.getParameter("productId")!=null) {
        int pid = Integer.parseInt(request.getParameter("productId"));
        String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
        // 使用 JDBC 连接数据库，查询 "购物车" 表中用户 id 为 username 的数据
        Connection conn;
        try {
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            Statement st = conn.createStatement();
            ResultSet rs;
            rs = st.executeQuery("SELECT * FROM 商品信息 WHERE 商品id = '" + pid + "'");
            while (rs.next()) {
                String name = rs.getString("商品名称");
                String description = rs.getString("商品描述");
                double price = rs.getDouble("商品价格");
                int stock = rs.getInt("库存");
                String phone = rs.getString("联系电话");
                byte[] imageData = rs.getBytes("缩略图");
                String pic = null;
                if (imageData != null) {
                    pic = Base64.getEncoder().encodeToString(imageData);
                }
                request.setAttribute("pid", pid);
                request.setAttribute("name", name);
                request.setAttribute("description", description);
                request.setAttribute("price", price);
                request.setAttribute("phone", phone);
                request.setAttribute("pic", pic);
                request.setAttribute("stock", stock);
                request.getRequestDispatcher("product_manage.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    request.getRequestDispatcher("product_manage.jsp").forward(request, response);
%>
</body>
</html>
