import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.*;
import java.util.Random;

@WebServlet(name = "BuyItem", value = "/BuyItem")
public class BuyItem extends HttpServlet {
    static String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int pid = Integer.parseInt(req.getParameter("pid"));
        int quantity = Integer.parseInt(req.getParameter("quantity"));
        int stock = 0;
        Connection conn;
        try {
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            PreparedStatement checkNum = conn.prepareStatement(
                    "Select 库存 FROM 商品信息 WHERE 商品id=?");
            checkNum.setInt(1, pid);
            ResultSet rs = checkNum.executeQuery();
            if(rs.next())
            {
                stock =  rs.getInt("库存");
                if (quantity > stock)
                {
                    HttpSession session = req.getSession();
                    String message = "错误，该商品库存仅剩<" + stock + ">件";
                    session.setAttribute("message",message);
                    resp.sendRedirect("customers.jsp");
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        String username = req.getParameter("username");
        java.util.Date utilDate = new java.util.Date();
        java.sql.Timestamp sqlDate = new java.sql.Timestamp(utilDate.getTime());

        if(stock>=quantity) {
            try {
                conn = DriverManager.getConnection(url, "eshop", "93576881");

                String sql = "Select * from 商品信息 where 商品id = ?";
                PreparedStatement se = conn.prepareStatement(sql);
                se.setInt(1, pid);
                ResultSet rss = se.executeQuery();
                String seller=null;
                String product=null;
                double price = -1;
                if (rss.next()) {
                    seller = rss.getString("商家");
                    product = rss.getString("商品名称");
                    price = rss.getInt("商品价格");
                }

                //往购物数据中增加
                PreparedStatement insertStmt = conn.prepareStatement(
                        "INSERT INTO 已购数据  VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                int min = 100000000;
                int max = 999999999;
                Random random;
                try {
                    random = SecureRandom.getInstanceStrong();
                } catch (NoSuchAlgorithmException ex) {
                    throw new RuntimeException(ex);
                }
                int id = random.nextInt(max) % (max - min + 1) + min;
                insertStmt.setString(1, username);
                insertStmt.setInt(2, pid);
                insertStmt.setInt(3, quantity);
                insertStmt.setTimestamp(4, sqlDate);
                insertStmt.setInt(5, id);
                insertStmt.setString(6, product);
                insertStmt.setDouble(7, price);
                insertStmt.setString(8, seller);
                int result = insertStmt.executeUpdate();

                if (result > 0) {
                    System.out.println("购入数据插入成功！");
                } else {
                    System.out.println("购入数据插入失败！");
                }

                //删除购物车中该条数据
                PreparedStatement deleteStmt = conn.prepareStatement(
                        "DELETE FROM 购物车 WHERE 用户 = ? AND 商品id = ?");
                deleteStmt.setString(1, username);
                deleteStmt.setInt(2, pid);
                int deleteResult = deleteStmt.executeUpdate();
                if (deleteResult > 0) {
                    System.out.println("购物车删除成功！");
                } else {
                    System.out.println("购物车删除失败！");
                }
                //修改商品库存
                PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE 商品信息 SET 库存=库存 - ?, 销量=销量 + ? WHERE 商品id=?");
                updateStmt.setInt(1, quantity);
                updateStmt.setInt(2, quantity);
                updateStmt.setInt(3, pid);
                int updateResult = updateStmt.executeUpdate();
                if (updateResult > 0) {
                    System.out.println("商品信息修改成功！");
                } else {
                    System.out.println("商品信息修改失败！");
                }
                info(username,pid,quantity,sqlDate,id);
                // 使用 HttpSession 设置信息并重定向到 customers.jsp
                HttpSession session = req.getSession();
                String message = "已成功购买";
                session.setAttribute("message", message);
                resp.sendRedirect("customers.jsp");
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    protected void info(String buyer, int pid, int quantity, Timestamp date, int id)
    {
        Connection conn;
        try {
            String seller = null;
            String product = null;
            String email = null;
            double price = -1;

            conn = DriverManager.getConnection(url, "eshop", "93576881");
            String sql = "Select * from 商品信息 where 商品id = ?";
            PreparedStatement bt = conn.prepareStatement(sql);
            bt.setInt(1, pid);
            ResultSet rs = bt.executeQuery();
            if (rs.next()) {
                seller = rs.getString("商家");
                product = rs.getString("商品名称");
                price = rs.getDouble("商品价格");
            }

            sql = "Select 电子邮箱 from 账号数据 where 用户名 = ?";
            PreparedStatement et = conn.prepareStatement(sql);
            et.setString(1, buyer);
            rs = et.executeQuery();
            if (rs.next()) {
                email = rs.getString("电子邮箱");
            }
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO 处理信息 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            stmt.setString(1, buyer);
            stmt.setString(2, email);
            stmt.setInt(3, pid);
            stmt.setInt(4, quantity);
            stmt.setString(5, seller);
            stmt.setTimestamp(6, date);
            stmt.setInt(7, 0);
            stmt.setInt(8, id);
            stmt.setString(9, product);
            stmt.setDouble(10, price);
            int result = stmt.executeUpdate();
            if (result > 0) {
                System.out.println("通知商家成功！");
            } else {
                System.out.println("通知商家失败！");
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}