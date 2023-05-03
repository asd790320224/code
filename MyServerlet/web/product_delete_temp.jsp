<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/20
  Time: 15:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>下架商品</title>
</head>
<body>
<%
  int pid = -1;
  if (request.getParameter("pid")!=null)
    pid = Integer.parseInt(request.getParameter("pid"));
  String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
  Connection conn;
  try {
      try {
          conn = DriverManager.getConnection(url, "eshop", "93576881");
          PreparedStatement deleteStmt = conn.prepareStatement(
                  "DELETE FROM 商品信息 WHERE 商品id = ?");
          deleteStmt.setInt(1, pid);
          int deleteResult = deleteStmt.executeUpdate();
          if (deleteResult > 0) {
              System.out.println("商品下架成功！");
          } else {
              System.out.println("商品下架失败！");
          }
          conn.close();
          response.sendRedirect("product_manage.jsp");
      } catch (SQLException e) {
          throw new RuntimeException(e);
      }
  } catch (RuntimeException e) {
      throw new RuntimeException(e);
  }
%>
</body>
</html>
