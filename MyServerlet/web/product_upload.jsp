<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/17
  Time: 22:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"  %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
   <title>商品提交</title>
   <script>
      function input_check()
      {
        let name= document.forms["Form"]["name"].value;
        if (name === "") {
          alert("未输入商品名");
          return false;
        }
      let description= document.forms["Form"]["description"].value;
      if (description === "") {
        alert("未输入商品描述");
        return false;
      }
      let price= document.forms["Form"]["price"].value;
      if (price === "") {
        alert("未输入商品价格");
        return false;
      }
      if (isNaN(price)) {
        alert("价格必须为数字");
        return false;
      }
      if (price<0) {
        alert("价格不能为负");
        return false;
      }
      let stock= document.forms["Form"]["stock"].value;
      if (stock === "") {
        alert("未输入库存数量");
        return false;
      }
      let pattern = /^\d+$/;
      if (!pattern.test(stock)) {
        alert("库存数量只能为自然数");
        return false;
      }
    }
  </script>
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
  <a href="role_choose_temp.jsp">
    <%= session.getAttribute("username") %>
    <%= session.getAttribute("role") %>
  </a>
  <a href="main.jsp">返回主页</a>
</div>


<%
  boolean isLoggedIn = false;
  Cookie[] cookies = request.getCookies();
  if (cookies != null) {
    for (Cookie cookie : cookies) {
      // 如果找到了登录状态的 Cookie
      if (cookie.getName().equals("LoginInfo")) {
        String[] values = cookie.getValue().split("\\|");
        isLoggedIn = Boolean.parseBoolean(values[0]);// 将登录状态设为 true
        String username = values[1];
        String role = values[2];
        session.setAttribute("username",username);
        session.setAttribute("role",role);
        if(role.equals("顾客")) {
          out.println("<script>");
          out.println("alert(\"错误请求：此处为商家上传界面\");");
          out.println("setTimeout(function() {");
          out.println("    window.location.href = \"login.jsp\";");
          out.println("}, 500);");
          out.println("</script>");
        }
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

<h1 align="center">商品提交</h1>
<form name="Form" action="product_insert_temp.jsp" method="post" onsubmit="return input_check()" enctype="multipart/form-data" acceptcharset="UTF-8">
  <table align="center">
    <tr>
      <td>商品名称: </td>
      <td><input type="text" name="name" /></td>
    </tr>
    <tr>
      <td>商品描述：</td>
      <td><input type="text" name="description"/></td>
    </tr>
    <tr>
      <td>商品价格￥: </td>
      <td><input type="text" name="price"/></td>
    </tr>
    <tr>
      <td>库存: </td>
      <td><input type="number" name="stock"/></td>
    </tr>
    <tr>
      <td>联系电话: </td>
      <td><input type="tel" name="phone"/></td>
    </tr>
    <tr>
      <td>缩略图: </td>
      <td><input type="file" name="thumbnail"></td>
    </tr>
  </table>
  <p style="text-align: center;"><input type="submit" value="上传商品" /></p>
</form>

</body>
</html>
