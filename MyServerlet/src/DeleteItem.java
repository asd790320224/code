import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "DeleteItem", value = "/DeleteItem")
public class DeleteItem extends HttpServlet {
    static String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        String username = req.getParameter("username");
        int pid = Integer.parseInt(req.getParameter("pid"));
        Connection conn;
        try {
            conn = DriverManager.getConnection(url, "eshop", "93576881");
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
            HttpSession session = req.getSession();
            String message = "成功取消";
            session.setAttribute("message",message);
            resp.sendRedirect("customers.jsp");
        } catch (SQLException | IOException e) {
            throw new RuntimeException(e);
        }
    }
}
