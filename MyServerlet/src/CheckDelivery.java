import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "CheckDelivery", value = "/CheckDelivery")
public class CheckDelivery extends HttpServlet {
    static String url = "jdbc:sqlserver://localhost:1433;database=电商数据;encrypt=false";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) {
        int id = Integer.parseInt(req.getParameter("id"));
        Connection conn;
        try {
            conn = DriverManager.getConnection(url, "eshop", "93576881");
            PreparedStatement updateStmt = conn.prepareStatement(
                    "UPDATE 处理信息 SET 进度 = 1 WHERE 单号=?");
            updateStmt.setInt(1, id);
            int updateResult = updateStmt.executeUpdate();
            if (updateResult > 0) {
                System.out.println("处理信息成功！");
            } else {
                System.out.println("处理信息失败！");
            }
            HttpSession session = req.getSession();
            String message = "已将该单移至成交目录下";
            session.setAttribute("message", message);
            resp.sendRedirect("merchants.jsp");
        } catch (SQLException | IOException e) {
            throw new RuntimeException(e);
        }

    }

}
