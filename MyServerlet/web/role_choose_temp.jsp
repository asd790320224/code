<%--
  Created by IntelliJ IDEA.
  User: YG
  Date: 2022/12/18
  Time: 15:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <title>中转</title>
</head>
<body>
<%
  Cookie[] cookies = request.getCookies();
  String role = null;
  if (cookies != null) {
    for (Cookie cookie : cookies) {
      // 如果找到了登录状态的 Cookie
      if (cookie.getName().equals("LoginInfo")) {
        String[] values = cookie.getValue().split("\\|");
        role = values[2];
      }
    }
  }
  if (role!=null)
  {
    if(role.equals("商家"))
    {
      request.getRequestDispatcher("merchants.jsp").forward(request, response);
    }
    else
    {
      request.getRequestDispatcher("customers.jsp").forward(request, response);
    }
  }
%>

</body>
</html>
