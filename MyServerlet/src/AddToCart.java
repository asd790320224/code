import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AddToCart", value = "/AddToCart")
public class AddToCart extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";
        String pid = req.getParameter("productId");
        String username = null;
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 如果找到了登录状态的 Cookie
                if (cookie.getName().equals("LoginInfo")) {
                    String[] values = cookie.getValue().split("\\|");
                    username = values[1];
                }
            }
        }
        try {
            Connection conn;
            PreparedStatement pstmt;
            try {
                conn = DriverManager.getConnection(url, "eshop", "93576881");
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            String sql = "SELECT COUNT(*) FROM 购物车 WHERE 用户=? AND 商品id=?";
            try {
                pstmt = conn.prepareStatement(sql);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            pstmt.setString(1, username);
            pstmt.setString(2, pid);
            ResultSet rs = pstmt.executeQuery();
            int count = 0;
            if (rs.next()) {
                count = rs.getInt(1);
            }
            rs.close();
            pstmt.close();

            if (count == 0) {
                // 如果购物车表中不存在该用户和商品的记录，则插入新的记录
                sql = "INSERT INTO 购物车 VALUES (?, ?, 1)";
                try {
                    pstmt = conn.prepareStatement(sql);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            } else {
                // 如果购物车表中已存在该用户和商品的记录，则将数量加1
                sql = "UPDATE 购物车 SET 数量=数量+1 WHERE 用户=? AND 商品id=?";
                try {
                    pstmt = conn.prepareStatement(sql);
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
            }
            pstmt.setString(1, username);
            pstmt.setString(2, pid);
            pstmt.executeUpdate();
            pstmt.close();


            sql = "UPDATE 商品信息 SET 浏览次数=浏览次数+1 WHERE 商品id=?";
            try {
                pstmt = conn.prepareStatement(sql);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            pstmt.setString(1, pid);
            pstmt.executeUpdate();
            pstmt.close();
            HttpSession session = req.getSession();
            String message = "已成功添加至购物车";
            session.setAttribute("message",message);
            resp.sendRedirect("main.jsp");

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
