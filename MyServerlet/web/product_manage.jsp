<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/19
  Time: 16:18
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>商品管理</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

<style>
    table {
        margin: 0 auto;
        border-spacing: 30px;
    }

</style>


<%
    String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
    Connection conn;
    try {
        conn = DriverManager.getConnection(url, "eshop", "93576881");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM 商品信息 WHERE 商家 = '" + username + "'");
%>


<h1 align="center">商品信息修改</h1>

<script>//选择滚动条
    function submitForm() {
        // 获取选中的商品的 ID
        let select = document.getElementById("productId");
        let selectedIndex = select.selectedIndex;
        let options = select.options;
        let productId = options[selectedIndex].value;

        // 将商品 ID 提交到服务器
        let form = document.createElement("form");
        form.method = "post";
        form.action = "/product_manage_flash.jsp";
        form.submit();
    }
</script>

<form action = "product_manage_flash.jsp" method="post">
    <table>
        <tr>
            <td><label for="productId">选择商品:</label></td>
            <td>
                <select id="productId" name="productId">
                    <option value="-1">请选择商品并按确定</option>
                    <!-- 这里填入商品信息 --><%
                    while (rs.next()) {
                        int id = rs.getInt("商品id");
                        String name = rs.getString("商品名称");
                        out.println("<option value='" + id + "'>" + name + "</option>");
                    }
                %><!-- 省略其他商品信息 -->
                </select>
            </td>
            <td>
                <input type="submit" value="确定" onclick="submitForm()">
            </td>
        </tr>
    </table>
</form>

<%  //选择滚动条确定后，页面上要自动填充所选商品的信息
    String pid = "";
    String o_name = "";
    String o_description = "";
    String o_price = "";
    String o_phone = "";
    String o_pic = "";
    String o_stock = "";

    if(request.getAttribute("pid")!=null)
        pid = request.getAttribute("pid").toString();
    if(request.getAttribute("name")!=null)
        o_name = request.getAttribute("name").toString();
    if(request.getAttribute("description")!=null)
        o_description = request.getAttribute("description").toString();
    if(request.getAttribute("price")!=null)
        o_price = request.getAttribute("price").toString();
    if(request.getAttribute("phone")!=null)
        o_phone = request.getAttribute("phone").toString();
    if(request.getAttribute("pic")!=null)
        o_pic = request.getAttribute("pic").toString();
    if(request.getAttribute("stock")!=null)
        o_stock = request.getAttribute("stock").toString();
%>

<script>
    function input_check()
    {
        let pid= document.forms["editForm"]["pid"].value;
        if (pid === "") {
            alert("无效操作");
            return false;
        }
        let name= document.forms["editForm"]["name"].value;
        if (name === "") {
            alert("未输入商品名称");
            return false;
        }
        let price= document.forms["editForm"]["price"].value;
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
        let stock= document.forms["editForm"]["stock"].value;
        if (stock === "") {
            alert("未输入库存数量");
            return false;
        }
        let pattern = /^\d+$/;
        if (!pattern.test(stock)) {
            alert("库存数量只能为自然数");
            return false;
        }
        let phone= document.forms["editForm"]["phone"].value;
        if (!/^\d{3,4}-?\d{7,8}$/.test(phone) && !/^\d{2,4}-\d{11}$/.test(phone)) {
            alert("请输入正确的11位电话号码（可带区号）");
            return false;
        }
    }
</script>


<form name="editForm" action="updateProduct.jsp" method="post" enctype="multipart/form-data" acceptcharset="UTF-8" onsubmit="return input_check()">
    <table align="center">
        <tr>
            <td>商品名称: </td>
            <td><input type="text" id="name" name="name" value="<%= o_name %>"/></td>
        </tr>
        <tr>
            <td>商品描述：</td>
            <td><input type="text" name="description" value="<%= o_description %>"/></td>
        </tr>
        <tr>
            <td>商品价格￥: </td>
            <td><input type="text" name="price" value="<%= o_price %>"/></td>
        </tr>
        <tr>
            <td>库存数量: </td>
            <td><input type="text" name="stock" value="<%= o_stock %>"/></td>
        </tr>
        <tr>
            <td>联系电话: </td>
            <td><input type="tel" name="phone" value="<%= o_phone %>"/></td>
        </tr>
        <tr>
            <td>缩略图: </td>
            <td style="padding: 15px"><img src="data:image/png;base64,<%= o_pic %>" alt="缩略图" width='120' height='120'></td>
            <td><input type="file" name="thumbnail"></td>
        </tr>
        <tr>
            <td>
                <input type="hidden" name="pid" value="<%= pid %>">
                <input type="submit" value="修改商品">
            </td>
        </tr>
    </table>
</form>


<script>
    function deleteProduct() {
        let pid= document.forms["editForm"]["pid"].value;
        if (pid === "") {
            alert("无效操作");
            return false;
        } else {
            if (confirm('确定要删除该商品吗？')) {
                $.ajax({
                    success: function() {
                        alert('商品已删除');
                        window.location.reload();
                    }
                });
            }
        }
    }

</script>

<form name="deleteForm" action="product_delete_temp.jsp" method="post" >
    <table align="center">
            <td>
                <input type="hidden" name="pid" value="<%= pid %>">
                <input type="submit" value="下架商品" onclick="return deleteProduct()">
            </td>
    </table>
</form>

<%
    } catch (SQLException e) {
        throw new RuntimeException(e);
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
