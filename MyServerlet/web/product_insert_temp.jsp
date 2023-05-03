<%@ page import="java.io.InputStream" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="Insert.ProductUploadServlet"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 2:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
  String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
  Connection conn;

  ServletFileUpload fileUpload = new ServletFileUpload();
  // 设置 FileItemFactory
  FileItemFactory factory = new DiskFileItemFactory();
  fileUpload.setFileItemFactory(factory);

  String fieldName;
  String fieldValue;

  String name = null;
  String description = null;
  String price = null;
  String stock = null;
  String phone = null;
  byte[] thumbnailData = null;

  try {
    List<FileItem> items = fileUpload.parseRequest(request);
    for (FileItem item : items) {
      // 判断是否是文本字段
      if (item.isFormField()) {
        // 获取字段名称
        fieldName = item.getFieldName();
        fieldValue = item.getString("UTF-8");
        if(fieldName.equals("name"))
          name = fieldValue;
        if(fieldName.equals("description"))
          description = fieldValue;
        if(fieldName.equals("price"))
          price = fieldValue;
        if(fieldName.equals("stock"))
          stock = fieldValue;
        if(fieldName.equals("phone"))
          phone = fieldValue;
      }
      else
      {
        fieldName = item.getFieldName();
        InputStream inputStream = item.getInputStream();
        if(fieldName.equals("thumbnail"))
          thumbnailData = inputStream.readAllBytes();
      }
    }
  } catch (FileUploadException e) {
    throw new RuntimeException(e);
  }

  if(name == null)
  {
    name = "未命名";
  }
  if(description == null)
  {
    description = "暂无该商品的描述";
  }
  if(price == null)
    price = "0";
  double price_ = Double.parseDouble(price);
  if(stock == null)
    stock = "0";
  int stock_ = Integer.parseInt(stock);
  if(phone == null || phone.length()==0) {
    phone = "无";
  }

  try {
    conn = DriverManager.getConnection(url, "eshop", "93576881");
    // 获取商家的用户名和联系邮箱
    String username = null;
    Cookie[] cookies = request.getCookies();
    for (Cookie cookie : cookies) {
      // 如果找到了登录状态的 Cookie
      if (cookie.getName().equals("LoginInfo")) {
        String[] values = cookie.getValue().split("\\|");
        username = values[1];
      }
    }
    String sql = "select 用户名 from 账号数据 ";
    Statement st = conn.createStatement();
    ResultSet rs = st.executeQuery(sql);
    List<String> a_name = new ArrayList<>();
    while (rs.next()) {
      a_name.add(rs.getString("用户名"));
    }
    Object[] c_name = a_name.toArray();
    int index = -1;
    for (int i = 0; i < c_name.length && username != null; i++) {
      if (username.equals(c_name[i])) {
        index = i;
        break;
      }
    }
    sql = "select 电子邮箱 from 账号数据 ";
    rs = st.executeQuery(sql);
    List<String> a_email = new ArrayList<>();
    while (rs.next()) {
      a_email.add(rs.getString("电子邮箱"));
    }
    Object[] c_email = a_email.toArray();
    String email = String.valueOf(c_email[index]);

    int id =ProductUploadServlet.upload(name, description, price_, phone, email, username, stock_, thumbnailData);
    if(id >= 0)
    {
      out.println("<script>");
      out.println("alert(\"已成功上架该商品，商品id为：" + id + "\");");
      out.println("setTimeout(function() {");
      out.println("    window.location.href = \"main.jsp\";");
      out.println("}, 100);");
      out.println("</script>");
    }
  } catch (SQLException ignored){
  }
%>


</body>
</html>