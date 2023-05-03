<%@ page import="java.sql.*" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="org.apache.commons.fileupload.FileItem" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<%@ page import="org.apache.commons.fileupload.FileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/20
  Time: 1:51
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>修改商品信息</title>
</head>
<body>
<%
    String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
    Connection conn;
    int pid = -1;
    double price = -1;
    int stock = -1;
    String name = null;
    String description = null;
    String phone = null;
    byte[] thumbnailData = null;

    ServletFileUpload fileUpload = new ServletFileUpload();
    // 设置 FileItemFactory
    FileItemFactory factory = new DiskFileItemFactory();
    fileUpload.setFileItemFactory(factory);

    String fieldName;
    String fieldValue;
    try {
        List<FileItem> items = fileUpload.parseRequest(request);
        for (FileItem item : items) {
            // 判断是否是文本字段
            if (item.isFormField()) {
                // 获取字段名称
                fieldName = item.getFieldName();
                fieldValue = item.getString("UTF-8");
                if (fieldName.equals("name"))
                    name = fieldValue;
                if (fieldName.equals("description"))
                    description = fieldValue;
                if (fieldName.equals("price"))
                    price = Double.parseDouble(fieldValue);
                if (fieldName.equals("stock"))
                    stock = Integer.parseInt(fieldValue);
                if (fieldName.equals("phone"))
                    phone = fieldValue;
                if (fieldName.equals("pid"))
                    pid = Integer.parseInt(fieldValue);
            } else {
                fieldName = item.getFieldName();
                InputStream inputStream = item.getInputStream();
                if (fieldName.equals("thumbnail"))
                    thumbnailData = inputStream.readAllBytes();
            }
        }
    } catch (FileUploadException e) {
        throw new RuntimeException(e);
    }

    try {
        conn = DriverManager.getConnection(url, "eshop", "93576881");
        PreparedStatement pstmt1 = conn.prepareStatement("UPDATE 商品信息 SET 商品名称 = ? , 商品价格 = ? , 库存 = ? WHERE 商品id = ?");
        pstmt1.setString(1,name);
        pstmt1.setString(1, name);
        pstmt1.setDouble(2, price);
        pstmt1.setInt(3, stock);
        pstmt1.setInt(4, pid);
        int result = pstmt1.executeUpdate();
        if (result > 0) {
            System.out.println("数据更新成功！");
        } else {
            System.out.println("数据更新失败！");
        }
        if (description != null) {
            description = description.trim();
            if (description.length() > 0) {
                PreparedStatement pstmt2 = conn.prepareStatement("UPDATE 商品信息 SET 商品描述 = ? WHERE 商品id = ?");
                pstmt2.setString(1, description);
                pstmt2.setDouble(2, pid);
                pstmt2.executeUpdate();
            }
        }
        if (phone != null) {
            phone = phone.trim();
            if (phone.length() > 0) {
                PreparedStatement pstmt3 = conn.prepareStatement("UPDATE 商品信息 SET 联系电话 = ? WHERE 商品id = ?");
                pstmt3.setString(1, phone);
                pstmt3.setDouble(2, pid);
                pstmt3.executeUpdate();
            }
        }
        if (thumbnailData != null) {
            PreparedStatement pstmt4 = conn.prepareStatement("UPDATE 商品信息 SET 缩略图 = ? WHERE 商品id = ?");
            pstmt4.setBytes(1, thumbnailData);
            pstmt4.setDouble(2, pid);
            pstmt4.executeUpdate();
        }
        response.sendRedirect("product_manage.jsp");
    }catch (SQLException ignored) {
    }
%>


</body>
</html>
