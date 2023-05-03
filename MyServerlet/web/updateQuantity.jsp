<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 17:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>购物车更新</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%
  String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
  int pid = Integer.parseInt(request.getParameter("pid"));
  int quantity = Integer.parseInt(request.getParameter("quantity"));
  try {
    Connection conn = DriverManager.getConnection(url, "eshop", "93576881");
    PreparedStatement pstmt = conn.prepareStatement("UPDATE 购物车 SET 数量 = ? WHERE 商品id = ?");
    pstmt.setInt(1, quantity);
    pstmt.setInt(2, pid);
    pstmt.executeUpdate();
    conn.close();
  } catch (SQLException e) {
    // 处理异常
  }
%>
<% response.sendRedirect("customers.jsp"); %>
</body>
</html>
